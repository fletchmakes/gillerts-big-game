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

local flux = require "libs.flux.flux"
local Plan = require "libs.plan.plan"
local Rules = Plan.Rules

local Container = Plan.Container
local GameView = Container:extend()

local COLORS = require "utils.Colors"

local MainMenu = require "scenes.00_MainMenu"
local Introduction = require "scenes.01_Introduction"
local MermaidFamily = require "scenes.02_MermaidFamily"
local ToTheSurface = require "scenes.03_ToTheSurface"
local Neighby = require "scenes.04_Neighby"
local SurfaceSchool = require "scenes.05_SurfaceSchool"
local MeetingCJ = require "scenes.07_MeetingCJ"
local MeetingRyan = require "scenes.08_MeetingRyan"
local SavingTheDay = require "scenes.09_SavingTheDay"
local GrowingApart = require "scenes.10_GrowingApart"
local BiologyClass = require "scenes.11_BiologyClass"
local TheLetter = require "scenes.12_TheLetter"
local SurpriseParty = require "scenes.13_SurpriseParty"
local TheChampionship = require "scenes.14_TheChampionship"
local TheBigGame = require "scenes.15_TheBigGame"
local Conclusion = require "scenes.16_Conclusion"
local TheEnd = require "scenes.17_TheEnd"

local AudioManager = require "components.AudioManager"

function GameView:new(rules)
    -- initialises all the container fields
    local gameView = GameView.super.new(self, rules)

    gameView.flux = flux

    gameView.rules = Rules.new()
        :addX(Plan.relative(0))
        :addY(Plan.relative(0))
        :addWidth(Plan.relative(1))
        :addHeight(Plan.relative(1))

    gameView.next = nil
    gameView.tween = nil

    gameView.audioManager = AudioManager:new()
    gameView.audioManager:play()

    gameView.scenes = {
        MainMenu:init(rules, gameView),
        Introduction:init(rules, gameView),
        MermaidFamily:init(rules, gameView),
        ToTheSurface:init(rules, gameView),
        Neighby:init(rules, gameView),
        SurfaceSchool:init(rules, gameView),
        MeetingCJ:init(rules, gameView),
        MeetingRyan:init(rules, gameView),
        SavingTheDay:init(rules, gameView),
        GrowingApart:init(rules, gameView),
        BiologyClass:init(rules, gameView),
        TheLetter:init(rules, gameView),
        SurpriseParty:init(rules, gameView),
        TheChampionship:init(rules, gameView),
        TheBigGame:init(rules, gameView),
        Conclusion:init(rules, gameView),
        TheEnd:init(rules, gameView)
    }
    gameView.sceneIdx = 1
    gameView.scene = gameView.scenes[1]
    gameView:addChild(gameView.scene)

    gameView.sceneOffset = 0
    gameView.volume = 0.3

    return gameView
end

function GameView:nextScene()
    if (self.tween ~= nil) then return end
    if (self.sceneIdx >= #self.scenes) then return end

    self.sceneIdx = self.sceneIdx + 1
    self.next = self.scenes[self.sceneIdx]

    for _,button in ipairs(self.scene.buttons) do
        button:disable()
    end

    for _,button in ipairs(self.next.buttons) do
        button:disable()
    end

    self.tween = flux.to(self, 1, {sceneOffset=-love.graphics.getWidth()})
        :ease("quadinout")
        :onupdate(function()
            self.scene:setOffset(self.sceneOffset)
            self.next:setOffset(self.sceneOffset + love.graphics.getWidth())
        end)
        :oncomplete(function()
            self:removeChild(self.scene)
            self.scene = self.next
            self:addChild(self.scene)
            self.sceneOffset = 0
            self.next = nil
            self.tween = nil

            for _,button in ipairs(self.scene.buttons) do
                button:enable()
            end

            if (self.scene.pages ~= nil) then
                self.scene.pages[self.scene.pageIdx]()
            end
        end)
end

function GameView:previousScene()
    if (self.tween ~= nil) then return end
    if (self.sceneIdx <= 1) then return end

    self.sceneIdx = self.sceneIdx - 1
    self.next = self.scenes[self.sceneIdx]

    for _,button in ipairs(self.scene.buttons) do
        button:disable()
    end

    for _,button in ipairs(self.next.buttons) do
        button:disable()
    end

    self.tween = flux.to(self, 1, {sceneOffset=love.graphics.getWidth()})
        :ease("quadinout")
        :onupdate(function()
            self.scene:setOffset(self.sceneOffset)
            self.next:setOffset(self.sceneOffset - love.graphics.getWidth())
        end)
        :oncomplete(function()
            self:removeChild(self.scene)
            self.scene = self.next
            self:addChild(self.scene)
            self.sceneOffset = 0
            self.next = nil
            self.tween = nil

            for _,button in ipairs(self.scene.buttons) do
                button:enable()
            end

            if (self.scene.pages ~= nil) then
                self.scene.pages[self.scene.pageIdx]()
            end
        end)
end

function GameView:lowerVolume()
    self.flux.to(self, 1, {volume=0})
        :ease("quadinout")
        :onupdate(function()
            self.audioManager:setVolume(self.volume)
        end)
end

function GameView:raiseVolume()
    self.flux.to(self, 1, {volume=0.3})
        :ease("quadinout")
        :onupdate(function()
            self.audioManager:setVolume(self.volume)
        end)
end

function GameView:update( dt )
    flux.update(dt)

    if (self.next ~= nil) then
        self.next:update(dt)
    end

    self.scene:update(dt)
    self.audioManager:update(dt)
end

function GameView:draw()
    love.graphics.push("all")
        local color = COLORS.black
        love.graphics.setColor(color)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    love.graphics.pop()

    if (self.next ~= nil) then
        self.next:draw()
    end

    self.scene:draw()
end

return GameView