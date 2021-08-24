function love.load()
    love.window.setTitle('ShootingGallery')

    target = {}
    target.x = 300
    target.y = 300
    target.radius = 30

    GAME_TIMER = 30

    -- DOT NOT CHANGE THESE
    score = 0
    timer = 0
    playing = false

    sprites = {}
    sprites.crosshairs = love.graphics.newImage('sprites/crosshairs.png')
    sprites.sky = love.graphics.newImage('sprites/sky.png')
    sprites.target = love.graphics.newImage('sprites/target.png')

    -- Scaling target sprite to the size of its hitbox
    scaleX, scaleY = getImageScale(sprites.target, target.radius * 2, target.radius * 2)
end

-- Will be ran 60 times per second (60 FPS)
function love.update(dt) -- dt => delta time
    if playing then
        if timer > 0 then
            timer = timer - dt
        end
    
        if timer < 0 then
            timer = 0
            playing = false
        end
    end
end

function love.draw()
    -- Background
    love.graphics.draw(sprites.sky, 0, 0)

    if not playing then
        love.graphics.setFont(love.graphics.newFont(30))
        love.graphics.printf('Click anywhere to begin!', 0, love.graphics.getHeight() / 2 - love.graphics.getFont():getHeight() / 2, love.graphics.getWidth(), 'center')
    else
        -- Score & timer
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(18))
        love.graphics.print('Score: ' .. score, 0, 0)
        love.graphics.print('Time remaining: ' .. math.ceil(timer) .. 's', 0, love.graphics.getFont():getHeight())
    end

    -- Target 
    if playing then
        love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius, 0, scaleX, scaleY)
    end

    -- Crosshairs
    love.graphics.draw(sprites.crosshairs, love.mouse.getX() - sprites.crosshairs:getWidth() / 2, love.mouse.getY() - sprites.crosshairs:getHeight() / 2)
    love.mouse.setVisible(false)
end

function love.mousepressed(x, y, button, istouch, presses)
    if playing then
        if distance(x, y, target.x, target.y) <= target.radius then
            if button == 1 then
                score = score + 1
            else
                score = score + 2
                timer = timer - 1
            end

            -- Change position of the target
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
        
        elseif score > 0 then
            score = score - 1
        end

    else
        playing = true
        score = 0
        timer = GAME_TIMER
    end
end

function getImageScale(image, newWidth, newHeight)
    local currentWidth, currentHeight = image:getDimensions()
    return (newWidth / currentWidth), (newHeight / currentHeight)
end

function distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end