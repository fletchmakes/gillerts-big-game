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
local BiologyClass = Container:extend()

local COLORS = require "utils.Colors"
local Button = require "components.Button"

function BiologyClass:init(rules, parent)
    -- initialises all the container fields
    local view = BiologyClass.super.new(self, rules)

    view.offset = 0

    view.font = love.graphics.newFont("assets/art/WindstilChonker-Regular.ttf", 40)

    view.text = {
        {COLORS.dialogue, "\"What makes different species different from one another?\"", COLORS.white, " asked the teacher."},
        {COLORS.white, "A few of the other students volunteers answers such as fins vs. legs, gills vs. lungs, scales vs. fur, and so on."},
        {COLORS.dialogue, "\"And what makes different species similar to one another?\"", COLORS.white, " the teacher posed."},
        {COLORS.white, "The class was perplexed by this question."},
        {COLORS.dialogue, "\"They all need others like them in order to survive,\"", COLORS.white, " she followed."},
        {COLORS.white, "She clicked through a slideshow on the screen at the front of the room."},
        {COLORS.white, "It showed pictures of lizard families, bird families, fish families, and finally, happy human families."},
        {COLORS.white, "Gillert felt tears well up in his eyes. There was no one else like him."},
        {COLORS.white, "He had never had a family that looked like him, that understood him. He was all alone."},
        {COLORS.white, "As soon as the bell rang at the end of class, Gillert rushed out of the room and dashed toward the school's back exit."},
        {COLORS.white, "He made up his mind."},
        {COLORS.white, "He had to run away."},
    }

    view.images = {
        { image=love.graphics.newImage("assets/art/classroom.png"), traits={x=0, y=0, alpha=1} },
    }

    view.pages = {
        -- page 1
        function() 
            -- parent.flux.to(view.images[2].traits, 1, { y=290 }):ease("quadinout")
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

function BiologyClass:changePage(offset)
    self.pageIdx = self.pageIdx + offset
    self.pages[self.pageIdx]()
end

function BiologyClass:setOffset(offset)
    self.offset = offset
    for _,button in ipairs(self.buttons) do
        button:setOffset(offset)
    end
end

function BiologyClass:update( dt )
    for _,button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function BiologyClass:draw()
    love.graphics.push("all")
        -- images
        for idx,image in ipairs(self.images) do
            love.graphics.setColor({1, 1, 1, image.traits.alpha})
            love.graphics.draw(image.image, image.traits.x + self.offset, image.traits.y)
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

return BiologyClass