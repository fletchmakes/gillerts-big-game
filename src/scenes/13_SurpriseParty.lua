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
local SurpriseParty = Container:extend()

local COLORS = require "utils.Colors"
local Button = require "components.Button"

function SurpriseParty:init(rules, parent)
    -- initialises all the container fields
    local view = SurpriseParty.super.new(self, rules)

    view.offset = 0

    view.font = love.graphics.newFont("assets/art/WindstilChonker-Regular.ttf", 40)

    view.text = {
        {COLORS.white, "However, when he opened the front door, he was greeted by a loud cheer of ", COLORS.dialogue, "\"SURPRISE!\""},
        {COLORS.white, "Gillert stood stunned, his mouth gaping open."},
        {COLORS.white, "Blue balloons coated the entire floor, and blue streamers lined every wall."},
        {COLORS.white, "In front of him was a table full of his favorite foods: seaweed salad, coral reef cake, and squid spaghetti."},
        {COLORS.white, "Neighby, Neighby's parents, CJ, and Ryan stood in the living room, blowing bubbles and clapping as Gillert entered."},
        {COLORS.white, "They were all dressed in Gillert's number 12 soccer jersey and were holding up a banner that said,"},
        {COLORS.dialogue, "\"Good luck in the big game, Gillert! You are the best!\""},
        {COLORS.white, "It was an underwater themed surprise party! Just for Gillert."},
        {COLORS.white, "Tears rolled down Gillert's scales again, only this time, they were for joy."},
        {COLORS.white, "He was wanted. He was loved."},
        {COLORS.white, "He BELONGED."},
        {COLORS.white, "Gillert realized these things could still be true even if there was no one else who was like him."},
        {COLORS.white, "He was unique, but that didn't mean he had to be alone."},
        {COLORS.white, "He tore up the letter he had written and joined the party."},
    }

    view.images = {
        -- { image=love.graphics.newImage("assets/art/water_bg.png"), traits={x=0, y=0, alpha=1} },
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
        -- page 13
        function()
        end,
        -- page 14
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

function SurpriseParty:changePage(offset)
    self.pageIdx = self.pageIdx + offset
    self.pages[self.pageIdx]()
end

function SurpriseParty:setOffset(offset)
    self.offset = offset
    for _,button in ipairs(self.buttons) do
        button:setOffset(offset)
    end
end

function SurpriseParty:update( dt )
    for _,button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function SurpriseParty:draw()
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

return SurpriseParty