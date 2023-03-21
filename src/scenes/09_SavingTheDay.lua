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
local EmptyPage = Container:extend()

local COLORS = require "utils.Colors"
local Button = require "components.Button"

function EmptyPage:init(rules, parent)
    -- initialises all the container fields
    local view = EmptyPage.super.new(self, rules)

    view.offset = 0

    view.font = love.graphics.newFont("assets/art/WindstilChonker-Regular.ttf", 40)

    view.text = {
        {COLORS.white, "Gillert dashed into the middle of the circle, headbutted the ball out of its flight path,"},
        {COLORS.white, "and kicked it toward the bullied student once it hit the ground."},
        {COLORS.white, "The ball smacked the kid square in the chest, but the kid caught it."},
        {COLORS.dialogue, "\"Way to spoil the fun, freak,\"", COLORS.white, " one of the bullies groaned. The circle broke up and the perpetrators stalked away."},
        {COLORS.dialogue, "\"Wow, you have real skill, Gillert!\"", COLORS.white, " the kid with the ball exclaimed."},
        {COLORS.gillert, "\"How do you know my name?\"", COLORS.white, " Gillert asked."},
        {COLORS.dialogue, "\"We had class together earlier. I remember everyone's names and the date I met them.\""},
        {COLORS.gillert, "\"Oh right!\"", COLORS.white, " Gillert remembered. ", COLORS.gillert, "\"You're Ryan, right? And you go by they/them.\""},
        {COLORS.white, "Ryan's face glowed.", COLORS.dialogue, " \"Yes! Thanks for remembering.\""},
        {COLORS.gillert, "\"What's that ball for?\"", COLORS.white, " Gillert asked."},
        {COLORS.dialogue, "\"Oh, it's for a game called soccer.\""},
        {COLORS.dialogue, "\"Those kids were making fun of me because I know all about soccer even though I don't actually play.\""},
        {COLORS.dialogue, "\"I spend all my free time researching the game, and I'm basically an expert.\""},
        {COLORS.dialogue, "\"Unfortunately, my lack of coordination makes it impossible to put my knowledge to use.\""},
        {COLORS.gillert, "\"That's so cool. I don't know why they would pick on you for that.\""},
        {COLORS.white, "Ryan sighed. ", COLORS.dialogue, "\"You know how they pick on you because you look different on the outside?\""},
        {COLORS.dialogue, "\"Well, they pick on me because they can tell I'm different on the inside.\""},
        {COLORS.white, "Gillert understood in that moment why he felt so much empathy for Ryan."},
        {COLORS.dialogue, "\"Hey, you really do have a natural talent for soccer, Gillert,\"", COLORS.white, " Ryan said."},
        {COLORS.gillert, "\"Wow, thanks. That means a lot. I've never really been told I'm good at anything.\""},
        {COLORS.white, "A thought occurred to Gillert. ", COLORS.gillert, "\"Ryan, why don't you teach me how to play?\""},
        {COLORS.white, "Ryan started to jump and clap his hands. ", COLORS.dialogue, "\"That sounds perfect! The school soccer team tryouts are next week.\""},
        {COLORS.dialogue, "\"I'm sure I could have you ready by then if you wanted.\""},
        {COLORS.gillert, "\"I'd be willing to give it a shot.\""},
        {COLORS.white, "Gillert and Ryan smiled and walked toward the buses."},
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
        -- page 15
        function()
        end,
        -- page 16
        function()
        end,
        -- page 17
        function()
        end,
        -- page 18
        function()
        end,
        -- page 19
        function()
        end,
        -- page 20
        function()
        end,
        -- page 21
        function()
        end,
        -- page 22
        function()
        end,
        -- page 23
        function()
        end,
        -- page 24
        function()
        end,
        -- page 25
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

function EmptyPage:changePage(offset)
    self.pageIdx = self.pageIdx + offset
    self.pages[self.pageIdx]()
end

function EmptyPage:setOffset(offset)
    self.offset = offset
    for _,button in ipairs(self.buttons) do
        button:setOffset(offset)
    end
end

function EmptyPage:update( dt )
    for _,button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function EmptyPage:draw()
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

return EmptyPage