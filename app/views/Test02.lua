-- cc.Director:getInstance().setDisplayStats(cc.Director:getInstance(),false)
local size = cc.Director:getInstance():getVisibleSize()
local Test02 = class("Test02",function() return cc.Scene:create() end)

 function Test02:create()
    local scene = Test02:new()
    scene:addChild(scene:createLayer())
    return scene
end

function Test02:createLayer()

           local layer = cc.Layer:create()

           local label =cc.Label:createWithSystemFont("Hello Lua", "Arial", 32)

           label:setPosition(cc.p(size.width/2,size.height/2))

           layer:addChild(label)

           return layer

end

return CLogonLayer