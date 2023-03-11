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
local MermaidFamily = Container:extend()

local COLORS = require "utils.Colors"
local Button = require "components.Button"

function MermaidFamily:init(rules, parent)
    -- initialises all the container fields
    local view = MermaidFamily.super.new(self, rules)

    view.offset = 0

    view.font = love.graphics.newFont("assets/art/WindstilChonker-Regular.ttf", 40)

    view.bgImage = love.graphics.newImage("assets/art/classroom.png")

    view.text = {
        "Unfortunately, unique doesn't always mean well-liked.",
        "Gillert was an outcast among his mermaid community.",
        "He had no friends and was constantly teased by the other mermaid kids at school.",
        "On his fourteenth birthday, his mermaid moms knew something needed to change.",
        "\"Gillert, we know you've been having a hard time at school.\"",
        "\"I think you know your mama and I are involved in an online support group on Fishbook...\"",
        "\"...for parents of reverse-mythical creatures.\"",
        "\"One couple we met in the group would be willing to have you stay with them...\"",
        "\"...so you can go to school on the surface.\"",
        "And so, Gillert packed his things, said goodbye, and left for the surface.",
        "But the journey to the surface was hard and long,",
        "and without a tail, Gillert couldn't swim as well as other mermaids.",
        "He needs your help to keep his strength up as he swims!"
    }
    view.textIdx = 1

    local nextButtonAction = function()
        if (view.textIdx < #view.text) then
            view.textIdx = view.textIdx + 1
        end
    end

    local previousButtonAction = function()
        if (view.textIdx > 1) then
            view.textIdx = view.textIdx - 1
        end
    end

    view.nextButton = Button:new("next", 0, 0, nextButtonAction)
    local buttonX = love.graphics.getWidth() - view.nextButton:getWidth() - 20
    local buttonY = love.graphics.getHeight() - view.nextButton:getHeight() - 20
    view.nextButton:setPosition(buttonX, buttonY)
    
    view.previousButton = Button:new("back", 0, 0, previousButtonAction)
    local prevButtonX = 20
    local prevButtonY = love.graphics.getHeight() - view.nextButton:getHeight() - 20
    view.previousButton:setPosition(prevButtonX, prevButtonY)

    return view
end

function MermaidFamily:setOffset(offset)
    self.offset = offset
    self.nextButton:setOffset(offset)
    self.previousButton:setOffset(offset)
end

function MermaidFamily:update( dt )
    self.nextButton:update(dt)
    self.previousButton:update(dt)
end

function MermaidFamily:draw()
    love.graphics.push("all")
        -- bg image
        love.graphics.draw(self.bgImage, self.offset)

        -- text bg
        love.graphics.setColor(COLORS.colorFromHex("#00000060"))
        love.graphics.rectangle("fill", self.offset, 0, love.graphics.getWidth(), (self.font:getHeight() * 2) + 40)

        -- text
        love.graphics.setFont(self.font)
        love.graphics.setColor(COLORS.colorFromHex("#FFFFFF"))
        love.graphics.printf(self.text[self.textIdx], 20 + self.offset, 20, love.graphics.getWidth() - 40)
    love.graphics.pop()

    self.nextButton:draw()
    self.previousButton:draw()
end

return MermaidFamily