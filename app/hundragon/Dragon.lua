local Dragon = class("Dragon",function()
    local scene = cc.Scene:create()
    return scene
end)

function Dragon:ctor()
    local dragonLayer = import("app.hundragon.DragonLayer")
    local layer = dragonLayer:new()
    print("123456789-----------------");
    self:addChild(layer)
end
return Dragon