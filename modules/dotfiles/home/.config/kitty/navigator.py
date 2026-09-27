"""Select an agent window. List agents that need user action first."""

from __future__ import annotations

import json
import os
import re
import shlex
import subprocess
import sys
import traceback
from functools import cache

# macOS GUI applications start with a minimal PATH.
os.environ["PATH"] = os.pathsep.join(
    (
        f"/etc/profiles/per-user/{os.environ['USER']}/bin",
        "/run/current-system/sw/bin",
        "/usr/bin",
    )
)

AGENTS = {"pi", "codex"}
BLOCKED = re.compile(
    r"\[(?:y(?:es)?|n(?:o)?)/(?:y(?:es)?|n(?:o)?)\]"
    r"|\b(?:press|hit)\s+(?:enter|return)\b"
    r"|\b(?:enter|return)\s+to\s+(?:submit|confirm|accept|continue)\b"
    r"|\b(?:allow|approve|confirm)\b.*(?:\?|:)\s*$",
    re.IGNORECASE,
)
WORKING = re.compile(
    r"\b(?:esc|escape)\s+to\s+interrupt\b"
    r"|(?:\.\.\.|…)(?:\s+\([^)]*\))?\s*$",
    re.IGNORECASE,
)
STATE_STYLES = {
    "blocked": ("31", "◉"),
    "done": ("32", "●"),
    "working": ("33", "●"),
}

# Seconds between refreshes of the agent list while the picker is open.
REFRESH_INTERVAL = 1

# Remote control goes through the kitten API when running inside kitty, and
# through the `kitten @` binary when re-executed as the fzf reload helper.
IN_KITTY = True
KITTEN = "kitten"


def ansi(color: str, text: str) -> str:
    return f"\x1b[{color}m{text}\x1b[0m"


def kitty(args: list[str]) -> str:
    if IN_KITTY:
        result = main.remote_control(args, capture_output=True)
    else:
        result = subprocess.run([KITTEN, "@", *args], capture_output=True)
    if result.returncode != 0:
        error = result.stderr.decode().strip()
        raise RuntimeError(f"kitten @ {' '.join(args)} failed: {error}")
    return result.stdout.decode()


def detect_agent(window: dict) -> str | None:
    for process in window.get("foreground_processes", []):
        command = process.get("cmdline", [])
        if not command:
            continue
        agent = os.path.basename(command[0]).removeprefix(".").removesuffix("-wrapped")
        if agent in AGENTS:
            return agent
    return None


@cache
def git_branch(cwd: str) -> str:
    return subprocess.run(
        ["git", "-C", cwd, "branch", "--show-current"],
        capture_output=True,
        text=True,
    ).stdout.strip()


def detect_state(window_id: int) -> str:
    text = kitty(["get-text", "--match", f"id:{window_id}", "--extent", "screen"])
    lines = [
        line.strip()
        for line in text.splitlines()
        if any(character.isalnum() for character in line)
    ]
    if any(BLOCKED.search(line) for line in lines[-5:]) or any(
        line.endswith("?") for line in lines[-2:]
    ):
        return "blocked"
    if any(WORKING.search(line) for line in lines[-2:]):
        return "working"
    return "done"


def collect_agents(tabs: list[dict]) -> list[tuple[dict, str, str]]:
    agents = [
        (window, detect_state(window["id"]), agent)
        for tab in tabs
        for window in tab["windows"]
        if (agent := detect_agent(window)) is not None
    ]
    return sorted(agents, key=lambda item: item[1])


def format_row(window: dict, state: str, agent: str) -> str:
    color, symbol = STATE_STYLES[state]
    status = ansi(color, f"{symbol} {state}")
    cwd = window.get("cwd", "").rstrip(os.sep)
    project = ansi("1", os.path.basename(cwd) or window.get("title", ""))
    branch = git_branch(cwd)
    if branch:
        project += f" {ansi('2', '@ ' + branch)}"
    return f"{window['id']}\t{status}  {project}  {ansi('2', agent)}"


def render_rows(tabs: list[dict]) -> str:
    return "\n".join(format_row(*agent) for agent in collect_agents(tabs))


def focused_tabs() -> list[dict]:
    [os_window] = json.loads(kitty(["ls", "--match", "state:focused_os_window"]))
    return os_window["tabs"]


# Re-executed by fzf as `navigator.py --list <kitten>` on a timer, so the state
# column keeps up with the sessions instead of freezing at the first render.
if "--list" in sys.argv:
    IN_KITTY = False
    KITTEN = sys.argv[sys.argv.index("--list") + 1]
    print(render_rows(focused_tabs()))
    raise SystemExit(0)

from kitty.boss import Boss  # noqa: E402
from kitty.constants import kitten_exe  # noqa: E402
from kittens.tui.handler import kitten_ui, result_handler  # noqa: E402


def layout_spec(tab: dict) -> str:
    # kitty reports the layout name and its options separately; goto-layout needs
    # them recombined or options like split_axis are lost on restore.
    opts = ",".join(f"{key}={value}" for key, value in sorted(tab["layout_opts"].items()))
    return f"{tab['layout']}:{opts}" if opts else tab["layout"]


def restore_layout(boss: Boss, tab_id: int, layout: str) -> None:
    for tab in boss.all_tabs:
        if tab.id == tab_id:
            tab.goto_layout(layout)
            return


def pick_agent() -> str:
    # Screen detection, previews, and the refresh helper need access to all
    # Kitty windows.
    main.allow_indiscriminate_remote_control()
    tabs = focused_tabs()

    reload_command = " ".join(
        shlex.quote(part) for part in ("python3", __file__, "--list", kitten_exe())
    )
    active_tab = next(tab for tab in tabs if tab["is_active"])
    previous_layout = layout_spec(active_tab)
    tab_match = ["--match", f"id:{active_tab['id']}"]
    kitty(["goto-layout", *tab_match, "stack"])
    fzf = subprocess.run(
        [
            "fzf",
            "--ansi",
            "--delimiter=\t",
            "--with-nth=2..",
            "--layout=reverse",
            "--info=hidden",
            "--no-hscroll",
            "--no-separator",
            "--no-scrollbar",
            "--prompt=agent> ",
            # Keep the highlighted agent selected across refreshes, even when
            # its state changes and the list reorders.
            "--track",
            f"--preview={kitten_exe()} @ get-text --match=id:{{1}} --ansi",
            "--preview-window=up,follow",
            # fzf has no timer event: chain a delayed reload off every load so
            # the rows and the preview keep refreshing while the picker is open.
            f"--bind=load:refresh-preview+reload:sleep {REFRESH_INTERVAL}; {reload_command}",
        ],
        stdout=subprocess.PIPE,
        pass_fds=(main.rc_fd,),
        input=render_rows(tabs),
        text=True,
    )

    # The result handler restores the layout once the kitten overlay is gone,
    # so the tab does not flash back to its splits behind the picker.
    window_id = fzf.stdout.partition("\t")[0].strip()
    return "\t".join((window_id, str(active_tab["id"]), previous_layout))


@kitten_ui(allow_remote_control=True)
def main(args: list[str]) -> str:
    try:
        return pick_agent()
    except Exception:
        print(f"{traceback.format_exc()}\nPress Enter to close.")
        with open("/dev/tty", "rb", buffering=0) as tty:
            tty.read(1)
        return ""


@result_handler()
def handle_result(args: list[str], answer: str, target_window_id: int, boss: Boss) -> None:
    if not answer:
        return
    window_id, tab_id, previous_layout = answer.split("\t")
    restore_layout(boss, int(tab_id), previous_layout)
    if window_id:
        boss.set_active_window(boss.window_id_map[int(window_id)])
