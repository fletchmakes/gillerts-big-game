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
local SurfaceSchool = Container:extend()

local COLORS = require "utils.Colors"
local Button = require "components.Button"

function SurfaceSchool:init(rules, parent)
    -- initialises all the container fields
    local view = SurfaceSchool.super.new(self, rules)

    view.offset = 0
    view.yOffset = 0
    view.animationStart = love.timer.getTime()

    view.font = love.graphics.newFont("assets/art/WindstilChonker-Regular.ttf", 40)

    view.text = {
        {COLORS.colorFromHex("#FFFFFF"), "Gillert immediately felt overwhelmed at Surface High."},
        {COLORS.colorFromHex("#FFFFFF"), "Without water to slow things down, the hallways were crowded and chaotic."},
        {COLORS.colorFromHex("#FFFFFF"), "Students talked loudly with each other at their lockers, but when Gillert walked by, ripples of awed silence followed him."},
        {COLORS.colorFromHex("#FFFFFF"), "Soon afterwards, the snickers started."},
        {COLORS.colorFromHex("#FFFFFF"), "Then a voice from behind him shouted,", COLORS.colorFromHex("#ffa696"), " \"You look like a FISH OUT OF WATER!\""},
        {COLORS.colorFromHex("#FFFFFF"), "Neighby rushed him to an empty classroom nearby."},
        {COLORS.colorFromHex("#FFFFFF"), "And Gillert started to cry."},
    }

    view.images = {

    }

    view.pages = {
        -- page 1
        function() 
        end,
        -- page 2
        function()
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

function SurfaceSchool:changePage(offset)
    self.pageIdx = self.pageIdx + offset
    self.pages[self.pageIdx]()
end

function SurfaceSchool:setOffset(offset)
    self.offset = offset
    for _,button in ipairs(self.buttons) do
        button:setOffset(offset)
    end
end

function SurfaceSchool:update( dt )
    self.yOffset = math.sin(love.timer.getTime() - self.animationStart) * 10

    for _,button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function SurfaceSchool:draw()
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

return SurfaceSchool