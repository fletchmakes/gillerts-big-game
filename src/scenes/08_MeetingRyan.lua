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
local MeetingRyan = Container:extend()

local COLORS = require "utils.Colors"
local Button = require "components.Button"

function MeetingRyan:init(rules, parent)
    -- initialises all the container fields
    local view = MeetingRyan.super.new(self, rules)

    view.offset = 0

    view.font = love.graphics.newFont("assets/art/WindstilChonker-Regular.ttf", 40)

    view.text = {
        {COLORS.white, "At the end of the school day, Gillert introduced CJ to Neighby."},
        {COLORS.white, "The three of them talked and laughed together as they headed out to the bus lane."},
        {COLORS.white, "Just outside the school's front doors, Gillert heard students yelling."},
        {COLORS.white, "There was a circle of six students throwing a white ball with black pentagons back and forth to each other."},
        {COLORS.white, "In the middle of the circle, another student was shouting,", COLORS.dialogue, " \"Hey, give it back! That's not fair!\""},
        {COLORS.white, "Gillert thought back to earlier in the day when he was being picked on."},
        {COLORS.white, "Although the kid being bullied in front of him appeared to be a normal human teenager,"},
        {COLORS.white, "Gillert saw a bit of himself in this student and knew he had to do something."},
    }

    view.images = {
        { image=love.graphics.newImage("assets/art/school-outside.png"), traits={x=0, y=0, alpha=1} },
        { image=love.graphics.newImage("assets/art/neighby.png"), traits={x=250, y=75, alpha=1} },
        { image=love.graphics.newImage("assets/art/gillert-joyful.png"), traits={x=100, y=175, alpha=1} },
        { image=love.graphics.newImage("assets/art/cj.png"), traits={x=350, y=175, alpha=1} },
        { image=love.graphics.newImage("assets/art/ryan-sad.png"), traits={x=800, y=175, alpha=0} },
        { image=love.graphics.newImage("assets/art/meanie1.png"), traits={x=400, y=200, alpha=0} },
        { image=love.graphics.newImage("assets/art/meanie2.png"), traits={x=800, y=200, alpha=0} },
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
            parent.flux.to(view.images[2].traits, 1, { x=250, alpha=1 }):ease("quadinout")
            parent.flux.to(view.images[3].traits, 1, { x=100, alpha=1 }):ease("quadinout")
            parent.flux.to(view.images[4].traits, 1, { x=350, alpha=1 }):ease("quadinout")
            parent.flux.to(view.images[5].traits, 1, { x=800, alpha=0 }):ease("quadinout")
            parent.flux.to(view.images[6].traits, 1, { alpha=0 }):ease("quadinout")
            parent.flux.to(view.images[7].traits, 1, { alpha=0 }):ease("quadinout")
        end,
        -- page 4
        function()
            parent.flux.to(view.images[2].traits, 1, { x=150, alpha=0 }):ease("quadinout")
            parent.flux.to(view.images[3].traits, 1, { x=0, alpha=0 }):ease("quadinout")
            parent.flux.to(view.images[4].traits, 1, { x=250, alpha=0 }):ease("quadinout")

            parent.flux.to(view.images[6].traits, 1, { alpha=1 }):ease("quadinout")
            parent.flux.to(view.images[7].traits, 1, { alpha=1 }):ease("quadinout")
            parent.flux.to(view.images[5].traits, 1, { x=700, alpha=1 }):ease("quadinout")
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

function MeetingRyan:changePage(offset)
    self.pageIdx = self.pageIdx + offset
    self.pages[self.pageIdx]()
end

function MeetingRyan:setOffset(offset)
    self.offset = offset
    for _,button in ipairs(self.buttons) do
        button:setOffset(offset)
    end
end

function MeetingRyan:update( dt )
    for _,button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function MeetingRyan:draw()
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

return MeetingRyan