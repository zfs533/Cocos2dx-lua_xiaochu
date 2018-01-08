local Shudu = class("Shudu",function()
    local scene = cc.Scene:create()
    return scene 
end)

function Shudu:ctor()
    local shuduLayer = import("app.shudu.ShuduLayer")
    local layer = shuduLayer:new();
    self:addChild(layer)
end
return Shudu
