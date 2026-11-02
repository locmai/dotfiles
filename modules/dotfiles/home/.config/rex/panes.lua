-- Vim-style pane navigation
rex.bind("cmd+h", "pane.focus", { direction = "left" })
rex.bind("cmd+j", "pane.focus", { direction = "down" })
rex.bind("cmd+k", "pane.focus", { direction = "up" })
rex.bind("cmd+l", "pane.focus", { direction = "right" })

-- Vim-style pane movement
rex.bind("cmd+shift+h", "pane.move", { direction = "left" })
rex.bind("cmd+shift+j", "pane.move", { direction = "down" })
rex.bind("cmd+shift+k", "pane.move", { direction = "up" })
rex.bind("cmd+shift+l", "pane.move", { direction = "right" })
