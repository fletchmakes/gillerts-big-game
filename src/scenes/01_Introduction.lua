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
local Introduction = Container:extend()

local COLORS = require "utils.Colors"
local Button = require "components.Button"

function Introduction:init(rules)
    -- initialises all the container fields
    local view = Introduction.super.new(self, rules)

    view.offset = 0

    view.font = love.graphics.newFont("assets/art/WindstilChonker-Regular.ttf", 40)

    view.bgImage = love.graphics.newImage("assets/art/classroom.png")

    view.gillertBlack = love.graphics.newImage("assets/art/gillert-black.png")
    view.gillert = love.graphics.newImage("assets/art/gillert.png")

    view.gillertVersion = view.gillertBlack

    view.text = {
        "This is the story of Gillert.",
        "Who is Gillert?",
        "Born to two mermaid parents, Gillert's genes somehow got swapped.",
        "And thus, the first reverse-mermaid was born."
    }
    view.textIdx = 1

    local nextButtonAction = function()
        if (view.textIdx < #view.text) then
            view.textIdx = view.textIdx + 1
        end
    end

    view.nextButton = Button:new("next", 0, 0, nextButtonAction)
    local buttonX = love.graphics.getWidth() - view.nextButton:getWidth() - 20
    local buttonY = love.graphics.getHeight() - view.nextButton:getHeight() - 20
    view.nextButton:setPosition(buttonX, buttonY)
    
    return view
end

function Introduction:setOffset(offset)
    self.offset = offset
    self.nextButton:setOffset(offset)
end

function Introduction:update( dt )
    self.nextButton:update(dt)

    if (self.textIdx == 4) then
        self.gillertVersion = self.gillert
    end
end

function Introduction:draw()
    love.graphics.push("all")
        -- bg image
        love.graphics.draw(self.bgImage, self.offset)

        -- gillert
        local imageX = (love.graphics.getWidth() / 2) - (self.gillertBlack:getWidth() / 2)
        local imageY = (love.graphics.getHeight() / 2) - (self.gillertBlack:getHeight() / 2) + 40
        love.graphics.draw(self.gillertVersion, imageX + self.offset, imageY)

        -- text bg
        love.graphics.setColor(COLORS.colorFromHex("#00000060"))
        love.graphics.rectangle("fill", self.offset, 0, love.graphics.getWidth(), (self.font:getHeight() * 2) + 40)

        -- text
        love.graphics.setFont(self.font)
        love.graphics.setColor(COLORS.colorFromHex("#FFFFFF"))
        love.graphics.printf(self.text[self.textIdx], 20 + self.offset, 20, love.graphics.getWidth() - 40)
    love.graphics.pop()

    self.nextButton:draw()
end

return Introduction