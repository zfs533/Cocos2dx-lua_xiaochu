local Hero = class("Hero",function() 
    local imgview = cc.Sprite:create()
    return imgview
end)

function Hero:ctor()
    self:initProperty()
    self:initHero()
    local scheduler = cc.Director:getInstance():getScheduler() 
    scheduler:scheduleScriptFunc(function() 
        self:playerHeroAnimate()
    end, 0.2,false)
end

function Hero:initProperty()
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
    self.count = 1
end

function Hero:initHero()
    local rect = cc.rect(0,0,90,100)
    self:initWithFile(self.walk[1],rect)
    self:setTextureRect(self.walkRect01[1])
end

function Hero:playerHeroAnimate()
    self:setTextureRect(self.walkRect01[self.count])
    self.count = self.count + 1
    if self.count > 4 then
        self.count = 1
    end
end

return Hero




