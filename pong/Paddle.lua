Paddle = Class{}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y 
    self.width = width 
    self.height = height

    self.dx = 0
    self.dy = 0
end

function Paddle:update(dt)
    if self.dy < 0 then -- go up
        self.y = math.max(0, self.y + self.dy * dt)
    elseif self.dy > 0 then -- go down
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end

    if self.dx > 0 then --go right
        if self.x >=  2 * VIRTUAL_WIDTH/3 then
            self.x = math.min(VIRTUAL_WIDTH - 10, self.x + self.dx * dt)
        else
            self.x = math.min(VIRTUAL_WIDTH / 3, self.x + self.dx * dt)
        end
    elseif self.dx < 0 then --go left
        if self.x >=  2 * VIRTUAL_WIDTH/3 then
             self.x = math.max(2 * VIRTUAL_WIDTH/3, self.x + self.dx * dt)
        else   
            self.x = math.max(5, self.x + self.dx * dt)  
        end
        
    end
end

function Paddle:reset()
    if self.x < VIRTUAL_WIDTH / 2 then
        self.x = 5
        self.y = VIRTUAL_HEIGHT / 2 - 10
    else
        self.x = VIRTUAL_WIDTH - 10
        self.y = VIRTUAL_HEIGHT / 2 - 10
    end
end

function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end