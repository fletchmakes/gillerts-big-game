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


local AudioManager = {}

function AudioManager:new()
    local manager = {}
    setmetatable(manager, self )
    self.__index = self

    local bgm1 = love.audio.newSource("assets/music/BGM1.ogg", "stream")
    local bgm2 = love.audio.newSource("assets/music/BGM2.ogg", "stream")

    manager.tracks = {
        { song=bgm1, loopStart=0, loopEnd=bgm1:getDuration("samples"), loopable=false },
        { song=bgm2, loopStart=426562, loopEnd=bgm2:getDuration("samples"), loopable=false },
    }

    manager.sfx = {
        crowd = love.audio.newSource("assets/music/Crowd.ogg", "stream")
    }

    manager.trackIdx = 1

    return manager
end

function AudioManager:play()
    local song = self.tracks[self.trackIdx].song
    song:seek(0, "samples")
    song:setLooping(true)
    song:setVolume(0.3)
    song:play()
end

function AudioManager:pause()
    local song = self.tracks[self.trackIdx].song
    song:pause()
end

function AudioManager:stop()
    local song = self.tracks[self.trackIdx].song
    song:stop()
end

function AudioManager:startCrowd()
    if (not self.sfx.crowd:isPlaying()) then
        self.sfx.crowd:setLooping(true)
        self.sfx.crowd:play()
    end
end

function AudioManager:stopCrowd()
    if (self.sfx.crowd:isPlaying()) then
        self.sfx.crowd:stop()
    end
end

function AudioManager:setVolume(newVolume)
    local song = self.tracks[self.trackIdx].song
    song:setVolume(newVolume)
end

function AudioManager:setTrack(newTrackIdx)
    if (self.trackIdx == newTrackIdx) then return end

    self:stop()
    self.trackIdx = newTrackIdx
    self:play()
end

-- improvised from: https://love2d.org/forums/viewtopic.php?t=81670
function AudioManager:update( dt )
    local track = self.tracks[self.trackIdx]
    -- note that with vsync on, this might not be fast enough for the code to be precise enough.
    local now = track.song:tell("samples")

    if (track.loopable == false and now > track.loopStart) then
        track.loopable = true
    end

    -- the now < loopStart part kinda forces the music to not start at the beginning, if that's set somewhere else;
    -- this can be solved in more than one way, depending on what you want to accomplish
    if ((now < track.loopStart or now > track.loopEnd) and track.loopable == true) then
        -- probably could use a better point to seek to, calculated by now - loopEnd or something,
        -- but that may have issues if one were to use it simply like that
        track.song:seek(track.loopStart ,"samples")
    end
end

return AudioManager