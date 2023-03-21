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
    view.animationStart = love.timer.getTime()

    view.font = love.graphics.newFont("assets/art/WindstilChonker-Regular.ttf", 40)

    view.text = {
        {COLORS.white, "Gillert immediately felt overwhelmed at Surface High."},
        {COLORS.white, "Without water to slow things down, the hallways were crowded and chaotic."},
        {COLORS.white, "Students talked loudly with each other at their lockers, but when Gillert walked by, ripples of awed silence followed him."},
        {COLORS.white, "Soon afterwards, the snickers started."},
        {COLORS.white, "Then a voice from behind him shouted,", COLORS.dialogue, " \"You look like a FISH OUT OF WATER!\""},
        {COLORS.white, "Neighby rushed Gillert to an empty classroom nearby."},
        {COLORS.white, "And Gillert started to cry."},
    }

    view.images = {
        { image=love.graphics.newImage("assets/art/classroom.png"), traits={x=0, y=0, alpha=1} },
        { image=love.graphics.newImage("assets/art/hallway.png"), traits={x=0, y=0, alpha=1} },
        { image=love.graphics.newImage("assets/art/gillert-upset.png"), traits={x=250, y=200, alpha=1} },
        { image=love.graphics.newImage("assets/art/neighby.png"), traits={x=550, y=150, alpha=1} },
        { image=love.graphics.newImage("assets/art/gillert-cry.png"), traits={x=250, y=200, alpha=0} },
    }

    view.pages = {
        -- page 1
        function() 
        end,
        -- page 2
        function()
            parent:raiseVolume()
        end,
        -- page 3
        function()
            parent:lowerVolume()
        end,
        -- page 4
        function()
            parent:raiseVolume()
        end,
        -- page 5
        function()
            parent.flux.to(view.images[2].traits, 1, {alpha=1})
        end,
        -- page 6
        function()
            parent.flux.to(view.images[2].traits, 1, {alpha=0})
            parent.flux.to(view.images[3].traits, 1, {alpha=1})
            parent.flux.to(view.images[5].traits, 1, {alpha=0})
        end,
        -- page 7
        function()
            parent.flux.to(view.images[3].traits, 1, {alpha=0})
            parent.flux.to(view.images[5].traits, 1, {alpha=1})
            -- change the music
            parent.audioManager:setTrack(1)
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
    for _,button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function SurfaceSchool:draw()
    love.graphics.push("all")
        -- images
        for idx,image in ipairs(self.images) do
            love.graphics.setColor({1, 1, 1, image.traits.alpha})
            if (idx ~= 4) then
                love.graphics.draw(image.image, image.traits.x + self.offset, image.traits.y)
            else
                love.graphics.draw(image.image, image.traits.x + self.offset, image.traits.y, 0, 1.2)
            end
        end

        -- text bg
        love.graphics.setColor(COLORS.textBackground)
        love.graphics.rectangle("fill", self.offset, 0, love.graphics.getWidth(), (self.font:getHeight() * 2) + 40)

        -- text
        love.graphics.setFont(self.font)
        love.graphics.setColor(COLORS.white)
        love.graphics.printf(self.text[self.pageIdx], 20 + self.offset, 20, love.graphics.getWidth() - 40)
    love.graphics.pop()

    for _,button in ipairs(self.buttons) do
        button:draw()
    end
end

return SurfaceSchool