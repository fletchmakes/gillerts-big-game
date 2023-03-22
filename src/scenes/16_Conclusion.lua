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
        {COLORS.white, "Gillert scored the most goals out of his entire team, including the winning goal."},
        {COLORS.white, "His teammates held him up on their shoulders and chanted his name."},
        {COLORS.white, "After the commotion died down, several of Gillert's teammates approached him."},
        {COLORS.dialogue, "\"Hey, Gillert,\"", COLORS.white, " one of them said,", COLORS.dialogue, " \"that was some pretty epic footwork.\""},
        {COLORS.dialogue, "\"We were all planning to go out and party. Do you want to come?\""},
        {COLORS.gillert, "\"No thanks,\"", COLORS.white, " Gillert replied."},
        {COLORS.gillert, " \"I'd rather celebrate with my friends who have always supported me for who I am, not for how well I play.\""},
        {COLORS.white, "His teammates' jaws dropped in confusion and disbelief."},
        {COLORS.white, "Gillert smiled, turned, and skipped toward the edge of the field, where his friends were waiting for him."},
    }

    view.images = {
        { image=love.graphics.newImage("assets/art/goal.png"), traits={x=0, y=0, alpha=1} },
        { image=love.graphics.newImage("assets/art/gillert-joyful.png"), traits={x=400, y=175, alpha=1} },
        { image=love.graphics.newImage("assets/art/ryan.png"), traits={x=550, y=125, alpha=0} },
        { image=love.graphics.newImage("assets/art/neighby.png"), traits={x=625, y=250, alpha=0} },
        { image=love.graphics.newImage("assets/art/cj.png"), traits={x=325, y=250, alpha=0} },
    }

    view.pages = {
        -- page 1
        function() 
        end,
        -- page 2
        function()
            parent.flux.to(view.images[2].traits, 1, { y=75 }):ease("quadinout")
                :oncomplete(function()
                    parent.flux.to(view.images[2].traits, 1, { y=175 }):ease("quadinout")
                end)
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
            parent.flux.to(view.images[2].traits, 1, { x=400 }):ease("quadinout")
            parent.flux.to(view.images[3].traits, 1, { alpha=0 }):ease("quadinout")
            parent.flux.to(view.images[4].traits, 1, { alpha=0 }):ease("quadinout")
            parent.flux.to(view.images[5].traits, 1, { alpha=0 }):ease("quadinout")
        end,
        -- page 9
        function()
            parent.flux.to(view.images[2].traits, 1, { x=200 }):ease("quadinout")
            parent.flux.to(view.images[3].traits, 1, { alpha=1 }):ease("quadinout")
            parent.flux.to(view.images[4].traits, 1, { alpha=1 }):ease("quadinout")
            parent.flux.to(view.images[5].traits, 1, { alpha=1 }):ease("quadinout")
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