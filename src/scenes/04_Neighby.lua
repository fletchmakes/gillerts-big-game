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
local Neighby = Container:extend()

local COLORS = require "utils.Colors"
local Button = require "components.Button"

function Neighby:init(rules, parent)
    -- initialises all the container fields
    local view = Neighby.super.new(self, rules)

    view.offset = 0
    view.animationStart = love.timer.getTime()

    view.font = love.graphics.newFont("assets/art/WindstilChonker-Regular.ttf", 40)

    view.text = {
        {COLORS.white, "Gillert finally made it to the surface, where his host family was waiting."},
        {COLORS.dialogue, "\"Hi, I'm Neighby!!\""},
        {COLORS.white, "Neighby's parents were centaurs, but it was clear that Neighby was different."},
        {COLORS.white, "Instead of a human torso and horse body, Neighby's features were reversed, just like Gillert!"},
        {COLORS.dialogue, "\"I've been so excited to meet you!\""},
        {COLORS.dialogue, "\"We'll both be first years at Surface High School this fall!\""},
        {COLORS.dialogue, "\"I'm looking forward to starting the year having already made a friend.\""},
        {COLORS.white, "And they bonded right away."},
        {COLORS.gillert, "\"Friend,\"", COLORS.white, " Gillert thought."},
        {COLORS.gillert, "\"I finally know how it feels to have a friend.\""}
    }

    view.images = {
        { image=love.graphics.newImage("assets/art/neighby_house.png"), traits={x=0, y=0, alpha=1} },
        { image=love.graphics.newImage("assets/art/neighby.png"), traits={x=450, y=150, alpha=0} },
        { image=love.graphics.newImage("assets/art/neighbydad_1.png"), traits={x=100, y=150, alpha=0} },
        { image=love.graphics.newImage("assets/art/dad2.png"), traits={x=700, y=150, alpha=0} },
        { image=love.graphics.newImage("assets/art/gillert.png"), traits={x=150, y=200, alpha=0} }
    }

    view.pages = {
        -- page 0
        function()
            parent.flux.to(view.images[2].traits, 0, {alpha=0})
        end
        -- page 1
        function()
            parent.flux.to(view.images[2].traits, 1, {alpha=1})
            parent.flux.to(view.images[3].traits, 1, {x=100, alpha=0})
            parent.flux.to(view.images[4].traits, 1, {x=700, alpha=0})
        end,
        -- page 2
        function()
            parent.flux.to(view.images[2].traits, 1, {alpha=0.5})
            parent.flux.to(view.images[3].traits, 1, {x=150, alpha=1})
            parent.flux.to(view.images[4].traits, 1, {x=600, alpha=1})
        end,
        -- page 3
        function()
            parent.flux.to(view.images[2].traits, 1, {alpha=1})
            parent.flux.to(view.images[3].traits, 1, {alpha=0.3})
            parent.flux.to(view.images[4].traits, 1, {alpha=0.3})
            parent.flux.to(view.images[5].traits, 1, {alpha=0})
        end,
        -- page 4
        function()
            parent.flux.to(view.images[3].traits, 1, {x=100, alpha=0})
            parent.flux.to(view.images[4].traits, 1, {x=700, alpha=0})
            parent.flux.to(view.images[5].traits, 1, {alpha=1})
        end,
        -- page 5
        function()
        end,
        -- page 6
        function()
        end,
        -- page 7
        function()
            parent.flux.to(view.images[2].traits, 1, {alpha=1})
        end,
        -- page 8
        function()
            parent.flux.to(view.images[2].traits, 1, {alpha=0.5})
        end,
        -- page 9
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

function Neighby:changePage(offset)
    self.pageIdx = self.pageIdx + offset
    self.pages[self.pageIdx]()
end

function Neighby:setOffset(offset)
    self.offset = offset
    for _,button in ipairs(self.buttons) do
        button:setOffset(offset)
    end
end

function Neighby:update( dt )
    for _,button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function Neighby:draw()
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

return Neighby