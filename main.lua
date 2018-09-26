local turnSpeed = 10
local shipCircleDistance = 20
local shipRadius = 30
local bulletTimer = 0

function love.load()
    areaWidth = 800
    areaHeight = 600
    shipX = areaWidth / 2
    shipY = areaHeight / 2
    shipAngle = 0
    shipSpeedX = 0
    shipSpeedY = 0
    bullets = {}
    asteroids = {
        { 
            x = 100,
            y = 100,
        },
        {
            x = areaWidth - 100,
            y = 100,
        },
        {
            x = areaWidth / 2,
            y = areaHeight - 100,
        }
    }

    for asteroidIndex, asteroid in ipairs(asteroids) do
        asteroid.angle = love.math.random() * (2 * math.pi)
    end
 end

function love.update(dt)
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
    end

    for asteroidIndex, asteroid in ipairs(asteroids) do
        local asteroidSpeed = 20
        asteroid.x = (asteroid.x + math.cos(asteroid.angle) * asteroidSpeed * dt) % areaWidth
        asteroid.y = (asteroid.y + math.sin(asteroid.angle) * asteroidSpeed * dt) % areaHeight
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
                love.graphics.circle('fill', bullet.x, bullet.y, 5)
            end

            for asteroidIndex, asteroid in ipairs(asteroids) do
                love.graphics.setColor(1, 1, 0)
                love.graphics.circle('fill', asteroid.x, asteroid.y, 80)
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

