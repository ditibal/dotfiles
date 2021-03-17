local awful = require("awful")

local awesomemenu = {
    { "manual", terminal .. " -e man awesome" },
    { "restart", awesome.restart }
}

local mainmenu = awful.menu({
    items = {
        { "dotfiles", "xterm -e /bin/fish -c \"ranger ~/dotfiles\"" },
        { "awesome", awesomemenu },
    }
})

awesome.connect_signal('show_mainmenu', function()
    mainmenu:show({keygrabber=true, coords={x=10, y=10}})
end)
