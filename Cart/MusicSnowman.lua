MusicSnowman = table.copy(Snowman)

-- И Сноумен ⛄ говорит:
-- ноль ноль один один один ноль
function MusicSnowman:tuning(beatMap, sfxMap)
    self.sfxMap = sfxMap
    self.sfxMapIndex = 1
    self.beatMap = beatMap
    self.beatMapIndex = 1
end

function MusicSnowman:update()
    if (#self.beatMap == 4 and game.metronome.beat4) or
       (#self.beatMap == 6 and game.metronome.beat6) or
       (#self.beatMap == 8 and game.metronome.beat8) then

       self.beatMapIndex = (self.beatMapIndex % #self.beatMap) + 1

       if (self.beatMap[self.beatMapIndex] ~= 0) then
           --- АХХАХАХАХ ДУббяж кода 😜😋😱🤪🤪🤪
            self.whirlAttack = SnowmanWhirlAttack:new(self.hitbox:get_center().x, self.hitbox:get_center().y, self.taraxacum.h)
            self.whirlAttack.snowman = self
            self.attackStatus = 'whirl'
            self.speed = self.config.speedWithWhirl

           local sound = self.sfxMap[self.sfxMapIndex]
           sfx(sound[1], sound[2], sound[3], sound[4], sound[5], sound[6])

           self:_setPath()
           self.sfxMapIndex = (self.sfxMapIndex % #self.sfxMap) + 1
           self:_moveOneTile()
       else
           self.speed = self.config.speed
           self.attackStatus = 'idle'
           if self.whirlAttack then
               self.whirlAttack:endAttack()
               self.whirlAttack = nil -- Чтобы жесткие ошибки 😱😱😷
           end
       end
    end

    self:_focusAnimations()

    if self.attackStatus == 'whirl' then
        self.whirlAttack:update()
        self.sprite = self.config.sprites.chill:copy()
        if self.theWay then
            self:_moveOneTile()
        end
    end

    if game.boomer.hitbox:collide(self.hitbox) then
        local damage = game.boomer.dpMs * Time.dt()
        self:takeDamage(damage)

        if self:isDeadCheck() then
            self.sprite = self.config.sprites.death:copy()
            return
        end
    end

    if self:isDeadCheck() then
        self.sprite:nextFrame()
        if self.sprite:animationEnd() then
            self:_createDeathEffect()
            self:die()
        end
        return
    end
end
