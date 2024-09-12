import libtmux

server = libtmux.Server()
session = server.sessions.get(name="s")
window = session.attached_window
pane = window.attached_pane

pane.send_keys('Up', enter=True)

