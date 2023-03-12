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
local Container = Plan.Container
local ToTheSurface = Container:extend()

local COLORS = require "utils.Colors"
local Button = require "components.Button"

function ToTheSurface:init(rules, parent)
    -- initialises all the container fields
    local view = ToTheSurface.super.new(self, rules)

    view.offset = 0

    view.font = love.graphics.newFont("assets/art/WindstilChonker-Regular.ttf", 40)

    view.bgImage = love.graphics.newImage("assets/art/classroom.png")

    return view
end

function ToTheSurface:setOffset(offset)
    self.offset = offset
end

function ToTheSurface:update( dt )

end

function ToTheSurface:draw()
    love.graphics.push("all")
        -- bg image
        love.graphics.draw(self.bgImage, self.offset)

    love.graphics.pop()
end

return ToTheSurface