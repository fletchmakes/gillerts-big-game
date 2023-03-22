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
local GrowingApart = Container:extend()

local COLORS = require "utils.Colors"
local Button = require "components.Button"

function GrowingApart:init(rules, parent)
    -- initialises all the container fields
    local view = GrowingApart.super.new(self, rules)

    view.offset = 0

    view.font = love.graphics.newFont("assets/art/WindstilChonker-Regular.ttf", 40)

    view.text = {
        {COLORS.white, "Over the next week, Gillert spent as much time as he could during the school day with Neighby, CJ, and Ryan."},
        {COLORS.white, "The group became as thick as thieves."},
        {COLORS.white, "An added bonus was that bullies seemed to leave them alone when they were together."},
        {COLORS.white, "The four of them met every day after school to help Gillert prepare for soccer tryouts, and it was well worth it."},
        {COLORS.white, "Gillert made the soccer team with ease."},
        {COLORS.white, "He was surprised to discover that he was one of the best forwards on the team."},
        {COLORS.white, "His teammates seemed to respect him, but they still avoided him as much as they could."},
        {COLORS.white, "Gillert had to go to soccer practice nearly every day,"},
        {COLORS.white, "so he wasn't able to spend as much time with Neighby, CJ, and Ryan anymore."},
        {COLORS.white, "In fact, Gillert felt that a rift was growing between him and the rest of his friend group."},
        {COLORS.white, "At the lunch table, the three of them laughed at inside jokes that Gillert didn't understand."},
        {COLORS.white, "They bonded over shared experiences from growing up on the surface that Gillert couldn't relate to."},
        {COLORS.white, "Gillert grew lonelier each day, and he missed his family more and more."},
        {COLORS.white, "The day before the championship soccer game, Gillert finally reached his breaking point."},
        {COLORS.white, "He was sitting in his usual spot in the back corner of his biology class,"},
        {COLORS.white, "enduring his last period of the school day, when an unusual topic came up."},
    }

    view.images = {
        { image=love.graphics.newImage("assets/art/goal.png"), traits={x=0, y=0, alpha=1} },
        { image=love.graphics.newImage("assets/art/neighby.png"), traits={x=400, y=75, alpha=1} },
        { image=love.graphics.newImage("assets/art/gillert-joyful.png"), traits={x=250, y=175, alpha=1} },
        { image=love.graphics.newImage("assets/art/ryan.png"), traits={x=550, y=50, alpha=1} },
        { image=love.graphics.newImage("assets/art/cj.png"), traits={x=500, y=175, alpha=1} },
        { image=love.graphics.newImage("assets/art/gillert-upset.png"), traits={x=350, y=175, alpha=0} },
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
            parent.flux.to(view.images[2].traits, 1, { alpha=1 }):ease("quadinout")
            parent.flux.to(view.images[3].traits, 1, { alpha=1 }):ease("quadinout")
            parent.flux.to(view.images[4].traits, 1, { alpha=1 }):ease("quadinout")
            parent.flux.to(view.images[5].traits, 1, { alpha=1 }):ease("quadinout")
            parent.flux.to(view.images[6].traits, 1, { alpha=0 }):ease("quadinout")
        end,
        -- page 10
        function()
            parent.flux.to(view.images[2].traits, 1, { alpha=0 }):ease("quadinout")
            parent.flux.to(view.images[3].traits, 1, { alpha=0 }):ease("quadinout")
            parent.flux.to(view.images[4].traits, 1, { alpha=0 }):ease("quadinout")
            parent.flux.to(view.images[5].traits, 1, { alpha=0 }):ease("quadinout")
            parent.flux.to(view.images[6].traits, 1, { alpha=1 }):ease("quadinout")
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
        -- page 15
        function()
        end,
        -- page 16
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

function GrowingApart:changePage(offset)
    self.pageIdx = self.pageIdx + offset
    self.pages[self.pageIdx]()
end

function GrowingApart:setOffset(offset)
    self.offset = offset
    for _,button in ipairs(self.buttons) do
        button:setOffset(offset)
    end
end

function GrowingApart:update( dt )
    for _,button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function GrowingApart:draw()
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

return GrowingApart