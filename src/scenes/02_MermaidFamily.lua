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

function MermaidFamily:init(rules, parent)
    -- initialises all the container fields
    local view = MermaidFamily.super.new(self, rules)

    view.offset = 0
    view.yOffset = 0
    view.animationStart = love.timer.getTime()

    view.font = love.graphics.newFont("assets/art/WindstilChonker-Regular.ttf", 40)

    view.text = {
        {COLORS.colorFromHex("#FFFFFF"), "Unfortunately, unique doesn't always mean well-liked."},
        {COLORS.colorFromHex("#FFFFFF"), "Gillert was an outcast among his mermaid community."},
        {COLORS.colorFromHex("#FFFFFF"), "He had no friends and was constantly teased by the other mermaid kids at school."},
        {COLORS.colorFromHex("#FFFFFF"), "On his fourteenth birthday, his mermaid moms knew something needed to change."},
        {COLORS.colorFromHex("#ffa696"), "\"Gillert, we know you've been having a hard time at school.\""},
        {COLORS.colorFromHex("#ffa696"), "\"I think you know your mama and I are involved in an online support group on Fishbook...\""},
        {COLORS.colorFromHex("#ffa696"), "\"...for parents of reverse-mythical creatures.\""},
        {COLORS.colorFromHex("#ffa696"), "\"One couple we met in the group would be willing to have you stay with them...\""},
        {COLORS.colorFromHex("#ffa696"), "\"...so you can go to school on the surface.\""},
        {COLORS.colorFromHex("#FFFFFF"), "And so, Gillert packed his things, said goodbye, and left for the surface."},
        {COLORS.colorFromHex("#FFFFFF"), "But the journey to the surface was hard and long,"},
        {COLORS.colorFromHex("#FFFFFF"), "and without a tail, Gillert couldn't swim as well as other mermaids."},
    }

    view.images = {
        { image=love.graphics.newImage("assets/art/water_bg.png"), traits={x=0, y=0, alpha=1} },
        -- TODO: animate the whale in the bg?
        { image=love.graphics.newImage("assets/art/water_castle.png"), traits={x=175, y=300, alpha=1} },
        { image=love.graphics.newImage("assets/art/mom1_happy.png"), traits={x=50, y=50, alpha=0} },
        { image=love.graphics.newImage("assets/art/mom2_happy.png"), traits={x=550, y=50, alpha=0} },
        { image=love.graphics.newImage("assets/art/mom1.png"), traits={x=100, y=100, alpha=0} },
        { image=love.graphics.newImage("assets/art/mom2_gillerthug.png"), traits={x=500, y=100, alpha=0} },
        { image=love.graphics.newImage("assets/art/gillert-concern.png"), traits={x=400, y=100, alpha=0} }
    }

    view.pages = {
        -- page 1
        function() 
            parent.flux.to(view.images[1].traits, 1, { y=0 }):ease("quadinout")
            parent.flux.to(view.images[2].traits, 1, { y=290 }):ease("quadinout")
        end,
        -- page 2
        function()
            parent.flux.to(view.images[1].traits, 1, { y=-300 }):ease("quadinout")
            parent.flux.to(view.images[2].traits, 1, { y=-10}):ease("quadinout")
        end,
        -- page 3
        function()
            parent.flux.to(view.images[3].traits, 1, { alpha=0 }):ease("quadinout")
            parent.flux.to(view.images[4].traits, 1, { alpha=0 }):ease("quadinout")
        end,
        -- page 4
        function()
            parent.flux.to(view.images[3].traits, 1, { alpha=1 }):ease("quadinout")
            parent.flux.to(view.images[4].traits, 1, { alpha=1 }):ease("quadinout")
        end,
        -- page 5
        function()
            parent.flux.to(view.images[3].traits, 1, { alpha=0.3 }):ease("quadinout")
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
            parent.flux.to(view.images[3].traits, 1, { alpha=0.3 }):ease("quadinout")
            parent.flux.to(view.images[4].traits, 1, { alpha=1 }):ease("quadinout")
            parent.flux.to(view.images[5].traits, 1, { alpha=0 }):ease("quadinout")
            parent.flux.to(view.images[6].traits, 1, { alpha=0 }):ease("quadinout")
        end,
        -- page 10
        function()
            parent.flux.to(view.images[3].traits, 1, { alpha=0 }):ease("quadinout")
            parent.flux.to(view.images[4].traits, 1, { alpha=0 }):ease("quadinout")
            parent.flux.to(view.images[5].traits, 1, { alpha=1 }):ease("quadinout")
            parent.flux.to(view.images[6].traits, 1, { alpha=1 }):ease("quadinout")
        end,
        -- page 11
        function()
            parent.flux.to(view.images[5].traits, 1, { alpha=0 }):ease("quadinout")
            parent.flux.to(view.images[6].traits, 1, { alpha=0 }):ease("quadinout")
            parent.flux.to(view.images[7].traits, 1, { alpha=0 }):ease("quadinout")
        end,
        -- page 12
        function()
            parent.flux.to(view.images[7].traits, 1, { alpha=1 }):ease("quadinout")
        end
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
    self.yOffset = math.sin(love.timer.getTime() - self.animationStart) * 10

    for _,button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function MermaidFamily:draw()
    love.graphics.push("all")
        -- images
        for idx,image in ipairs(self.images) do
            love.graphics.setColor({1, 1, 1, image.traits.alpha})
            local yOffset = 0
            if (idx >= 3) then
                yOffset = self.yOffset
            end
            love.graphics.draw(image.image, image.traits.x + self.offset, image.traits.y + yOffset)
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