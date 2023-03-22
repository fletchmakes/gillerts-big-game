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
local TheLetter = Container:extend()

local COLORS = require "utils.Colors"
local Button = require "components.Button"

function TheLetter:init(rules, parent)
    -- initialises all the container fields
    local view = TheLetter.super.new(self, rules)

    view.offset = 0

    view.font = love.graphics.newFont("assets/art/WindstilChonker-Regular.ttf", 40)

    view.text = {
        {COLORS.white, "Gillert sprinted all the way to a park about 3 blocks from Neighby's family's house,"},
        {COLORS.white, "sat down on a bench, and started writing his goodbye letter."},
        {COLORS.gillert, "\"I'm sorry to leave you this way,\"", COLORS.white, " the letter read,", COLORS.gillert, " \"but it's clear that I don't belong here...\""},
        {COLORS.gillert, "\"I don't belong at home either. I'm not sure if I belong anywhere.\""},
        {COLORS.gillert, "\"I don't know where I'll go, but I can't be a burden to you any longer.\""},
        {COLORS.gillert, "\"I'll figure out how to make my own way, I guess.\""},
        {COLORS.gillert, "\"Thank you for all you have done for me, but you'll be better off without me.\""},
        {COLORS.white, "Gillert folded up the letter and walked the rest of the way to Neighby's house."},
        {COLORS.white, "He planned to sneak in, leave the letter on the table, grab his belongings, and sneak out."},
    }

    view.images = {
        { image=love.graphics.newImage("assets/art/park.png"), traits={x=0, y=0, alpha=1} },
        { image=love.graphics.newImage("assets/art/gillert-concern.png"), traits={x=-100, y=175, alpha=0} },
    }

    view.pages = {
        -- page 1
        function() 
            parent.flux.to(view.images[2].traits, 1, { x=400, alpha=1 }):ease("quadinout")
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
            parent.flux.to(view.images[2].traits, 1, { x=400, alpha=1 }):ease("quadinout")
        end,
        -- page 8
        function()
            parent.flux.to(view.images[2].traits, 1, { x=1000, alpha=0 }):ease("quadinout")
        end,
        -- page 9
        function()
            parent.audioManager:setTrack(1)
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

function TheLetter:changePage(offset)
    self.pageIdx = self.pageIdx + offset
    self.pages[self.pageIdx]()
end

function TheLetter:setOffset(offset)
    self.offset = offset
    for _,button in ipairs(self.buttons) do
        button:setOffset(offset)
    end
end

function TheLetter:update( dt )
    for _,button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function TheLetter:draw()
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

return TheLetter