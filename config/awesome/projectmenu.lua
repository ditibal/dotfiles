local mmenu = require("modules.menu")

local items = {}
local projects = {
    {'autoshina', '/var/www/autoshinavrn.ru'},
    {'autoshina.local', '/var/www/autoshinavrn.local.ru'},
    {'rembox.ru', '/var/www/rembox.ru'},
    {'rembox.local', '/var/www/rembox.l.ru'},
}

for _, i in pairs(projects) do
    table.insert(items, {
        text = i[1],
        keys = {
            s = "xterm -e /bin/fish -c \"ssh -t srv 'cd ".. i[2] .."; sudo -u www-data PATH=$PATH:/var/www/.composer/vendor/bin:/var/www/bin bash'\"",
            t = "xterm -e /bin/fish -C \"cd ".. i[2] .."\"",
            r = "xterm -e /bin/fish -c \"ranger ".. i[2] .."\"",
        }
    })
end

table.insert(items, {
    text = 'shop',
    keys = {
        t = "xterm -e /bin/fish -C \"cd ~/tmp/shop\"",
        r = "xterm -e /bin/fish -c \"ranger ~/tmp/shop\"",
    }
})

table.insert(items, {
    text = 'autoshina',
    keys = {
        t = "xterm -e /bin/fish -C \"cd ~/tmp/autoshina\"",
        r = "xterm -e /bin/fish -c \"ranger ~/tmp/autoshina\"",
    }
})

return mmenu({items = items})
