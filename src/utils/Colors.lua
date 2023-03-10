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


-- inspo taken from: https://love2d.org/forums/viewtopic.php?t=9395
function colorFromHex(hex)
    local splitToRGB = {}
    
    -- check for leading pound
    if string.sub(hex, 1, 1) == "#" then hex = string.sub(hex, 2) end
		
    -- ensure the hexes are long enough for evaluation
    if #hex < 8 then hex = hex .. string.rep("F", 8 - #hex) end
    
    for x=1,#hex-1,2 do
        table.insert(splitToRGB, tonumber(hex:sub(x, x + 1), 16) / 255) --convert hexes to dec
        if splitToRGB[#splitToRGB] < 0 then splitToRGB[#splitToRGB] = 0 end --prevents negative values
    end
    
    return splitToRGB
end

return {
    colorFromHex = colorFromHex
}