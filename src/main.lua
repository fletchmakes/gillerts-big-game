-- MIT License

-- Copyright (c) 2023 David Fletcher

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.


local Plan = require "libs.plan.plan"
local Rules = Plan.Rules

local GameView = require "components.GameView"

local uiRoot = nil

-- lifecycle methods
function love.load(arg, unfilteredArg)
    -- create the game objects and organize them on-screen
    uiRoot = Plan.new()

    local rules = Rules.new()
        :addX(Plan.relative(0))
        :addY(Plan.relative(0))
        :addWidth(Plan.relative(1))
        :addHeight(Plan.relative(1))

    local gameView = GameView:new(rules)

    uiRoot:addChild(gameView);

    -- do one-time initialization
    uiRoot:emit("load")
end

function love.update(dt)
    uiRoot:update(dt)
end

function love.draw()
    uiRoot:draw()
end

function love.resize(w, h)
    uiRoot:refresh()
end

function love.quit()

end

function love.keypressed(key, scancode, isrepeat)
    uiRoot:emit("keypressed", key, scancode, isrepeat)
end
