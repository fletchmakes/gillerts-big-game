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
local Scene1 = Container:extend()

local COLORS = require "utils.Colors"

function Scene1:init(rules)
    -- initialises all the container fields
    local view = Scene1.super.new(self, rules)

    view.font = love.graphics.newFont("assets/art/WindstilChonker-Regular.ttf", 60)
    
    return view
end

function Scene1:update( dt )

end

function Scene1:draw()
    love.graphics.push("all")
        love.graphics.setFont(self.font)
        love.graphics.setColor(COLORS.colorFromHex("#FFFFFF"))

        love.graphics.print("scene 1")
    love.graphics.pop()
end

return Scene1