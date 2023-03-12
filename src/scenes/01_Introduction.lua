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
local Introduction = Container:extend()

local COLORS = require "utils.Colors"
local Button = require "components.Button"
local MermaidFamily = require "scenes.02_MermaidFamily"

function Introduction:init(rules, parent)
    -- initialises all the container fields
    local view = Introduction.super.new(self, rules)

    view.offset = 0

    view.font = love.graphics.newFont("assets/art/WindstilChonker-Regular.ttf", 40)

    view.bgImage = love.graphics.newImage("assets/art/water_bg.jpg")

    view.gillertBlack = love.graphics.newImage("assets/art/gillert-black.png")
    view.gillert = love.graphics.newImage("assets/art/gillert.png")
    view.gillertYOffset = 0
    view.animationStart = love.timer.getTime()

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
        else
            parent:nextScene()
        end
    end

    local previousButtonAction = function()
        if (view.textIdx > 1) then
            view.textIdx = view.textIdx - 1
        else
            parent:previousScene()
        end
    end

    local nextButton = Button:new("next", 0, 0, nextButtonAction)
    local nextButtonX = love.graphics.getWidth() - nextButton:getWidth() - 20
    local nextButtonY = love.graphics.getHeight() - nextButton:getHeight() - 20
    nextButton:setPosition(nextButtonX, nextButtonY)

    local previousButton = Button:new("back", 0, 0, previousButtonAction)
    local prevButtonX = 20
    local prevButtonY = love.graphics.getHeight() - nextButton:getHeight() - 20
    previousButton:setPosition(prevButtonX, prevButtonY)

    view.buttons = {
        nextButton,
        previousButton
    }
    
    return view
end

function Introduction:setOffset(offset)
    self.offset = offset
    for _,button in ipairs(self.buttons) do
        button:setOffset(offset)
    end
end

function Introduction:update( dt )
    for _,button in ipairs(self.buttons) do
        button:update(dt)
    end

    self.gillertYOffset = math.sin(love.timer.getTime() - self.animationStart) * 10

    if (self.textIdx == 4) then
        self.gillertVersion = self.gillert
    else
        self.gillertVersion = self.gillertBlack
    end
end

function Introduction:draw()
    love.graphics.push("all")
        -- bg image
        love.graphics.draw(self.bgImage, self.offset)

        -- gillert
        local imageX = (love.graphics.getWidth() / 2) - (self.gillertBlack:getWidth() / 2)
        local imageY = (love.graphics.getHeight() / 2) - (self.gillertBlack:getHeight() / 2) + 40
        love.graphics.draw(self.gillertVersion, imageX + self.offset, imageY + self.gillertYOffset)

        -- text bg
        love.graphics.setColor(COLORS.colorFromHex("#00000060"))
        love.graphics.rectangle("fill", self.offset, 0, love.graphics.getWidth(), (self.font:getHeight() * 2) + 40)

        -- text
        love.graphics.setFont(self.font)
        love.graphics.setColor(COLORS.colorFromHex("#FFFFFF"))
        love.graphics.printf(self.text[self.textIdx], 20 + self.offset, 20, love.graphics.getWidth() - 40)
    love.graphics.pop()

    for _,button in ipairs(self.buttons) do
        button:draw()
    end
end

return Introduction