local turnSpeed = 10
local shipCircleDistance = 20

function love.load()
    shipX = 800 / 2
    shipY = 600 / 2
    shipAngle = 0
end

function love.update(dt)
    if love.keyboard.isDown('right') then
        shipAngle = shipAngle + turnSpeed * dt
    end
    if love.keyboard.isDown('left') then
        shipAngle = shipAngle - turnSpeed * dt
    end
end

function love.draw()
    love.graphics.setColor(0, 0, 1)
    love.graphics.circle('fill', shipX, shipY, 30)
    love.graphics.setColor(0, 1, 1)
    love.graphics.circle('fill', shipX + math.cos(shipAngle) * shipCircleDistance, shipY + math.sin(shipAngle) * shipCircleDistance, 5)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print('shipAngle: '..shipAngle)

end

