-- configure love
function love.conf( t )
    -- https://loveref.github.io/#love.conf
    -- game identity
    t.window.title = "Gillert's Big Game"
    -- t.window.icon = "assets/img/turnip.png"
    t.console = true

    -- window settings
    t.window.width = 1024
    t.window.height = 576
    t.window.borderless = false
    t.window.resizable = true
    t.window.minwidth = 1024
    t.window.minheight = 576
    t.window.fullscreen = false
    t.window.fullscreentype = "desktop"
    t.window.vsync = true -- / 1

    -- disable unnecessary packages
    t.accelerometerjoystick = false
    t.modules.joystick = false
    t.modules.physics = false
    t.modules.touch = false
    t.modules.video = false
    t.modules.thread = false
end
