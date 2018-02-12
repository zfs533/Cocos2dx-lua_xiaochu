local Hero = class("Hero",function() 
    local imgview = cc.Sprite:create()
    return imgview
end)

function Hero:ctor()
    self:setAnchorPoint(0.5,0)
    self:initProperty()
    self:initHero()
    local scheduler = cc.Director:getInstance():getScheduler() 
    scheduler:scheduleScriptFunc(function() 
        self:playerHeroAnimate()
    end, 0.15,false)
    scheduler:scheduleScriptFunc(function()
        self:jumpaction()
        self:handleGravity()
        self:handleOutLining()
    end, 0.03,false)
end

function Hero:initProperty()
    self.isRun = false
    self.isJump = false
    self.isDown = false
    self.isJumping = false
    self.isOutLining = false
    self.actionType = {0,1,2,3} --0水平，1跳，2爬,3站
    self.a = 2
    self.originY = self:getPositionY()
    self.direction = 1
    self.tempType = -1
    self.posIndex = 1
    self.stand = {"henban/hero/stand2.png"}
    self.walk = {
        "henban/hero/walkandshot1.png",
        "henban/hero/walkandshot2.png",
        "henban/hero/walkandshot3.png",
        "henban/hero/walkandshot5.png",
        "henban/hero/walkandshot6.png",
        "henban/hero/walkandshot7.png",
    }
    self.walkRect01 = {
        cc.rect(0,0,90,100),
        cc.rect(90,0,90,100),
        cc.rect(180,0,90,100),
        cc.rect(270,0,90,100),
    }
    self.down = {"henban/hero/crawl2.png"}
    local gap = 66
    self.jump = {"henban/hero/jump2.png"}
    self.jumpRect = {
        cc.rect(0,0,gap,gap),
        cc.rect(gap,0,gap,gap),
        cc.rect(gap*2,0,gap,gap),
        cc.rect(gap*3,0,gap,gap),
        cc.rect(gap*4,0,gap,gap),
        cc.rect(gap*5,0,gap,gap),
    }
    self.count = 1
    self.speed = 3
    local size = cc.Director:getInstance():getWinSize()
    local rectTable = {
        {cc.p(235,45),cc.p(640,45)},
        {cc.p(645,115),cc.p(780,115)},
        {cc.p(850,115),cc.p(980,115)},
        {cc.p(0,180),cc.p(435,180)},
        {cc.p(510,250),cc.p(size.width,250)},
        {cc.p(0,315),cc.p(570,315)},
        {cc.p(size.width-40,315),cc.p(size.width,315)},
    }
    self.rectTable = rectTable
end

function Hero:initHero()
    self:changeActionTexture(self.actionType[4])
end

function Hero:playerHeroAnimate()
    if self.isRun then
        self:setTextureRect(self.walkRect01[self.count])
        self.count = self.count + 1
        if self.count > #self.walkRect01 then
            self.count = 1
        end
    elseif self.isJump then
        self:setTextureRect(self.jumpRect[self.count])
        self.count = self.count + 1
        if self.count > #self.jumpRect then
            self.count = 1
        end
    end
end
--只在不在x范围和跳起时检查
function Hero:handleGravity()
    if self.isJumping and self.a <= 0 then
        local tb = self.rectTable
        for i = 1, (#tb-0) do
            if self:getPositionY() >= tb[i][1].y-5 and self:getPositionY() <= tb[i][1].y+5 and self:checkPosX(i) then
                    self.isJumping = false
                    self:setPositionY(tb[i][1].y)
                    self:changeActionTexture(self.actionType[4])
                    break
            end
        end
    elseif not self.isJumping then
        local tb = self.rectTable
        for i = 1, (#tb-0) do
            if self:getPositionY() >= tb[i][1].y-5 and self:getPositionY() <= tb[i][1].y+5 then
                self:checkPosX(i)
                break
            end
        end
    end
end

function Hero:handleOutLining()
    if self.isOutLining then
        self:runJumpAction()
        local tb = self.rectTable
        for i = 1, (#tb-0) do
            if self:getPositionY() >= tb[i][1].y-5 and self:getPositionY() <= tb[i][1].y+5 and self:checkPosX(i) then
                self.isJumping = false
                self:setPositionY(tb[i][1].y)
                self:changeActionTexture(self.actionType[4])
                break
            end
        end
    end
end

function Hero:checkPosX(index,bool)
    local tb = self.rectTable
    if bool then
        local xx = self:getPositionX()
        if xx >= tb[index][1].x and xx <= tb[index][2].x then
            self.isOutLining = false
            return true
        end
        self.isOutLining = true
        return false
    end
    if index == 2 or index == 3 then
        local xx = self:getPositionX()
        if xx >= tb[2][1].x and xx <= tb[2][2].x then
            self.isOutLining = false
            return true
        end
        local xx = self:getPositionX()
        if xx >= tb[3][1].x and xx <= tb[3][2].x then
            self.isOutLining = false
            return true
        end
    elseif index == 6 or index == 7 then
        local xx = self:getPositionX()
        if xx >= tb[6][1].x and xx <= tb[6][2].x then
            self.isOutLining = false
            return true
        end
        local xx = self:getPositionX()
        if xx >= tb[7][1].x and xx <= tb[7][2].x then
            self.isOutLining = false
            return true
        end
    else
        local xx = self:getPositionX()
        if xx >= tb[index][1].x and xx <= tb[index][2].x then
            self.isOutLining = false
            return true
        end
    end
    self.isOutLining = true
    return false
end

function Hero:changeActionTexture(type)
    if self.isJumping then return end
    if type == self.tempType then return end
    if type == self.actionType[1] then
        local rect = cc.rect(0,0,90,100)
        self:initWithFile(self.walk[1],rect)
        self.isRun = true
        self.isJump = false
        self.isDown = false
    elseif type == self.actionType[2] then
        local rect = cc.rect(0,0,66,66)
        self:initWithFile(self.jump[1],rect)
        self:setTextureRect(self.jumpRect[1])
        self.isJump = true
        self.isRun = false
        self.isDown = false
    elseif type == self.actionType[3] then
        self:initWithFile(self.down[1])
        self.isDown = true
        self.isRun = false
        self.isJump = false
    elseif type == self.actionType[4] then
        self:initWithFile(self.stand[1])
        self.isDown = false
        self.isRun = false
        self.isJump = false
        self:setPosIndex()
        self.a = 0
    end
    self:setAnchorPoint(0.5,0)
    self.count = 1
    self.tempType = type
end

function Hero:runForword()
    if self.isJumping then return end
    if self.isRun then
        local posX = self:getPositionX() + self.speed
        self:setPositionX(posX)
        self:setScaleX(1)
        self.direction = 1
    end
end

function Hero:runBack()
    if self.isJumping then return end
    if self.isRun then
        local posX = self:getPositionX() - self.speed
        self:setPositionX(posX)
        self:setScaleX(-1)
        self.direction = -1
    end
end

function Hero:jumpaction()
    if self.isJumping then
        self:runJumpAction()
        local index = self.posIndex
        if index then
            if self:getPositionY() <= self.originY and self:checkPosX(index,true) then
                self:setPositionY(self.originY)
                self.isJumping = false
                self:changeActionTexture(self.actionType[4])
            end
        end
    end
end

function Hero:runJumpAction()
    local gap = 0
    if self.direction > 0 then
        gap = 5
    elseif self.direction < 0 then
        gap = -5
    end
    local xx = self:getPositionX() + gap
    self.a = self.a - 1
    local yy = self:getPositionY()+self.a
    self:setPosition(xx,yy)
end

function Hero:getPosIndex()
    local tb = self.rectTable
    for i = 1, (#tb-0) do
        if self:getPositionY() >= tb[i][1].y-5 and self:getPositionY() <= tb[i][1].y+5 then
            return i
        end
    end
end

function Hero:setPosIndex()
    local tb = self.rectTable
    for i = 1, #tb do
        if self:getPositionY() == tb[i][1].y then
            if self:getPositionX() >= tb[i][1].x and self:getPositionX() <= tb[i][2].x then
                self.posIndex = i
                break
            end
        end
    end
end

function Hero:startJump(direction)
    if not self.isJumping then
        self.a = 16
        self.originY = self:getPositionY()
        self:setPosIndex()
    end
    self.isJumping = true
    self.direction = direction
end

return Hero

























