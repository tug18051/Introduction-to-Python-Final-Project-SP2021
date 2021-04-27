Text = Class {}

-- function Text:init(x, y, width, height, text, active)

--     self.x = x
--     self.y = y
--     self.width = width
--     self.height = height
--     self.text = text
--     self.active = active
--    

--     if show1 == true then function love.textinput(t) txt1 = t end end
-- end
function Text:init()

    self.x = 200
    self.y = 250
    self.width = 400
    self.height = 200
    self.text = ''
    self.active = false
    -- self.colors = {
    --     background = {255 / 255, 255 / 255, 255 / 255, 255 / 255},
    --     text = {40, 40, 40, 255}
    -- }
    show1 = true
    --if show1 == true then love.textinput(t) txt1 .. t end
end

function Text:textinput(text)
    if self.active then self.text = self.text .. text end
end

function Text:mousepressed(x, y)
    if x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y +
        self.height then
        self.active = true
    elseif self.active then
        self.active = false
    end
end

function Text:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

    love.graphics.setColor(0, 0, 0, 0)
    love.graphics.setFont(smallFont)
    love.graphics.printf(self.text, self.x, self.y, self.width, 'left')
end

