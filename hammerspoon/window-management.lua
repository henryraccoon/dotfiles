local This = {}

-- 6x6 grid allows both 1/2 and 1/3 divisions
local GRID_SIZE = 6
local HALF_GRID_SIZE = GRID_SIZE / 2
local THIRD_GRID_SIZE = GRID_SIZE / 3

-- Set the grid size and add a few pixels of margin
hs.grid.setGrid(GRID_SIZE .. 'x' .. GRID_SIZE)
hs.grid.setMargins({5, 5})
hs.window.animationDuration = 0

-- Defining screen positions
local screenPositions       = {}

-- Half positions
screenPositions.left        = {x = 0,              y = 0,              w = HALF_GRID_SIZE, h = GRID_SIZE     }
screenPositions.right       = {x = HALF_GRID_SIZE, y = 0,              w = HALF_GRID_SIZE, h = GRID_SIZE     }
screenPositions.top         = {x = 0,              y = 0,              w = GRID_SIZE,      h = HALF_GRID_SIZE}
screenPositions.bottom      = {x = 0,              y = HALF_GRID_SIZE, w = GRID_SIZE,      h = HALF_GRID_SIZE}

screenPositions.topLeft     = {x = 0,              y = 0,              w = HALF_GRID_SIZE, h = HALF_GRID_SIZE}
screenPositions.topRight    = {x = HALF_GRID_SIZE, y = 0,              w = HALF_GRID_SIZE, h = HALF_GRID_SIZE}
screenPositions.bottomLeft  = {x = 0,              y = HALF_GRID_SIZE, w = HALF_GRID_SIZE, h = HALF_GRID_SIZE}
screenPositions.bottomRight = {x = HALF_GRID_SIZE, y = HALF_GRID_SIZE, w = HALF_GRID_SIZE, h = HALF_GRID_SIZE}

-- Third positions
screenPositions.leftThird       = {x = 0,                          y = 0, w = THIRD_GRID_SIZE,     h = GRID_SIZE}
screenPositions.rightThird      = {x = GRID_SIZE - THIRD_GRID_SIZE, y = 0, w = THIRD_GRID_SIZE,     h = GRID_SIZE}
screenPositions.leftTwoThirds   = {x = 0,                          y = 0, w = GRID_SIZE - THIRD_GRID_SIZE, h = GRID_SIZE}
screenPositions.rightTwoThirds  = {x = THIRD_GRID_SIZE,            y = 0, w = GRID_SIZE - THIRD_GRID_SIZE, h = GRID_SIZE}

This.screenPositions = screenPositions

-- Move the focused (or specified) window to a grid position
function This.moveWindowToPosition(cell, window)
  if window == nil then
    window = hs.window.focusedWindow()
  end
  if window then
    local screen = window:screen()
    hs.grid.set(window, cell, screen)
  end
end

-- Maximize the focused (or specified) window
function This.windowMaximize(factor, window)
   if window == nil then
      window = hs.window.focusedWindow()
   end
   if window then
      window:maximize()
   end
end

return This
