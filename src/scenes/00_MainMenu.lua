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
local MainMenu = Container:extend()

local COLORS = require "utils.Colors"
local Button = require "components.Button"
local Introduction = require "scenes.01_Introduction"

function MainMenu:init(rules, parent)
    -- initialises all the container fields
    local view = MainMenu.super.new(self, rules)

    view.offset = 0

    view.littleFont = love.graphics.newFont("assets/art/WindstilChonker-Regular.ttf", 30)
    view.bgImage = love.graphics.newImage("assets/art/goal.png")
    view.header = love.graphics.newImage("assets/art/header.png")

    local playButtonAction = function()
        parent:nextScene()
    end

    local playButton = Button:new("play", 0, 0, playButtonAction)
    local buttonX = (love.graphics.getWidth() / 2) - (playButton:getWidth() / 2)
    playButton:setPosition(buttonX, 350)

    view.buttons = {
        playButton
    }

    return view
end

function MainMenu:setOffset(offset)
    self.offset = offset

    for _,button in ipairs(self.buttons) do
        button:setOffset(offset)
    end
end

function MainMenu:update( dt )
    for _,button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function MainMenu:draw()
    love.graphics.push("all")
        -- bg image
        love.graphics.draw(self.bgImage, self.offset)

        -- header image
        local headerX = (love.graphics.getWidth() / 2) - (self.header:getWidth() / 2)
        local headerY = (love.graphics.getHeight() / 2) - (self.header:getHeight() / 2) - 70
        love.graphics.draw(self.header, headerX + self.offset, headerY)

        -- credits
        love.graphics.setFont(self.littleFont)
        love.graphics.print("Created by: fletch, mrs fletch, kraaico, leiss", 10 + self.offset, love.graphics.getHeight() - self.littleFont:getHeight() - 10)
    love.graphics.pop()

    for _,button in ipairs(self.buttons) do
        button:draw()
    end
end

return MainMenu