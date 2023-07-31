HitCircle = table.copy(Hitbox)


function HitCircle:new(x, y, d)
    obj = {
        x = x, y = y,  -- left top pixel
        d = d,  -- diameter
        hb = Hitbox:new(x, y, x+d, y+d),  -- для упрощения расчетов
        type = 'hitcircle',
    }
    -- чистая магия!
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function HitCircle:collide(hb)
    if not self.hb:collide(hb) then
        return false
    end
    local d = self.d
    -- is center in hb
    if hb.x1 <= self.x + d/2 and self.x + d/2 <= hb.x2 and
            hb.y1 <= self.y + d/2 and self.y + d/2 <= hb.y2 then
        return true
    end
    -- is hb side collide circle
    if math.sq_point_ortsegment_distance(self.x + d/2, self.y + d/2, hb.x1, hb.y1, hb.x1, hb.y2) <= d^2 / 4 then
        return true
    end
    if math.sq_point_ortsegment_distance(self.x + d/2, self.y + d/2, hb.x2, hb.y1, hb.x2, hb.y2) <= d^2 / 4 then
        return true
    end
    if math.sq_point_ortsegment_distance(self.x + d/2, self.y + d/2, hb.x1, hb.y1, hb.x2, hb.y1) <= d^2 / 4 then
        return true
    end
    if math.sq_point_ortsegment_distance(self.x + d/2, self.y + d/2, hb.x1, hb.y2, hb.x2, hb.y2) <= d^2 / 4 then
        return true
    end
    return false
end

function HitCircle:set_xy(x, y)
    self.x = x
    self.y = y
    self.hb:set_xy(x, y)
end

function HitCircle:draw(color)
    circ(self.x + 2 - 8*gm.x + gm.sx, self.y + 2 - 8*gm.y + gm.sy, (self.d/2), color)
end

function HitCircle:get_center()
    local x1 = self.x
    local x2 = self.x + self.d
    local y1 = self.y
    local y2 = self.y + self.d
    return {
        x = x1 + (x2 - x1) / 2,
        y = y1 + (y2 - y1) / 2
    }
end

function HitCircle:getWidth()
    return self.d
end

function HitCircle:getHeight()
    return self.d
end

return HitCircle
