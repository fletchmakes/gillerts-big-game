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

local Flux = require "libs.flux.flux"
local Plan = require "libs.plan.plan"
local Rules = Plan.Rules

local Container = Plan.Container
local GameView = Container:extend()

local COLORS = require "utils.Colors"

function GameView:new(rules)
    -- initialises all the container fields
    local gameView = GameView.super.new(self, rules)
    
    return gameView
end

function GameView:load()

end

function GameView:keypressed(key, scancode, isrepeat)
    self:emit("keypressed", key, scancode, isrepeat)
end

function GameView:refresh()
    GameView.super.refresh(self)
end

function GameView:update( dt )
    GameView.super.update( self, dt )
end

function GameView:draw()
    local color = COLORS.colorToHex("#FF004D")
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

    -- then we want to draw our children containers:
    GameView.super.draw(self)
end

return GameView