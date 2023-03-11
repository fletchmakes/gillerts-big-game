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

    manager.tracks =  {
        love.audio.newSource("assets/music/bgm-1-bossa-nova.mp3", "stream")
    }

    manager.trackIdx = 1

    return manager
end

function AudioManager:play()
    self.tracks[self.trackIdx]:play()
end

function AudioManager:pause()
    self.tracks[self.trackIdx]:pause()
end

function AudioManager:stop()
    self.tracks[self.trackIdx]:stop()
end

function AudioManager:setTrack(newTrackIdx)
    self.trackIdx = newTrackIdx
    self:stop()
    self:play()
end

return AudioManager