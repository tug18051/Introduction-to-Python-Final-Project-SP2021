WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

Class = require 'class'
push = require 'push'

require 'Text'
require 'Ball'
require 'Paddle'

function love.load()

    math.randomseed(os.time())

    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Power Pong')

    smallFont = love.graphics.newFont('Minecraftia-Regular.ttf', 8)
    scoreFont = love.graphics.newFont('Minecraftia-Regular.ttf', 32)
    victoryFont = love.graphics.newFont('Minecraftia-Regular.ttf', 24)

    sounds = {
        ['paddlehit'] = love.audio.newSource('paddlehit.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),
        ['wallhit'] = love.audio.newSource('wallhit.wav', 'static')
    }

    player1Score = 0
    player2Score = 0

    servingPlayer = math.random(2) == 1 and 1 or 2

    winningPlayer = 0

    paddle1 = Paddle(5, VIRTUAL_HEIGHT / 2 - 10, 5, 20)
    paddle1big = Paddle(5, VIRTUAL_HEIGHT / 2 - 20, 5, 40)
    paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT / 2 - 10, 5, 20)
    paddle2big = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT / 2 - 10, 5, 40)
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)
    text = Text(200, 250, 400, 200, '', false)
    if servingPlayer == 1 then
        ball.dx = 100
    else
        ball.dx = -100
    end

    gameState = 'start'
    gameMode = ''
    input = ''
    powerUpP1 = 0
    powerUpP2 = 0

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT,
                     {fullscreen = false, vsync = true, resizable = true})

    textbox = {
        x = 110,
        y = 150,
        width = VIRTUAL_WIDTH / 2,
        height = VIRTUAL_HEIGHT / 3,
        text = '',
        active = false,
        colors = {background = {1, 1, 1, 1}, text = {1, 1, 1, 1}}
    }

end

function love.resize(w, h) push:resize(w, h) end

function love.update(dt)
    if gameState == 'serve' then
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end

    elseif gameState == 'play' then
        if ball.x < 0 then
            servingPlayer = 2
            player2Score = player2Score + 1
            ball:reset()
            ball.dx = 100

            sounds['score']:play()

            if player2Score == 2 then
                gameState = 'victory'
                winningPlayer = 2
            else
                gameState = 'serve'
            end
        end

        if ball.x > VIRTUAL_WIDTH - 4 then
            servingPlayer = 1
            player1Score = player1Score + 1
            ball:reset()
            ball.dx = -100

            sounds['score']:play()

            if player1Score == 2 then
                gameState = 'victory'
                winningPlayer = 1
            else
                gameState = 'serve'
            end
        end
        -- elseif gameState == 'powerChallenge1' then #supposed to call textbox but doesn't work
        --     textbox.active = true

        --     if textbox.text == 'The quick brown fox jumped over the moon.' then
        --         powerUpP1 = powerUpP1 + 1
        --         textbox.text = ''
        --         textbox.active = false
        --         gameState = 'powerUpAchieved'
        --     else
        --         gameState = 'betterLuckNextTime'
        --         textbox.text = ''
        --         textbox.active = false
        --   end
    end

    if ball:collides(paddle1) then
        ball.dx = -ball.dx * 1.03
        ball.x = paddle1.x + 5

        sounds['paddlehit']:play()

        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end
    end

    if ball:collides(paddle1big) then
        if player1Score >= 1 then
            ball.dx = -ball.dx * 1.09
            ball.x = paddle1big.x + 5
        else
            ball.dx = -ball.dx * 1.03
            ball.x = paddle1big.x + 5
        end

        sounds['paddlehit']:play()

        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end
    end

    if ball:collides(paddle2) then
        ball.dx = -ball.dx * 1.03
        ball.x = paddle2.x - 5

        sounds['paddlehit']:play()

        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end
    end

    if ball:collides(paddle2big) then
        ball.dx = -ball.dx * 1.09
        ball.x = paddle2big.x - 5

        sounds['paddlehit']:play()

        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end
    end

    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy

        sounds['wallhit']:play()
    end

    if ball.y >= VIRTUAL_HEIGHT - 4 then
        ball.dy = -ball.dy
        ball.y = VIRTUAL_HEIGHT - 4
        sounds['wallhit']:play()
    end

    -- p1 movement
    if love.keyboard.isDown('w') then
        paddle1.dy = -PADDLE_SPEED
        paddle1.dx = 0
        paddle1big.dy = -PADDLE_SPEED
        paddle1big.dx = 0
    elseif love.keyboard.isDown('s') then
        paddle1.dy = PADDLE_SPEED
        paddle1.dx = 0
        paddle1big.dy = PADDLE_SPEED
        paddle1big.dx = 0
    elseif player1Score >= 1 then -- powerUp1 would be here 
        if love.keyboard.isDown('a') then
            paddle1.dx = -PADDLE_SPEED
            paddle1.dy = 0
            paddle1big.dx = -PADDLE_SPEED
            paddle1big.dy = 0
        elseif love.keyboard.isDown('d') then
            paddle1.dx = PADDLE_SPEED
            paddle1.dy = 0
            paddle1big.dx = PADDLE_SPEED
            paddle1big.dy = 0
        else
            paddle1.dy = 0
            paddle1.dx = 0
            paddle1big.dy = 0
            paddle1big.dx = 0
        end
    else
        paddle1.dy = 0
        paddle1.dx = 0
        paddle1big.dy = 0
        paddle1big.dx = 0
    end
    -- p2 movement + ai
    if gameMode == 'cpu' then
        if ball.x > 6 * VIRTUAL_WIDTH / 10 then
            if paddle2.y + paddle2.height/2 > ball.y then
                paddle2.dy = -175
            elseif paddle2.y + paddle2.height/2 < ball.y then
                paddle2.dy = 175
            else
                paddle2.dy = 0
            end
        end
        if ball.x > 6 * VIRTUAL_WIDTH / 10 then
            if paddle2big.y + paddle2big.height/2 > ball.y then
                paddle2big.dy = -175
            elseif paddle2big.y + paddle2big.height/2 < ball.y then
                paddle2big.dy = 175
            else
                paddle2big.dy = 0
            end
        end
    elseif gameMode == 'p2' then
        if love.keyboard.isDown('up') then
            paddle2.dy = -PADDLE_SPEED
            paddle2.dx = 0
            paddle2big.dy = -PADDLE_SPEED
            paddle2big.dx = 0
        elseif love.keyboard.isDown('down') then
            paddle2.dy = PADDLE_SPEED
            paddle2.dx = 0
            paddle2big.dy = PADDLE_SPEED
            paddle2big.dx = 0
        elseif player2Score >= 1 then -- powerUp2 would be here
            if love.keyboard.isDown('left') then
                paddle2.dx = -PADDLE_SPEED
                paddle2.dy = 0
                paddle2big.dx = -PADDLE_SPEED
                paddle2big.dy = 0
            elseif love.keyboard.isDown('right') then
                paddle2.dx = PADDLE_SPEED
                paddle2.dy = 0
                paddle2big.dx = PADDLE_SPEED
                paddle2big.dy = 0
            else
                paddle2.dy = 0
                paddle2.dx = 0
                paddle2big.dy = 0
                paddle2big.dx = 0
            end
        else
            paddle2.dy = 0
            paddle2.dx = 0
            paddle2big.dy = 0
            paddle2big.dx = 0
        end
    end

    if gameState == 'play' then ball:update(dt) end

    if player1Score >= 1 then -- powerUp1 would be here
        paddle1big:update(dt)
    else
        paddle1:update(dt)
    end
    if player2Score >= 1 then -- powerUp2 would be here
        paddle2big:update(dt)
    else
        paddle2:update(dt)
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()

    elseif key == 'enter' or key == 'return' then
        if gameState == 'victory' then
            gameState = 'start'
            player1Score = 0
            player2Score = 0
            paddle1:reset()
            paddle2:reset()
        elseif gameState == 'serve' or gameState == 'directionsP2' or gameState ==
            'directionsCPU' then
            gameState = 'play'
        end
    elseif key == '1' then
        if gameState == 'start' then
            gameMode = 'p2'
            gameState = 'directionsP2'
        end
    elseif key == '2' then
        if gameState == 'start' then
            gameMode = 'cpu'
            gameState = 'directionsCPU'
        end

        -- elseif key == '7' then #shortcut to test
        --     gameState = 'powerChallenge1'

        -- elseif gameState == 'powerChallenge1' then

        -- elseif gameState == 'powerUp1Achieved' then
        --     if key == 'enter' then gameState = 'serve' end
    end
end

function love.draw()
    push:apply('start')

    -- background color
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    -- title
    love.graphics.setFont(smallFont)

    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Power Pong!', 0, 10, VIRTUAL_WIDTH,
                             'center')
        love.graphics.printf('Press 1 to Play against another Player.', 0, 20,
                             VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press 2 to Play against CPU.', 0, 30,
                             VIRTUAL_WIDTH, 'center')
    elseif gameState == 'directionsCPU' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('You will be Player 1! (Left Paddle)', 0, 10,
                             VIRTUAL_WIDTH, 'center')
        love.graphics.printf(
            'Use the W or S key to move the paddle up and down.', 0, 20,
            VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s turn!",
                             0, 30, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to Serve!', 0, 40, VIRTUAL_WIDTH,
                             'center')
        displayScore()
    elseif gameState == 'directionsP2' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player 1 movement: W / S (Left Paddle)', 0, 10,
                             VIRTUAL_WIDTH, 'center')
        love.graphics.printf(
            'Player 2 movement: Arrow key Up / Down. (Right Paddle)', 0, 20,
            VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s turn!",
                             0, 30, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to Serve!', 0, 40, VIRTUAL_WIDTH,
                             'center')
        displayScore()
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s turn!",
                             0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to Serve!', 0, 20, VIRTUAL_WIDTH,
                             'center')
        love.graphics.printf('Press ESC to quit.', VIRTUAL_WIDTH / 2 - 210,
                             VIRTUAL_HEIGHT - 22, VIRTUAL_WIDTH, 'center')
        displayScore()
    elseif gameState == 'victory' then
        love.graphics.setFont(victoryFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. " wins!",
                             0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to Serve!', 0, 42, VIRTUAL_WIDTH,
                             'center')
        -- elseif gameState == 'powerChallenge1' then
        --     love.graphics.setColor(unpack(textbox.colors.background))
        --     love.graphics.rectangle('line', textbox.x, textbox.y, textbox.width,
        --                             textbox.height)

        --     love.graphics.setColor(unpack(textbox.colors.text))
        --     love.graphics.printf(textbox.text, textbox.x, textbox.y, textbox.width,
        --                          'left')
        --     love.graphics.printf('The quick brown fox jumped over the moon.', 0, 40,
        --                          VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        -- do nothing
    end

    -- render pong ball
    ball:render()

    -- render both paddles
    if player1Score >= 1 then
        paddle1big:render()
    else
        paddle1:render()
    end

    if player2Score >= 1 then
        paddle2big:render()
    else
        paddle2:render()
    end

    displayFPS()

    push:apply('end')
end

function displayFPS()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(smallFont)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()),
                        VIRTUAL_WIDTH / 2 - 16, VIRTUAL_HEIGHT - 12)
    love.graphics.setColor(1, 1, 1, 1)
end

function displayScore()
    -- scoreboard
    love.graphics.setFont(scoreFont)
    love.graphics
        .print(player1Score, VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics
        .print(player2Score, VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end

function love.textinput(text)
    if textbox.active then textbox.text = textbox.text .. text end
end

