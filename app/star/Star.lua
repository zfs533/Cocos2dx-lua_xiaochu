--[[
    Star类
]]
cc.exports.Star = class("Star")
Star.__index = Star
Star.type = nil
Star.selected = nil
Star.isSelected = false
Star.normal = nil
Star.hor = nil
Star.ver = nil
Star.moveYY = 0

--冒号的作用可以传递一个实参，也就是self，相当于c++的this   
function Star:extend(target)
    local t = tolua.getpeer(target)
    if not t then
       t = {}
       tolua.setpeer(target,t) 
    end
    setmetatable(t,Star)
    return target
end

--创建Star对象
function Star:createStar(starTable)
    local star = Star:extend(ccui.ImageView:create(starTable.normal))
    star.type = starTable.type
    star.selected = starTable.selected
    star.normal = starTable.normal
    star:setTouchEnabled(true)
    return star
end

--设置类型
function Star:setStarType(type)
    self.type = type
end

--获取类型
function Star:getStarType()
    return self.type
end

--改变状态
function Star:changeStarState()
    if self.isSelected then
        self:loadTexture(self.normal)
        self.isSelected = false
    else
        self:loadTexture(self.selected)
        self.isSelected = true
    end
end

--设置选中状态
function Star:setStateSelected()
        self:loadTexture(self.selected)
        self.isSelected = true
end

--取消选中状态
function Star:clearStarState()
    self.isSelected = false
    self:loadTexture(self.normal)
end

--设置横向和纵向坐标
function Star:setHorAndVerCoordinate(hor,ver)
    self.hor = hor
    self.ver = ver
end












