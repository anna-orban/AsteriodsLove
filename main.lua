local turnSpeed = 10
local shipCircleDistance = 20
local shipRadius = 30
local bulletTimer = 0
local bulletRadius = 5

function love.load()
    areaWidth = love.graphics.getWidth()
    areaHeight = love.graphics.getHeight()
    asteroidStages = {
        {
            speed = 120,
            radius = 15
        },
        {
            speed = 70,
            radius = 30
        },
        {
            speed = 50,
            radius = 50
        },
        {
            speed = 20,
            radius = 80
        }
    }
    reset()
end

function reset()
    shipX = areaWidth / 2
    shipY = areaHeight / 2
    shipAngle = 0
    shipSpeedX = 0
    shipSpeedY = 0
    bullets = {}
    asteroids = {
        { 
            x = 100,
            y = 100
        },
        {
            x = areaWidth - 100,
            y = 100
        },
        {
            x = areaWidth / 2,
            y = areaHeight - 100
        }
    }
    for asteroidIndex, asteroid in ipairs(asteroids) do
        asteroid.angle = love.math.random() * (2 * math.pi)
        asteroid.stage = #asteroidStages
    end
end

function love.update(dt)
    local function areCirclesIntersecting(aX, aY, aRadius, bX, bY, bRadius)
        return (aX - bX)^2 + (aY - bY)^2 <= (aRadius - bRadius)^2
    end

    if love.keyboard.isDown('right') then
        shipAngle = (shipAngle + turnSpeed * dt) % (2 * math.pi)
    end
    if love.keyboard.isDown('left') then
        shipAngle = (shipAngle - turnSpeed * dt) % (2 * math.pi)
    end
    if love.keyboard.isDown('up') then
        local shipSpeed = 100
        shipSpeedX = shipSpeedX + math.cos(shipAngle) * shipSpeed * dt
        shipSpeedY = shipSpeedY + math.sin(shipAngle) * shipSpeed * dt
    end
    if love.keyboard.isDown('down') then
        local shipSpeed = 100
        shipSpeedX = shipSpeedX - math.cos(shipAngle) * shipSpeed * dt
        shipSpeedY = shipSpeedY - math.sin(shipAngle) * shipSpeed * dt
    end
    shipX = (shipX + shipSpeedX * dt) % areaWidth
    shipY = (shipY + shipSpeedY * dt) % areaHeight

    bulletTimer = bulletTimer + dt
    if love.keyboard.isDown('s') then
        if bulletTimer >= 0.5 then
            bulletTimer = 0
            table.insert(bullets, {
                x = shipX + math.cos(shipAngle) * shipRadius,
                y = shipY + math.sin(shipAngle) * shipRadius,
                angle = shipAngle,
                timeLeft = 4,
            })
        end
    end

    for bulletIndex = #bullets, 1, -1  do   
        local bullet = bullets[bulletIndex]
        bullet.timeLeft = bullet.timeLeft - dt
        if bullet.timeLeft <= 0 then
            table.remove(bullets, bulletIndex)
        else
            local bulletSpeed = 500
            bullet.x = (bullet.x + math.cos(bullet.angle) * bulletSpeed * dt) % areaWidth
            bullet.y = (bullet.y + math.sin(bullet.angle) * bulletSpeed * dt) % areaHeight
        end
        for asteroidIndex = #asteroids, 1, -1 do
            local asteroid = asteroids[asteroidIndex]
            if areCirclesIntersecting(asteroid.x, asteroid.y, asteroidStages[asteroid.stage].radius, bullet.x, bullet.y, bulletRadius) then
                table.remove(bullets, bulletIndex)  

                if asteroid.stage > 1 then
                    local angle1 = love.math.random() * (2 * math.pi)
                    local angle2 = (angle1 - math.pi) % (2 * math.pi)
                    table.insert(asteroids,{
                        x = asteroid.x,
                        y = asteroid.y,
                        angle = angle1,
                        stage = asteroid.stage - 1
                    })
                    table.insert(asteroids,{
                        x = asteroid.x,
                        y = asteroid.y,
                        angle = angle2,
                        stage = asteroid.stage - 1
                    })
                end
                table.remove(asteroids, asteroidIndex)
                break
            end
        end
    end

    for asteroidIndex, asteroid in ipairs(asteroids) do
        local asteroidSpeed = 20
        asteroid.x = (asteroid.x + math.cos(asteroid.angle) * asteroidStages[asteroid.stage].speed * dt) % areaWidth
        asteroid.y = (asteroid.y + math.sin(asteroid.angle) * asteroidStages[asteroid.stage].speed * dt) % areaHeight
        if areCirclesIntersecting(asteroid.x, asteroid.y, asteroidStages[asteroid.stage].radius, shipX, shipY, shipRadius) then
            reset()
            break
        end 
    end

    if #asteroids == 0 then
        reset()
    end
end

function love.draw()            
    for y=-1, 1 do
        for x = -1, 1 do
            love.graphics.origin()
            love.graphics.translate(x * areaWidth, y * areaHeight)

            love.graphics.setColor(0, 0, 1)
            love.graphics.circle('fill', shipX, shipY, shipRadius)
            love.graphics.setColor(0, 1, 1)
            love.graphics.circle('fill', shipX + math.cos(shipAngle) * shipCircleDistance, shipY + math.sin(shipAngle) * shipCircleDistance, 5)
            
            for bulletIndex, bullet in ipairs(bullets) do
                love.graphics.setColor(0, 1, 0)
                love.graphics.circle('fill', bullet.x, bullet.y, bulletRadius)
            end

            for asteroidIndex, asteroid in ipairs(asteroids) do
                love.graphics.setColor(1, 1, 0)
                love.graphics.circle('fill', asteroid.x, asteroid.y, asteroidStages[asteroid.stage].radius)
            end
        end
    end
    love.graphics.origin()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(table.concat({'shipAngle: '..shipAngle,
    'shipX: '..shipX,
    'shipY: '..shipY,
    'shipSpeedX: '..shipSpeedX,
    'shipSpeedY: '..shipSpeedY,
    }, '\n'))

end

