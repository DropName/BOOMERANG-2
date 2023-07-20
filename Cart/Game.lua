game = {}

local function createMetronome()
    return Metronome:new(GAME_BPM)
end

local function createCheckpoints()
    checkpoints = {
        Checkpoint:new(),
        Checkpoint:new(),
    }
    return checkpoints
end

local function createCamera(player)
    local cameraRect = Rect:new(
        CAMERA_WINDOW_START_Y,
        CAMERA_WINDOW_START_X,
        CAMERA_WINDOW_WIDTH,
        CAMERA_WINDOW_HEIGHT
    )

    camera = CameraWindow:new(
        cameraRect,
        player,
        8,
        8
    )
    return camera
end

local function createLevers()
    local levers = {}
    for x = 0, 239 do
        for y = 0, 135 do
            local tileType = gm.getTileId(x, y)
            if table.contains(data.mapConstants.leverIds, tileType) then
                mset(x, y, 0)
                local lwr = Lever:new(x * 8, y * 8)
                
                local doorWiresLever = DoorMechanic.findConnection(x - 1, y - 1) -- подыщем провода и коорды двери
                
                lwr.wires = doorWiresLever.wires
                lwr.door = doorWiresLever.door -- временные координаты, в создании дверей заменится на настоящую дверь

                table.insert(levers, lwr)
            end
        end
    end

    return levers
end

local function createDoors(levers)
    local doors = {}
    for x = 0, 239 do
        for y = 0, 135 do
            local tileType = gm.getTileId(x, y)
            if tileType == data.mapConstants.doorIds[41] then 
                mset(x, y, 0)
                local door = Door:new(x * 8, y * 8)
                table.insert(doors, door)
                
                for i, lever in ipairs(levers) do -- подыскиваем рычаг для двери
                    if lever.door.x == x and lever.door.y == y then
                        lever.door = door
                        break
                    end
                end
                --trace('cannot find lever for door((((((((((((((((((((')
            end
        end
    end
    return doors
end

local function createEnemies()
    local enemem = {}

    for x = 0, MAP_WIDTH do
        for y = 0, MAP_HEIGHT do
            if mget(x, y) == data.Enemy.defaultEnemyFlagTile then
                mset(x, y, C0)
                local enemy = Enemy:new(x * 8, y * 8)
                table.insert(enemem, enemy)
            end
        end
    end

    return enemem
end

local function createBoomerang()
    return Boomerang:new(PLAYER_START_X, PLAYER_START_Y, 0, 0)
end

local function createPlayer(boomerang)
    return Player:new(PLAYER_START_X, PLAYER_START_Y, boomerang)
end

local function createBullets()
    bullets = {
    }
    return bullets
end

game.drawables = {}
game.updatables = {}

local metronome = createMetronome()
local checkpoints = createCheckpoints()
local levers = createLevers()
local doors = createDoors(levers)
local enemies = createEnemies()
local boomerang = createBoomerang()
local player = createPlayer(boomerang)
local camera = createCamera(player)
local bullets = createBullets()

table.insert(game.updatables, metronome)
table.concatTable(game.updatables, checkpoints)
table.insert(game.updatables, player)
table.insert(game.updatables, camera)
table.insert(game.updatables, boomerang)
table.concatTable(game.updatables, enemies)
table.concatTable(game.updatables, levers)
table.concatTable(game.updatables, doors)
table.concatTable(game.updatables, bullets)

table.concatTable(game.drawables, checkpoints)
table.concatTable(game.drawables, levers)
table.concatTable(game.drawables, enemies)
table.insert(game.drawables, player)
table.insert(game.drawables, boomerang)
table.concatTable(game.drawables, bullets)
table.concatTable(game.drawables, doors)

game.mode = 'action' -- Зачем это? :|
game.metronome = metronome
game.player = player
game.boomer = boomerang
game.camera = camera

function game.draw()
    map(gm.x, gm.y , 30, 17, gm.sx, gm.sy, C0)

    for _, drawable in ipairs(game.drawables) do
        drawable:draw()
    end
end

function game.update()
    for _, updatable in ipairs(game.updatables) do
        updatable:update()
    end

    Time.update()

    game.draw()
end

return game
