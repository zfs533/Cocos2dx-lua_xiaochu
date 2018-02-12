local size = cc.Director:getInstance():getWinSize();
local DragonLayer = class("DragonLayer",function() 
    local layer = cc.Layer:create()
    return layer
end)

function DragonLayer:ctor()
    local bg = cc.Sprite:create("henban/backgrounds/bg_01.png")
    bg:setScale(size.height/bg:getContentSize().height)
    bg:setPosition(size.width/2,size.height/2)
    self:addChild(bg)
    self.bg = bg
    self:initHero()
    self:initYaogan()
    self:drawRode()
end

function DragonLayer:drawRode()
--    local draw = cc.DrawNode:create()
--    local size = cc.Director:getInstance():getWinSize()
--    local rectTable = {
--        {cc.p(0,320),cc.p(570,320)},
--        {cc.p(510,250),cc.p(size.width,250)},
--        {cc.p(size.width-40,320),cc.p(size.width,320)},
--        {cc.p(0,180),cc.p(435,180)},
--        {cc.p(235,45),cc.p(640,45)},
--        {cc.p(645,115),cc.p(780,115)},
--        {cc.p(850,115),cc.p(980,115)},
--    }
--    local index = 7
--    draw:drawSegment(rectTable[index][1],rectTable[index][2],1,cc.c4f(1,1,0,1))
--    draw:setPosition(0,0)
--    self:addChild(draw)
--    print(draw)
--    print("----------------------xixi")
--    self.a = 3
--    self.isJump = false
--    self.originY = self.hero:getPositionY()
--    local scheduler = cc.Director:getInstance():getScheduler() 
--    scheduler:scheduleScriptFunc(function()
--        self:jumpaction()
--    end, 0.03,false)
--    
--    local function jumpEvent(target,state)
--        if state == ccui.TouchEventType.ended then
--            self.a = 22
--            self.isJump = true
--        elseif state == ccui.TouchEventType.began then
--            self.originY = self.hero:getPositionY()
--        end
--    end
--
--    local btn = ccui.Button:create("henban/hero/yaogan/yaokong_1.png","","")
--    btn:setPosition(size.width-100,size.height-100)
--    self:addChild(btn,100)
--    btn:addTouchEventListener(jumpEvent)

end

function DragonLayer:initHero()
    local Hero = import("app.hundragon.Hero")
    local hero = Hero:new()
    hero:setPosition(400,315)
    self:addChild(hero)
    self.hero = hero
end

function DragonLayer:runForword()
    self.hero:runForword()
end

function DragonLayer:runBack()
    self.hero:runBack()
end

function DragonLayer:changeActionTexture(type)
    self.hero:changeActionTexture(type)
end

function DragonLayer:startJump(direction)
    self.hero:startJump(direction)
end

function DragonLayer:initYaogan()
    local YG = import("app.hundragon.Yaogan")
    local yaogan = YG:new()
    self:addChild(yaogan)
    yaogan:setPt(self)
    yaogan:setPosition(yaogan:getContentSize().width/2,yaogan:getContentSize().height/2)
end

return DragonLayer










