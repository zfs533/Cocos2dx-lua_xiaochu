local size = cc.Director:getInstance():getWinSize()
local GameScene = {}
GameScene.starArr = {}
GameScene.range = 10
GameScene.sameStar = {}

require "app.star.Star" -- 加载Star类
--  创建游戏层
GameScene.createLayer = function()
   local self = GameScene
   local layer = cc.Layer:create()
   self.addBaseUi(layer)
   self.layoutStar(layer,self)
   return layer 
end
--  创建游戏场景
cc.exports.CreateGameScene = function()
    local scene = cc.Scene:create()
    local layer = GameScene.createLayer()
    scene:addChild(layer)
    return scene
end

--  基础ui（背景）
GameScene.addBaseUi = function(layer)
    local mainbacktop = cc.Sprite:create("star/mainbacktop.png")
    mainbacktop:setPosition(cc.p(size.width/2,size.height-mainbacktop:getContentSize().height/2))
    layer:addChild(mainbacktop,1)

    local mainbackbottom = cc.Sprite:create("star/mainbackbottom.png")
    mainbackbottom:setPosition(size.width/2,mainbackbottom:getContentSize().height/2)
    layer:addChild(mainbackbottom)
--    back
    local exitBtnEvent = function(target,state)
        if state == ccui.TouchEventType.ended then
            local scene = CreateWelcomeScene()
            local trans = cc.TransitionFade:create(1,scene)
            cc.Director:getInstance():replaceScene(trans)
        end
    end

    local exitBtn = ccui.Button:create("star/exit.png")
    exitBtn:setPosition(size.width-exitBtn:getContentSize().width/2,size.height-exitBtn:getContentSize().height/2)
    exitBtn:addTouchEventListener(exitBtnEvent)
    layer:addChild(exitBtn,1)
end
--  排列Star
GameScene.layoutStar = function(layer,self)
    local imgRes = {
--        {normal="star/star1d.png",selected="star/star1dwhite.png",type=1},
--        {normal="star/star2d.png",selected="star/star2dwhite.png",type=2},
        {normal="star/star3d.png",selected="star/star3dwhite.png",type=3},
        {normal="star/star4d.png",selected="star/star4dwhite.png",type=4},
        {normal="star/star5d.png",selected="star/star5dwhite.png",type=5},
        }

    local function starEvent(target,state)
        if state == ccui.TouchEventType.ended then
            if target.isSelected and table.getn(self.sameStar)>1 then
               for i = 1,#self.sameStar do
                    local star = self.sameStar[i]
                    self.starArr[star.hor][star.ver] = nil
                    star:removeFromParent()
               end
               self.sameStar = {}
               self:reLayoutStar()
            else
               self:startCheckStar(target)
               print("---------size======= ".. target:getContentSize().width)
            end
        end
    end
    
    local len = table.getn(imgRes)
    for i = 1, self.range do
        self.starArr[i] = {}    --  二维数组
        for j = 1, self.range do 
            local rand = math.floor(math.random(1,len))
            local star = Star:createStar(imgRes[rand]) 
            local sz = star:getContentSize()
            self:runLayoutChunkAction(star,j/5,cc.p(sz.width/2 +sz.width*(i-1),sz.height/2 +sz.height*(j-1)))
            star:setHorAndVerCoordinate(i,j)
            star:addTouchEventListener(starEvent)
            layer:addChild(star)
            self.starArr[i][j] = star   --  二维数组
        end
    end
end

function GameScene:runLayoutChunkAction(target,time,pos)
    local moveTo = cc.MoveTo:create(time,pos)
    target:runAction(moveTo)
end
-- 找到当前Star
function GameScene:startCheckStar(targetStar)
    local tempStar = nil
    for i = 1, self.range do
        for j = 1, self.range do
            local star = self.starArr[i][j]
            if star and star.hor == targetStar.hor and star.ver == targetStar.ver then
                self.sameStar = {}
                self.sameStar[1] = star
                self:checkByDirection(star)
                return
            end
        end
    end
end
-- 从四个方向寻找相同颜色Star
function GameScene:checkByDirection(star)
    local tempArr = self:checkByDirectionFour(star)
    local len01 = #self.sameStar

    for i = 1, self.range do
        for j = 1, self.range do
            local star = self.starArr[i][j]
            if star then 
                star:clearStarState()
            end
        end 
    end
    len01 = #self.sameStar
    for nn = 1,len01 do
        self.sameStar[nn]:changeStarState()
    end
end

--判断两个star类型是否相同
function GameScene:checkStarType(star,tempStar)
    if tempStar and star.type == tempStar.type then
        return tempStar
    end
    return false
end

--从四个方向查找相同类型的star
function GameScene:checkByDirectionFour(star)
    local tempArr = {}
    local tempStar = nil
    local starR = nil
    --    right
    local len = table.getn(tempArr)
    if (star.hor+1) <= self.range then
        local tempStar = self.starArr[star.hor+1][star.ver]
        local starR = self:checkStarType(star,tempStar)
        if starR then
            if not self:jugementIsExist(starR) then
                table.insert(self.sameStar,1,starR)
                self:checkByDirectionFour(starR)
            end
        end
    end
    --    left
    len = table.getn(tempArr)
    if (star.hor-1) >=1 then
        tempStar = self.starArr[star.hor-1][star.ver]
        starR = self:checkStarType(star,tempStar)
        if starR then
            if not self:jugementIsExist(starR) then
                table.insert(self.sameStar,1,starR)
                self:checkByDirectionFour(starR)
            end
        end
    end
    --    up
    len = table.getn(tempArr)
    if (star.ver+1) <= self.range then
        tempStar = self.starArr[star.hor][star.ver+1]
        starR = self:checkStarType(star,tempStar)
        if starR then
            if not self:jugementIsExist(starR) then
                table.insert(self.sameStar,1,starR)
                self:checkByDirectionFour(starR)
            end
        end
    end
    --    down
    len = table.getn(tempArr)
    if (star.ver-1) >= 1 then
        tempStar = self.starArr[star.hor][star.ver-1]
        starR = self:checkStarType(star,tempStar)
        if starR then
            if not self:jugementIsExist(starR) then
                table.insert(self.sameStar,1,starR)
                self:checkByDirectionFour(starR)
            end
        end
    end
    
--    return tempArr
end
--判断sameStar序列里是否已经存在star
function GameScene:jugementIsExist(star)
    local starArr = self.sameStar
    for i = 1,#starArr do
        if star.hor == starArr[i].hor and star.ver == starArr[i].ver and star.type == starArr[i].type then
            return true
        end
    end
    return false
end
--执行消除后重新排列
function GameScene:reLayoutStar()
    for i = 1,self.range do
        for j = 1, self.range do
            local starV = self.starArr[i][j]
            if not starV then
                self:checkVerticalMove(i,j)
                break;
            end
        end
    end
end 
--  交换并向下移动移动
function GameScene:checkVerticalMove(hor,ver)
    local count = 0
    local time = 0.2
    for i = ver,self.range do
        local star = self.starArr[hor][i]
        if not star then
            count = count + 1
        else
            local moveTo = cc.MoveTo:create(time,cc.p(star:getPositionX(),star:getPositionY()-star:getContentSize().height*count))
            star:runAction(moveTo)
            self.starArr[hor][i].ver = self.starArr[hor][i].ver - count
            self.starArr[hor][i-count] = self.starArr[hor][i]
            self.starArr[hor][i] = nil
        end
    end
--    加个定时器以避免水平方向和垂直方向同时移动产生的BUG，定时器仅执行一次
    local    scheduler = cc.Director:getInstance():getScheduler() 
    local mm = nil
    mm = scheduler:scheduleScriptFunc(function() 
        for j = 1,self.range do
            count = 0
            for i = 1,self.range do
                local star = self.starArr[j][i]
                if not star then
                    count = count + 1
                    if count == 10 then -- 整列空缺
                        self:startHorizontalMove(j)
                    end
                end 
            end
        end
        scheduler:unscheduleScriptEntry(mm); 
    end, time, false)
end

--  交换并整列左右移动
function GameScene:startHorizontalMove(hor)
    hor = hor + 1
    local count = 1
    for i = hor,self.range do
        for j = 1,self.range do
            local star = self.starArr[hor][j]
            if star then
                local moveTo = cc.MoveTo:create(0.3,cc.p(star:getPositionX()-star:getContentSize().width*count,star:getPositionY()))
                star:runAction(moveTo)
                self.starArr[hor][j].hor = self.starArr[hor][j].hor - count
                self.starArr[hor-count][j] = self.starArr[hor][j]
                self.starArr[hor][j] = nil
            end
        end
    end
end















