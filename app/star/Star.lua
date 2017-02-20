--[[
    Star��
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

--ð�ŵ����ÿ��Դ���һ��ʵ�Σ�Ҳ����self���൱��c++��this   
function Star:extend(target)
    local t = tolua.getpeer(target)
    if not t then
       t = {}
       tolua.setpeer(target,t) 
    end
    setmetatable(t,Star)
    return target
end

--����Star����
function Star:createStar(starTable)
    local star = Star:extend(ccui.ImageView:create(starTable.normal))
    star.type = starTable.type
    star.selected = starTable.selected
    star.normal = starTable.normal
    star:setTouchEnabled(true)
    return star
end

--��������
function Star:setStarType(type)
    self.type = type
end

--��ȡ����
function Star:getStarType()
    return self.type
end

--�ı�״̬
function Star:changeStarState()
    if self.isSelected then
        self:loadTexture(self.normal)
        self.isSelected = false
    else
        self:loadTexture(self.selected)
        self.isSelected = true
    end
end

--����ѡ��״̬
function Star:setStateSelected()
        self:loadTexture(self.selected)
        self.isSelected = true
end

--ȡ��ѡ��״̬
function Star:clearStarState()
    self.isSelected = false
    self:loadTexture(self.normal)
end

--���ú������������
function Star:setHorAndVerCoordinate(hor,ver)
    self.hor = hor
    self.ver = ver
end












