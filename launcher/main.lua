local ui = require("ui")
local sys = require("sys")

local win = ui.Window("TEST","fixed",250,100)

function wait(time)
    sleep(time*1000)
end


win:center()
win:show()



repeat ui.update()
    
until not win.visible
