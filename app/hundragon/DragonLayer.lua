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
    self:initHero()
end

function DragonLayer:initHero()
    local Hero = import("app.hundragon.Hero")
    local hero = Hero:new()
    hero:setPosition(size.width/2,size.height/2)
    self:addChild(hero);
end

return DragonLayer