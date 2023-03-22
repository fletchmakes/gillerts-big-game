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
local MeetingCJ = Container:extend()

local COLORS = require "utils.Colors"
local Button = require "components.Button"

function MeetingCJ:init(rules, parent)
    -- initialises all the container fields
    local view = MeetingCJ.super.new(self, rules)

    view.offset = 0

    view.font = love.graphics.newFont("assets/art/WindstilChonker-Regular.ttf", 40)

    view.text = {
        {COLORS.white, "The rest of Gillert's first day was somewhat better, but only slightly."},
        {COLORS.white, "Gillert enjoyed learning in his classes, but the other students still made fun of him between periods."},
        {COLORS.white, "He began to feel discouraged because he was still an outcast here, just like at his old school."},
        {COLORS.white, "But in his last class of the day, things started looking up."},
        {COLORS.white, "Gillert sat down in the back corner of his biology class, trying not to draw attention to himself."},
        {COLORS.white, "A student rolled up next to him in an odd chair contraption that pushed itself forward on four wheels."},
        {COLORS.dialogue, "\"I'm sorry the other students have been so mean to you,\"", COLORS.white, " she said to Gillert in a slow, somewhat muffled voice."},
        {COLORS.gillert, "\"It's okay. I'm used to it,\"", COLORS.white, " Gillert replied.", COLORS.gillert, " \"You're the first person to say something nice to me all day.\""},
        {COLORS.dialogue, "\"That's so sad to hear, but I'm glad I could brighten your day. I'm CJ.\""},
        {COLORS.gillert, "\"Hi, CJ, I'm Gillert!\""},
        {COLORS.dialogue, "\"It's good to meet you! Honestly, it's rare for me to have a friendly conversation with the students here as well.\""},
        {COLORS.dialogue, "\"They don't bully or make fun of me, but I can tell I make them uncomfortable.\""},
        {COLORS.dialogue, "\"They don't know how to talk to someone in a wheelchair. Plus, they have a hard time understanding what I'm saying.\""},
        {COLORS.gillert, "\"I can understand you perfectly fine! To me, it sounds like you are talking underwater, which reminds me of home.\""},
        {COLORS.white, "CJ smiled."},
        {COLORS.white, "And so, Gillert was able to add another friend to his list of allies on the surface."}
    }

    view.images = {
        { image=love.graphics.newImage("assets/art/classroom.png"), traits={x=0, y=0, alpha=1} },
        { image=love.graphics.newImage("assets/art/gillert.png"), traits={x=400, y=175, alpha=1} },
        { image=love.graphics.newImage("assets/art/cj.png"), traits={x=700, y=175, alpha=0} },
    }

    view.pages = {
        -- page 1
        function() 
            parent.audioManager:stopCrowd()
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
            parent.flux.to(view.images[2].traits, 1, {x=400})
            parent.flux.to(view.images[3].traits, 1, {alpha=0, x=700})
        end,
        -- page 6
        function()
            parent.flux.to(view.images[2].traits, 1, {x=200, alpha=1})
            parent.flux.to(view.images[3].traits, 1, {alpha=1, x=600})
        end,
        -- page 7
        function()
            parent.flux.to(view.images[2].traits, 1, {alpha=0.3})
            parent.flux.to(view.images[3].traits, 1, {alpha=1})
        end,
        -- page 8
        function()
            parent.flux.to(view.images[2].traits, 1, {alpha=1})
            parent.flux.to(view.images[3].traits, 1, {alpha=0.3})
        end,
        -- page 9
        function()
            parent.flux.to(view.images[2].traits, 1, {alpha=0.3})
            parent.flux.to(view.images[3].traits, 1, {alpha=1})
        end,
        -- page 10
        function()
            parent.flux.to(view.images[2].traits, 1, {alpha=1})
            parent.flux.to(view.images[3].traits, 1, {alpha=0.3})
        end,
        -- page 11
        function()
            parent.flux.to(view.images[2].traits, 1, {alpha=0.3})
            parent.flux.to(view.images[3].traits, 1, {alpha=1})
        end,
        -- page 12
        function()
        end,
        -- page 13
        function()
            parent.flux.to(view.images[2].traits, 1, {alpha=0.3})
        end,
        -- page 14
        function()
            parent.flux.to(view.images[2].traits, 1, {alpha=1})
            parent.flux.to(view.images[3].traits, 1, {alpha=1})
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

function MeetingCJ:changePage(offset)
    self.pageIdx = self.pageIdx + offset
    self.pages[self.pageIdx]()
end

function MeetingCJ:setOffset(offset)
    self.offset = offset
    for _,button in ipairs(self.buttons) do
        button:setOffset(offset)
    end
end

function MeetingCJ:update( dt )
    for _,button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function MeetingCJ:draw()
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

return MeetingCJ