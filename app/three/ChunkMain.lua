local size = cc.Director:getInstance():getWinSize()
local ChunkMain = {}
ChunkMain.rangeVer = 9
ChunkMain.rangeHor = 6
ChunkMain.chunkArr = {}
ChunkMain.firstChunk = nil --第一次选中的Chunk
ChunkMain.secoundChunk = nil --第二次选中的Chunk
ChunkMain.actionTime = 0.3
ChunkMain.imgRes = nil
ChunkMain.layer = nil
--[[----------------------------------------------------------------]]
function cc.exports.ChunkMainCreateScene()
    local scene = cc.Scene:create()
    local layer = cc.Layer:create()
    scene:addChild(layer)
    ChunkMain.layer = layer
    ChunkMain:initLayer(layer)
    cc.Director:getInstance():setDisplayStats(false)
    return scene
end
--[[----------------------------------------------------------------]]
function ChunkMain:initLayer(layer)
    local sp = cc.Sprite:create("star/newgame.png")
    layer:addChild(sp)
    self:layoutChunk(layer)
    self:addBaseUi(layer)
end
--  初始化UI
function ChunkMain:addBaseUi(layer)
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
    layer:addChild(exitBtn,10)
end

function ChunkMain:chunkTouchEvent(target,state)
    if state == ccui.TouchEventType.ended then
        self:handleSelectedChunk(target)
    end
end
--  排列chunk
function ChunkMain:layoutChunk(layer)
    local imgRes = {
        {normal="three/00.png",selected="three/000.png",type=1},
        {normal="three/01.png",selected="three/001.png",type=2},
        {normal="three/02.png",selected="three/002.png",type=3},
        {normal="three/03.png",selected="three/003.png",type=4},
        {normal="three/04.png",selected="three/004.png",type=5},
        {normal="three/05.png",selected="three/005.png",type=6},
        {normal="three/06.png",selected="three/006.png",type=7},
        {normal="three/07.png",selected="three/007.png",type=8},
    }
    self.imgRes = imgRes
--    local chunkTouchEvent = function(target,state)
--        if state == ccui.TouchEventType.ended then
--            self:handleSelectedChunk(target)
--        end
--    end
    
    
    for i = 1, self.rangeHor do
        self.chunkArr[i] = {}
        for j = 1, self.rangeVer do
            local random = math.floor(math.random(1,#imgRes))
            local chunk = Star:createStar(imgRes[random])
            local sz = chunk:getContentSize()
            self:runLayoutChunkAction(chunk,j/5,cc.p(sz.width/2 + sz.width*(i-1),sz.height/2+sz.height*(j-1)))
            chunk:setHorAndVerCoordinate(i,j)
            chunk:addTouchEventListener(function(target,state) self:chunkTouchEvent(target,state) end)
            layer:addChild(chunk,5)
            self.chunkArr[i][j] = chunk
        end
    end
end
--  初始化排列动作
function ChunkMain:runLayoutChunkAction(target,time,pos)
    local moveTo = cc.MoveTo:create(time,pos)
    target:runAction(moveTo)
end
--  选中chunk逻辑
function ChunkMain:handleSelectedChunk(target)
    if not ChunkMain.firstChunk then
        ChunkMain.firstChunk = target
        target:setStateSelected()
    elseif ChunkMain.firstChunk and not ChunkMain.secoundChunk then
        if ChunkMain.firstChunk.hor == target.hor and ChunkMain.firstChunk.ver == target.ver then --两次选中同一个chunk,则取消选择
            target:clearStarState()
            ChunkMain.firstChunk = nil
        else
            target:setStateSelected()
            ChunkMain.secoundChunk = target
        end
        if ChunkMain.firstChunk and ChunkMain.secoundChunk then
            self:startChangeAction()
        end
    elseif ChunkMain.firstChunk and ChunkMain.secoundChunk then
        ChunkMain.firstChunk:clearStarState()
        ChunkMain.secoundChunk:clearStarState()
        target:setStateSelected()
        ChunkMain.firstChunk = target
        ChunkMain.secoundChunk = nil
    end
end
--  开始交换
function ChunkMain:startChangeAction()
    local isCanMove = self:jugementMove()
    if isCanMove then
        local chunk01 = ChunkMain.firstChunk 
        local chunk02 = ChunkMain.secoundChunk 
        local sz = chunk01:getContentSize()
        local time = 0.3
        local pos01 = cc.p(0,0)
        local pos02 = cc.p(0,0)
        local isHor = false
        local isAdd = false
        if chunk01.hor == chunk02.hor then 
            isHor = false
            if chunk01.ver > chunk02.ver then
                isAdd = false
                pos01 = cc.p(chunk01.hor*sz.width-sz.width/2,(chunk01.ver-1)*sz.height-sz.height/2)
                pos02 = cc.p(chunk02.hor*sz.width-sz.width/2,(chunk02.ver+1)*sz.height-sz.height/2)
            else
                isAdd = true
                pos01 = cc.p(chunk01.hor*sz.width-sz.width/2,(chunk01.ver+1)*sz.height-sz.height/2)
                pos02 = cc.p(chunk02.hor*sz.width-sz.width/2,(chunk02.ver-1)*sz.height-sz.height/2)
            end
        end
        if chunk01.ver == chunk02.ver then 
            isHor = true
            if chunk01.hor > chunk02.hor then
                isAdd = false
                pos01 = cc.p((chunk01.hor-1)*sz.width-sz.width/2,chunk01.ver*sz.height-sz.height/2)
                pos02 = cc.p((chunk02.hor+1)*sz.width-sz.width/2,chunk02.ver*sz.height-sz.height/2)
            else
                isAdd = true
                pos01 = cc.p((chunk01.hor+1)*sz.width-sz.width/2,chunk01.ver*sz.height-sz.height/2)
                pos02 = cc.p((chunk02.hor-1)*sz.width-sz.width/2,chunk02.ver*sz.height-sz.height/2)
            end
        end
        self:playAction(chunk01,chunk02,pos01,pos02,isHor,isAdd)
    end
end
--  播放移动交换动作
function ChunkMain:playAction(chunk01,chunk02,pos01,pos02,isHor,isAdd)
    local time = self.actionTime
    local moveTo01 = cc.MoveTo:create(time,pos01)
    local moveTo02 = cc.MoveTo:create(time,pos02)
    local elastic01 = cc.EaseBackOut:create(moveTo01);
    local elastic02 = cc.EaseBackOut:create(moveTo02);
    local callback = cc.CallFunc:create(function() self:startCheckChunk() end)
    local sequence = cc.Sequence:create(elastic01,callback)
    chunk01:runAction(sequence)
    chunk02:runAction(elastic02)
    local temp = self.chunkArr[chunk01.hor][chunk01.ver]
    self.chunkArr[chunk01.hor][chunk01.ver] = self.chunkArr[chunk02.hor][chunk02.ver]
    self.chunkArr[chunk02.hor][chunk02.ver] = temp
    if isHor then
        if isAdd then
            chunk01.hor = chunk01.hor + 1
            chunk02.hor = chunk02.hor - 1
        else
            chunk01.hor = chunk01.hor - 1
            chunk02.hor = chunk02.hor + 1
        end
    else
        if isAdd then
            chunk01.ver = chunk01.ver + 1
            chunk02.ver = chunk02.ver - 1
        else
            chunk01.ver = chunk01.ver - 1
            chunk02.ver = chunk02.ver + 1
        end
    end
end
--  判断当前选中的两个chunk是否可以移动
function ChunkMain:jugementMove()
    local chunk01 = ChunkMain.firstChunk 
    local chunk02 = ChunkMain.secoundChunk 
    if chunk01.hor == chunk02.hor then 
        if math.abs(chunk01.ver - chunk02.ver) ~= 1 then 
            return false
        end
    end
    if chunk01.ver == chunk02.ver then 
        if math.abs(chunk01.hor - chunk02.hor) ~= 1 then
            return false
        end
    end
    if chunk01.ver ~= chunk02.ver and chunk01.hor ~= chunk02.hor then
        return false
    end 
    return true
end
--  开始检测
function ChunkMain:startCheckChunk()
    local chunk01 = ChunkMain.firstChunk 
    local chunk02 = ChunkMain.secoundChunk 
    chunk01:clearStarState()
    chunk02:clearStarState()
    ChunkMain.firstChunk = nil
    ChunkMain.secoundChunk = nil
    self:checkAllChunk()
end
--  检测所有chunk，将满足条件的chunk赛选出来
function ChunkMain:checkAllChunk()
    -- 垂直方向检查
    local sameChunkArr = {}
    for i = 1, self.rangeHor do
        local tempArr = {}
        for j = 1, self.rangeVer-2 do
            local chunk01 = self.chunkArr[i][j]
            local chunk02 = self.chunkArr[i][j+1]
            local chunk03 = self.chunkArr[i][j+2]
            if chunk01.type == chunk02.type and chunk01.type == chunk03.type then
                table.insert(tempArr,1,chunk01)    -- 这里要单独存一个table
                table.insert(tempArr,1,chunk02)
                table.insert(tempArr,1,chunk03)
                table.insert(sameChunkArr,1,tempArr)
            end
        end
    end
    -- 水平方向检查
    for j = 1, self.rangeVer do
        local tempArr = {}
        for i = 1, self.rangeHor-2 do
            local chunk01 = self.chunkArr[i][j]
            local chunk02 = self.chunkArr[i+1][j]
            local chunk03 = self.chunkArr[i+2][j]
            if chunk01.type == chunk02.type and chunk01.type == chunk03.type then
                table.insert(tempArr,1,chunk01)    -- 这里要单独存一个table
                table.insert(tempArr,1,chunk02)
                table.insert(tempArr,1,chunk03)
                table.insert(sameChunkArr,1,tempArr)
            end
        end
    end
    local chunkArr = {}
    for i = 1, table.getn(sameChunkArr) do
        local tempChunk = sameChunkArr[i]
        for j = 1, table.getn(tempChunk) do
            table.insert(chunkArr,1,tempChunk[j])
        end
    end
    self:distoryChunk(chunkArr)
end

function ChunkMain:distoryChunk(chunkArr)
    local resultArr = self:pickStarTable(chunkArr)
    local len = table.getn(resultArr)
    for i = 1,len do
        resultArr[i]:setStateSelected()
        local chunk = resultArr[i];
        self.chunkArr[chunk.hor][chunk.ver] = nil
        chunk:removeFromParent()
    end
    self:reLayoutChunk()
end
--去掉重复的项
function ChunkMain:pickStarTable(tab)
    local mm = tab
    for i = 1,table.getn(mm)-1 do
        for j = i+1,table.getn(mm) do
            if mm[i].hor == mm[j].hor and mm[i].ver == mm[j].ver then
                table.remove(mm,j)
                self:pickStarTable(mm)
                break
            end
        end
    end
    return tab
end
--执行消除后重新排列
function ChunkMain:reLayoutChunk()
    for i = 1,self.rangeHor do
        for j = 1, self.rangeVer do
            local chunkV = self.chunkArr[i][j]
            if not chunkV then
                self:checkVerticalMove(i,j)
                break;
            end
        end
    end
end 
--  交换并向下移动移动
function ChunkMain:checkVerticalMove(hor,ver)
    local count = 0
    local time = self.actionTime
    for i = ver,self.rangeVer do
        local chunk = self.chunkArr[hor][i]
        print("count= "..count)
        if not chunk then
            count = count + 1
--            local random = math.floor(math.random(1,#self.imgRes))
--            local chunk = Star:createStar(self.imgRes[random])
--            local sz = chunk:getContentSize()
--            self:runLayoutChunkAction(chunk,time,cc.p(sz.width/2 + sz.width*(hor-1),sz.height/2+sz.height*(self.rangeVer-1+count)))
--            chunk:setHorAndVerCoordinate(hor,self.rangeVer-1+count)
--            chunk:addTouchEventListener(function(target,state) self:chunkTouchEvent(target,state) end)
--            self.layer:addChild(chunk,5)
--            self.chunkArr[hor][self.rangeVer-1+count] = chunk
        else
            local moveTo = cc.MoveTo:create(time,cc.p(chunk:getPositionX(),chunk:getPositionY()-chunk:getContentSize().height*count))
            local elastic01 = cc.EaseBackOut:create(moveTo);
            chunk:runAction(elastic01)
            self.chunkArr[hor][i].ver = self.chunkArr[hor][i].ver - count
            self.chunkArr[hor][i-count] = self.chunkArr[hor][i]
            self.chunkArr[hor][i] = nil
        end
    end
end




function ChunkMain:checkVertical()

end

function ChunkMain:checkHorizontal()

end








