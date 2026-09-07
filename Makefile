.POSIX:
.PHONY: default build diff switch update fmt check clean optimise

# Override with `make switch host=nixos` to build a different machine
host ?= $(shell hostname -s)

default: diff switch

build:
	./scripts/rebuild.py build --flake '.#$(host)'

diff: build
	nix run nixpkgs#dix -- \
		--verbose \
		/nix/var/nix/profiles/system ./result

switch:
	sudo ./scripts/rebuild.py switch --flake '.#$(host)'

update:
	nix flake update

fmt:
	nix run nixpkgs#nixfmt-tree

check:
	nix flake check

clean:
	nix-collect-garbage --delete-old --log-format bar

optimise:
	nix store optimise
