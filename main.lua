--[[
  sina lukin e ni la o toki tawa jan Wito kepeken toki Inli
  e ni: o unpa e sina.
  
  o toki ala tawa jan Wito e sitelen ni.
  
  pona.
  - kili loje otesunki
--]]

frame = 0

StateManager = {}
function StateManager:new(initialstate)
  self.__index = self
  initialstate:enter()
  return setmetatable({state = initialstate, newstate = initialstate}, self)
end

function StateManager:draw()
  self.state:draw(self)
  self:handlestatetransition()
end

function StateManager:handlestatetransition()
  if self.newstate ~= self.state then
    self.state:exit()
    self.state = self.newstate
    self.state:enter()
  end
end

function StateManager:swapto(newstate)
  self.newstate = newstate
end

function StateManager:keypressed(key)
  self.state:keypressed(self, key)
  self:handlestatetransition()
end

function StateManager:mousepressed(x, y, button)
  self.state:mousepressed(self, x, y, button)
  self:handlestatetransition()
end

MainMenu = {}
function MainMenu:new()
  self.__index = self
  return setmetatable({
    logo = love.graphics.newImage('logo.png')
  }, self)
end

function MainMenu:enter() end
function MainMenu:exit() end

function MainMenu:draw(state)
  x = (love.graphics.getWidth() - self.logo:getWidth()) / 2
  y = (love.graphics.getHeight() / 3 - self.logo:getHeight())
  love.graphics.clear(255, 255, 255, 0)
  love.graphics.draw(self.logo, x, y)
  x = love.graphics.getWidth() / 2
  y = love.graphics.getHeight() * 2 / 3
  love.graphics.printf(
    {{0, 0, 255, 255}, 'if you are gay press A\notherwise press I'},
    x, y,
    99999999999
  )
end

function MainMenu:keypressed(state, key)
  if key == 'a' or key == 'i' then
    state:swapto(game)
  end
end

function MainMenu:mousepressed(state, x, y, button) end

Game = {}
function Game:new()
  self.__index = self
  return setmetatable({
    ppl = 1
  }, self)
end

function Game:enter() end
function Game:exit() end

function Game:draw(state)
  love.graphics.print("bnb total population", 0, 0)
  if self.ppl == 1 then
    love.graphics.print(self.ppl .. " person (literally just victor)", 0, 20)
  else
    love.graphics.print(self.ppl .. " people", 0, 20)
  end
  love.graphics.print("click to spam friends with invites", 0, 40)
end

function Game:keypressed(state, key) end

function Game:mousepressed(state, x, y, button)
  if button == 1 then
    self.ppl = self.ppl * 6
    love.audio.play(love.audio.newSource('markiplier-e.mp3', 'static'))
  end
end

function love.load()
  mainmenu = MainMenu:new()
  game = Game:new()
  state = StateManager:new(mainmenu)
end

function love.draw()
  frame = frame + 1
  state:draw()
end

function love.keypressed(key, code, isrepeat)
  if not isrepeat then
    state:keypressed(key)
  end
end

function love.mousepressed(x, y, button, istouch, presses)
  state:mousepressed(x, y, button)
end