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
local MermaidFamily = Container:extend()

local COLORS = require "utils.Colors"
local Button = require "components.Button"
local ToTheSurface = require "scenes.03_ToTheSurface"

function MermaidFamily:init(rules, parent)
    -- initialises all the container fields
    local view = MermaidFamily.super.new(self, rules)

    view.offset = 0

    view.font = love.graphics.newFont("assets/art/WindstilChonker-Regular.ttf", 40)

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

    view.images = {
        { image=love.graphics.newImage("assets/art/water_bg.jpg"), pos={x=0, y=0} }
    }

    view.pages = {
        -- page 1
        function() 
            parent.flux.to(view.images[1].pos, 1, { x=0, y=0 }):ease("quadinout")
        end,
        -- page 2
        function()
            parent.flux.to(view.images[1].pos, 1, { x=0, y=-300 }):ease("quadinout")
        end,
        -- page 3
        function()
        end,
        -- page 4
        function()
        end,
        -- page 5
        function()
        end,
        -- page 6
        function()
        end,
        -- page 7
        function()
        end,
        -- page 8
        function()
        end,
        -- page 9
        function()
        end,
        -- page 10
        function()
        end,
        -- page 11
        function()
        end,
        -- page 12
        function()
        end,
        -- page 13
        function()
        end,
    }

    view.pageIdx = 1

    local nextButtonAction = function()
        if (view.pageIdx < #view.text) then
            view:changePage(1)
        else
            parent:nextScene()
        end
    end

    local previousButtonAction = function()
        if (view.pageIdx > 1) then
            view:changePage(-1)
        else
            parent:previousScene()
        end
    end

    local nextButton = Button:new("next", 0, 0, nextButtonAction)
    local buttonX = love.graphics.getWidth() - nextButton:getWidth() - 20
    local buttonY = love.graphics.getHeight() - nextButton:getHeight() - 20
    nextButton:setPosition(buttonX, buttonY)
    
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

function MermaidFamily:changePage(offset)
    self.pageIdx = self.pageIdx + offset
    self.pages[self.pageIdx]()
end

function MermaidFamily:setOffset(offset)
    self.offset = offset
    for _,button in ipairs(self.buttons) do
        button:setOffset(offset)
    end
end

function MermaidFamily:update( dt )
    for _,button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function MermaidFamily:draw()
    love.graphics.push("all")
        -- images
        for _,image in ipairs(self.images) do
            love.graphics.draw(image.image, image.pos.x + self.offset, image.pos.y)
        end

        -- text bg
        love.graphics.setColor(COLORS.colorFromHex("#00000060"))
        love.graphics.rectangle("fill", self.offset, 0, love.graphics.getWidth(), (self.font:getHeight() * 2) + 40)

        -- text
        love.graphics.setFont(self.font)
        love.graphics.setColor(COLORS.colorFromHex("#FFFFFF"))
        love.graphics.printf(self.text[self.pageIdx], 20 + self.offset, 20, love.graphics.getWidth() - 40)
    love.graphics.pop()

    for _,button in ipairs(self.buttons) do
        button:draw()
    end
end

return MermaidFamily