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
local TheBigGame = Container:extend()

local COLORS = require "utils.Colors"
local Button = require "components.Button"

function TheBigGame:init(rules, parent)
    -- initialises all the container fields
    local view = TheBigGame.super.new(self, rules)

    view.offset = 0

    view.font = love.graphics.newFont("assets/art/WindstilChonker-Regular.ttf", 40)
    math.randomseed(os.time())

    view.bgImage = love.graphics.newImage("assets/art/goal.png")
    view.gillert = love.graphics.newImage("assets/art/gillert-kick.png")
    view.ball = love.graphics.newImage("assets/art/ball.png")
    view.ballSpawn = {x=330, y=490}
    view.ballPos = {x=330, y=490}
    view.gillertFrame = 0
    view.gillertPos = {x=240, y=400}

    view.target = {x=math.random(350, 650), y=math.random(150, 300), r=25}
    view.targetsHit = 0
    view.timeStart = love.timer.getTime()

    view.flux = parent.flux
    view.ballTween = false

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

function TheBigGame:setOffset(offset)
    self.offset = offset
    for _,button in ipairs(self.buttons) do
        button:setOffset(offset)
    end
end

function TheBigGame:update( dt )
    -- SOCCER GOAL IS LOCATED AT X1: 325, Y1: 125, X2: 675, Y2: 325
    self.target.r = 25 + (math.sin((love.timer.getTime() - self.timeStart)*2) * 5)

    if (self.playing) then
        if (not self.hasWon and self.targetsHit >= 5) then
            self.hasWon = true
            self.playing = false
            self.buttons[1]:setText("next")
        end

        if (love.mouse.isDown(1) and not self.ballTween) then
            local mouseX, mouseY = love.mouse.getPosition()
            
            self.ballTween = true
            self.flux.to(self, 0.4, {gillertFrame = 2.99})
                :ease("linear")
                :oncomplete(function()
                    self.flux.to(self.ballPos, 1, {x=mouseX, y=mouseY})
                        :ease("quadout")
                        :oncomplete(function() 
                            -- check to see if we got the goal
                            local dist = math.sqrt((self.ballPos.x - self.target.x)*(self.ballPos.x - self.target.x) + (self.ballPos.y - self.target.y)*(self.ballPos.y - self.target.y))
                            if (dist < 25) then
                                self.targetsHit = self.targetsHit + 1
                                self.target.x = math.random(350, 650)
                                self.target.y = math.random(150, 300)
                            end

                            self.ballPos.x = self.ballSpawn.x
                            self.ballPos.y = self.ballSpawn.y
                            self.ballTween = false
                            self.gillertFrame = 0
                        end)
                end)
        end

    elseif (not self.playing and not self.hasWon) then
        if (love.mouse.isDown(1) and not self.buttons[1].disabled) then
            self.playing = true
        end
    end
    for _,button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function TheBigGame:draw()
    love.graphics.push("all")
        -- bg image
        love.graphics.draw(self.bgImage, self.offset)
        love.graphics.draw(self.gillert, love.graphics.newQuad(101*math.floor(self.gillertFrame), 0, 101, 138, self.gillert:getDimensions()), self.gillertPos.x + self.offset, self.gillertPos.y)
        love.graphics.draw(self.ball, self.ballPos.x + self.offset, self.ballPos.y)

        love.graphics.setColor({1, 0, 0})
        love.graphics.setLineWidth(5)
        love.graphics.circle("line", self.target.x + self.offset, self.target.y, self.target.r)

        if (not self.playing and not self.hasWon) then
            -- text bg
            love.graphics.setColor(COLORS.textBackground)
            love.graphics.rectangle("fill", self.offset, 0, love.graphics.getWidth(), (self.font:getHeight() * 2) + 40)

            -- text
            love.graphics.setFont(self.font)
            love.graphics.setColor(COLORS.white)
            love.graphics.printf("Click on the targets to shoot the ball!", 20 + self.offset, 20, love.graphics.getWidth() - 40)

        elseif (self.playing) then
            -- text bg
            love.graphics.setColor(COLORS.textBackground)
            love.graphics.rectangle("fill", self.offset, 0, love.graphics.getWidth(), (self.font:getHeight()) + 40)

            -- text
            love.graphics.setFont(self.font)
            love.graphics.setColor(COLORS.white)
            love.graphics.print("GOALS MADE: "..tostring(self.targetsHit), 20 + self.offset, 20)
        elseif (self.hasWon) then
            -- text bg
            love.graphics.setColor(COLORS.textBackground)
            love.graphics.rectangle("fill", self.offset, 0, love.graphics.getWidth(), (self.font:getHeight() * 2) + 40)

            -- text
            love.graphics.setFont(self.font)
            love.graphics.setColor(COLORS.white)
            love.graphics.printf("He did it! Gillert won the game!", 20 + self.offset, 20, love.graphics.getWidth() - 40)
        end
    love.graphics.pop()

    for _,button in ipairs(self.buttons) do
        button:draw()
    end
end

return TheBigGame