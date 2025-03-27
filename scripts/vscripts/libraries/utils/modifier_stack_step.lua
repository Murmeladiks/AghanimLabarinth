require("libraries/data_structure/queue")
modifier_stack_step = modifier_stack_step or class( {} )
-- params
-- step
-- stacks
function modifier_stack_step:OnCreated(kv)
    self:OnFirstApply(kv)
    self:OnUpDate(kv)
    if IsServer() then
        self.stack_manager = {}
        self.stack_manager.queue = Queue.new()
        self.stack_manager.time = GameRules:GetGameTime()
        self.stack_manager.stacks = 0
        self.stack_manager.temp_stacks = 0
        self.stack_manager.max_stacks = kv.max_stacks or -1
        self:IncreaseTemporaryStacks(kv.stacks)
        self:StartIntervalThink(kv.step or 0.5)
    end
end
function modifier_stack_step:OnRefresh(kv)
    self:OnUpDate(kv)
    if IsServer() then
        if kv.max_stacks then
            self.stack_manager.max_stacks = kv.max_stacks
        end
        self:IncreaseTemporaryStacks(kv.stacks or 0)
    end
end
function modifier_stack_step:IsOverMaxStack(bEqual)
    if bEqual then
        return self.stack_manager.max_stacks <= self.stack_manager.stacks
    end
    return self.stack_manager.max_stacks < self.stack_manager.stacks
end
function modifier_stack_step:OnFirstApply(kv)
end
function modifier_stack_step:OnUpDate(kv)
end
function modifier_stack_step:OnTick()
end
function modifier_stack_step:RefreshAllStacks()
    self.stack_manager.queue = Queue.new()
    self.stack_manager.temp_stacks = self.stack_manager.stacks
    Queue.pushBack(self.stack_manager.queue, {GameRules:GetGameTime(), self.stack_manager.temp_stacks})
    self.stack_manager.temp_stacks = 0
end
function modifier_stack_step:IncreaseTemporaryStacks(iStack)
    if self.stack_manager then
        self.stack_manager.stacks = self.stack_manager.stacks + iStack
        self.stack_manager.temp_stacks = self.stack_manager.temp_stacks + iStack
        if self.stack_manager.max_stacks > 0 then
            self:SetStackCount(math.min(self.stack_manager.max_stacks, self.stack_manager.stacks))
        else
            self:SetStackCount(self.stack_manager.stacks)
        end
    end
end
function modifier_stack_step:OnIntervalThink()
    if IsServer() then
        local new_time = GameRules:GetGameTime()
        if Queue.empty(self.stack_manager.queue) then
        else
            local bContinue = true
            while not Queue.empty(self.stack_manager.queue) and bContinue do
                local front = Queue.peekFront(self.stack_manager.queue)
                if front[1] + self:GetDuration() < new_time then
                    self.stack_manager.stacks = self.stack_manager.stacks - front[2]
                    Queue.popFront(self.stack_manager.queue)
                else
                    bContinue = false
                end
            end
            if self.stack_manager.max_stacks > 0 then
                self:SetStackCount(math.min(self.stack_manager.max_stacks, self.stack_manager.stacks))
            else
                self:SetStackCount(self.stack_manager.stacks)
            end
        end
        if self.stack_manager.temp_stacks ~= 0 then
            Queue.pushBack(self.stack_manager.queue, {self.stack_manager.time, self.stack_manager.temp_stacks})
            self.stack_manager.temp_stacks = 0
        end
        self.stack_manager.time = new_time
    end
    self:OnTick()
end
