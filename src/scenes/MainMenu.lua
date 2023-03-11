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


local Flux = require "libs.flux.flux"
local Plan = require "libs.plan.plan"
local Rules = Plan.Rules

local Container = Plan.Container
local MainMenu = Container:extend()

local COLORS = require "utils.Colors"
local Button = require "components.Button"
local Introduction = require "scenes.Introduction"

function MainMenu:init(rules, parent)
    -- initialises all the container fields
    local view = MainMenu.super.new(self, rules)

    view.font = love.graphics.newFont("assets/art/WindstilChonker-Regular.ttf", 90)
    view.littleFont = love.graphics.newFont("assets/art/WindstilChonker-Regular.ttf", 30)
    view.bgImage = love.graphics.newImage("assets/art/classroom.png")

    view.scaleX = love.graphics.getWidth() / view.bgImage:getWidth()
    view.scaleY = love.graphics.getHeight() / view.bgImage:getHeight()

    view.title = "Gillert's Big Game"
    view.titleX = 0
    view.titleY = 0

    local playButtonAction = function()
        local nextScene = Introduction:init(rules)
        parent:switchScene(nextScene)
    end

    view.playButton = Button:new("play", 0, 0, playButtonAction)
    local buttonX = (love.graphics.getWidth() / 2) - (view.playButton:getWidth() / 2)
    view.playButton:setPosition(buttonX, 400)

    return view
end

function MainMenu:update( dt )
    self.titleX = (love.graphics.getWidth() / 2) - (self.font:getWidth(self.title) / 2)
    self.titleY = (love.graphics.getHeight() / 2) - (self.font:getHeight() / 2)

    self.playButton:update(dt)
end

function MainMenu:draw()
    love.graphics.push("all")
        -- bg image
        love.graphics.draw(self.bgImage, 0, 0, 0, self.scaleX, self.scaleY)

        -- text bg
        love.graphics.setColor(COLORS.colorFromHex("#00000060"))
        love.graphics.rectangle("fill", 0, self.titleY - 10, love.graphics.getWidth(), self.font:getHeight() + 10)

        -- text
        love.graphics.setFont(self.font)
        love.graphics.setColor(COLORS.colorFromHex("#FFFFFF"))
        love.graphics.print(self.title, self.titleX, self.titleY)

        -- credits
        love.graphics.setFont(self.littleFont)
        love.graphics.print("Created by: fletch, mrs fletch, kraaico, leiss", 10, love.graphics.getHeight() - self.littleFont:getHeight() - 10)

        self.playButton:draw()
    love.graphics.pop()
end

return MainMenu