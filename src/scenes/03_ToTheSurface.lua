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
local ToTheSurface = Container:extend()

local COLORS = require "utils.Colors"
local Button = require "components.Button"

function ToTheSurface:init(rules, parent)
    -- initialises all the container fields
    local view = ToTheSurface.super.new(self, rules)

    view.offset = 0

    view.font = love.graphics.newFont("assets/art/WindstilChonker-Regular.ttf", 40)

    view.bgImage = love.graphics.newImage("assets/art/water_bg.png")
    view.gillert = love.graphics.newImage("assets/art/gillert-swim.png")

    view.text = {
        "He needs your help to keep his strength up as he swims!",
        "Gillert finally made it to the surface, where his host family was waiting."
    }

    view.gravity = 0.2
    view.swim = -5
    view.pressed = false
    view.gillertPos = {x=(love.graphics.getWidth()/2)-(113/2), y=love.graphics.getHeight()-view.gillert:getHeight()}
    view.gillertVel = {dx=0, dy=0}

    view.playing = false
    view.hasWon = false

    local nextButtonAction = function()
        parent:nextScene()
    end

    local previousButtonAction = function()
        parent:previousScene()
    end

    local nextButton = Button:new("skip", 0, 0, nextButtonAction)
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

function ToTheSurface:setOffset(offset)
    self.offset = offset
    for _,button in ipairs(self.buttons) do
        button:setOffset(offset)
    end
end

function ToTheSurface:update( dt )
    if (self.playing) then
        self.gillertVel.dy = self.gillertVel.dy + self.gravity

        if (love.mouse.isDown(1) and not self.pressed) then
            self.pressed = true
            self.gillertVel.dy = self.swim
        end

        if (not love.mouse.isDown(1)) then
            self.pressed = false
        end

        self.gillertPos.y = self.gillertVel.dy + self.gillertPos.y

        if (self.gillertPos.y > love.graphics.getHeight()-self.gillert:getHeight()) then
            self.gillertPos.y = love.graphics.getHeight()-self.gillert:getHeight()
            self.gillertPos.dy = 0
            self.playing = false
        end

        if (self.gillertPos.y + self.gillert:getHeight() < 0) then
            self.hasWon = true
            self.playing = false
            self.buttons[1]:setText("next")
        end
    else
        if (love.mouse.isDown(1)) then
            self.playing = true
        end
    end

    for _,button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function ToTheSurface:draw()
    love.graphics.push("all")
        -- bg image
        love.graphics.draw(self.bgImage, self.offset)

        if (not self.playing and not self.hasWon) then
            -- text bg
            love.graphics.setColor(COLORS.colorFromHex("#00000060"))
            love.graphics.rectangle("fill", self.offset, 0, love.graphics.getWidth(), (self.font:getHeight() * 2) + 40)

            -- text
            love.graphics.setFont(self.font)
            love.graphics.setColor(COLORS.colorFromHex("#FFFFFF"))
            love.graphics.printf("Click the screen to help Gillert swim to the surface!", 20 + self.offset, 20, love.graphics.getWidth() - 40)
        elseif (self.hasWon) then
            -- text bg
            love.graphics.setColor(COLORS.colorFromHex("#00000060"))
            love.graphics.rectangle("fill", self.offset, 0, love.graphics.getWidth(), (self.font:getHeight() * 2) + 40)

            -- text
            love.graphics.setFont(self.font)
            love.graphics.setColor(COLORS.colorFromHex("#FFFFFF"))
            love.graphics.printf("Gillert finally made it to the surface, where his host family was waiting.", 20 + self.offset, 20, love.graphics.getWidth() - 40)
        end

        love.graphics.draw(self.gillert, love.graphics.newQuad(0, 0, 113, 116, self.gillert:getDimensions()), self.gillertPos.x + self.offset, self.gillertPos.y)
    love.graphics.pop()

    for _,button in ipairs(self.buttons) do
        button:draw()
    end
end

return ToTheSurface