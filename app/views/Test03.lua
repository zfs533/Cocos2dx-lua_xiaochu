--
--local FruitItem = class("FruitItem",function(x,y,index)
--    index = fruitIndex or math.round(math.random()*1000)%8 + 1
--    local sprite = cc.Sprite:create("res/HelloWorld.png")
--    sprite:setPosition(x,y)
--    return sprite;
--end)
--
--function FruitItem:ctor()
--end
--return FruitItem


local FruitItem = class("FruitItem")

function FruitItem:ctor(x,y,index,parent)
    print(x,y,index)
    local sprite = cc.Sprite:create("HelloWorld.png")
    sprite:setPosition(x,y)
--    cc.Director:getInstance():getRunningScene():addChild(sprite) 
    parent:addChild(sprite,1)  
end

return FruitItem