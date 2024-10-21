---@class BreakEffect : Object
---@overload fun(...) : BreakEffect
local BreakEffect, super = Class(Object)

function BreakEffect:init(texture, x, y, after)
    super.init(self, x, y)

    if type(texture) == "string" then
        texture = Assets.getTexture(texture) or (Assets.getFrames(texture)[1])
    end
    self.texture = texture

    self.start_alpha = 1
    self.alpha_timer = 0

    self.done = false
    self.after_func = after

    self.width, self.height = texture:getWidth(), texture:getHeight()
    self.block_size = self.width / 2
    self.blocks_x = math.ceil(self.width/self.block_size)
    self.blocks_y = math.ceil(self.height/self.block_size)
    self.blocks = {}
    for i = 0, self.blocks_x do
        self.blocks[i] = {}
        for j = 0, self.blocks_y do
            local block = {}

            local qx = (i * self.block_size)
            local qy = (j * self.block_size)
            local qw = Utils.clamp(self.block_size, 0, self.width - qx)
            local qh = Utils.clamp(self.block_size, 0, self.height - qy)

            block.quad = love.graphics.newQuad(qx, qy, qw, qh, self.width, self.height)

            block.x = (i * self.block_size)
            block.y = (j * self.block_size)
            block.speed = 0
            block.delay = (4 + (j * 3)) - i

            self.blocks[i][j] = block
        end
    end
end

function BreakEffect:onAdd(parent)
    super.onAdd(self, parent)

    self.start_alpha = self.alpha
end

function BreakEffect:update()
    self.alpha_timer = self.alpha_timer + DTMULT
    self.alpha = Utils.lerp(self.start_alpha, 0, self.alpha_timer / 10)

    for i = 0, self.blocks_x do
        for j = 0, self.blocks_y do
            local block = self.blocks[i][j]
            if block.delay <= 0 then
                block.speed = block.speed + DTMULT
            end
            block.x = block.x + ((i * 2)-1) * DTMULT
            block.y = block.y + ((j * 2)-1) * DTMULT
            block.delay = block.delay - DTMULT
        end
    end

    if self.blocks[0][self.blocks_y].speed >= 12 then
        self.done = true
        if self.after_func then
            self.after_func()
        end
        self:remove()
    end

    super.update(self)
end

function BreakEffect:draw()
    local r, g, b, a = self:getDrawColor()

    for i = 0, self.blocks_x do
        for j = 0, self.blocks_y do
            local block = self.blocks[i][j]
            Draw.setColor(r, g, b, a)
            Draw.draw(self.texture, block.quad, block.x, block.y)
        end
    end

    super.draw(self)
end

function BreakEffect:copyAppearance(other)
    self.origin_x = other.origin_x
    self.origin_y = other.origin_y
    self.flip_x = other.sprite.flip_x ~= other.flip_x
    self.flip_y = other.sprite.flip_y ~= other.flip_y
    if self.flip_x then self.origin_x = -self.origin_x end
    if self.flip_y then self.origin_y = -self.origin_y end
    self.color = other.color
    self.layer = other.layer
end

return BreakEffect