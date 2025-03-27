mars_bulwark_retort = class( {} )


--------------------------------------------------------------------------------
LinkLuaModifier( "modifier_mars_bulwark_retort", "heroes/mars/mars_bulwark_retort", LUA_MODIFIER_MOTION_NONE )


function mars_bulwark_retort:GetIntrinsicModifierName()
	return "modifier_mars_bulwark_retort"
end

modifier_mars_bulwark_retort = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_mars_bulwark_retort:Precache( context )
	
	
end

function modifier_mars_bulwark_retort:IsHidden()
	return true
end

function modifier_mars_bulwark_retort:IsPurgeException()
	return false
end

function modifier_mars_bulwark_retort:IsPurgable()
	return false
end

function modifier_mars_bulwark_retort:IsPermanent()
	return true
end




function modifier_mars_bulwark_retort:OnCreated(kv)
    if IsServer() then


        self:StartIntervalThink(0.25)
    end
end
function modifier_mars_bulwark_retort:OnIntervalThink()
   
    if not self:GetParent():HasModifier("modifier_mars_bulwark_active") then

        self.retort = false
    end
    
end
function modifier_mars_bulwark_retort:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_MODIFIER_ADDED,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    }
end

function modifier_mars_bulwark_retort:OnTakeDamage(params)
    if not IsServer() then
        return
    end
    if not self.retort then  
        return  
    end
    if params.unit ~= self:GetParent()  then
        return
    end

    self.aghsfort_mars_gods_rebuke =self:GetParent():FindAbilityByName("aghsfort_mars_gods_rebuke")
    if self.aghsfort_mars_gods_rebuke:GetLevel()>0 then
        local origin = self:GetParent():GetAbsOrigin()
        local direction = self:GetParent():GetForwardVector()
        local angle = 140
        local length = 900
        local enemies = self:FindUnitsInCone_Custom(
                origin,
                direction,
                angle,
                length,
                true,
                self:GetCaster():GetTeamNumber(),
                DOTA_UNIT_TARGET_TEAM_ENEMY,
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                FIND_ANY_ORDER
            )
        
        for _, enemy in pairs(enemies) do
            if enemy and enemy == params.attacker  then
                if  RollPseudoRandomPercentage(17, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, self:GetParent()) then
                    local positon = origin + direction * 50
                    self:GetParent():SetCursorPosition(positon)
                    self.aghsfort_mars_gods_rebuke:OnSpellStart()
                end
            end
        end
    end
end
function modifier_mars_bulwark_retort:OnModifierAdded(params)
    if not IsServer() then
        return
    end

    if params.unit ~= self:GetParent() then
        return
    end
  
   
    if params.added_buff:GetName() == "modifier_mars_bulwark_active" then       
        self.retort = true
    end
 
end

function modifier_mars_bulwark_retort:FindUnitsInCone_Custom(vStartPos, coneDirection, coneAngle, coneLength, bFrontalCone, teamNumber, nTeamFilter, nTypeFilter, nFlagFilter, nOrderFilter )
    local result = {}

    if coneAngle <= 0 or coneAngle >= 180 or coneLength <= 0 then
        return result
    end

    local halfConeAngle = coneAngle * 0.5
    local radius = coneLength / math.cos(halfConeAngle * math.pi/180)

    local coneCenterFinalPos = vStartPos + coneDirection * radius

    local coneRightFinalPos = RotatePosition(vStartPos, QAngle(0, -halfConeAngle, 0), coneCenterFinalPos)
    local coneLeftFinalPos = RotatePosition(vStartPos, QAngle(0, halfConeAngle, 0), coneCenterFinalPos)



    local enemies = FindUnitsInRadius(
        teamNumber, 
        vStartPos,
        nil,
        radius,
        nTeamFilter, 
        nTypeFilter, 
        nFlagFilter,
        nOrderFilter,
        false
    )

    for _, enemy in pairs(enemies) do
        local enemyDirection = enemy:GetAbsOrigin() - vStartPos
        enemyDirection.z = 0

        local coneRightPosDirection = coneRightFinalPos - vStartPos
        coneRightPosDirection.z = 0

        local coneLeftPosDirection = coneLeftFinalPos - vStartPos
        coneLeftPosDirection.z = 0

        local enemyConeRightDirectionDot = DotProduct(coneRightPosDirection:Normalized(), enemyDirection:Normalized())
        local enemyConeLeftDirectionDot = DotProduct(coneLeftPosDirection:Normalized(), enemyDirection:Normalized())

        local enemyConeRightDirectionAngle = 180 * math.acos( enemyConeRightDirectionDot ) / math.pi
        local enemyConeLeftDirectionAngle = 180 * math.acos( enemyConeLeftDirectionDot ) / math.pi

        if enemyConeLeftDirectionAngle >= 0 and enemyConeLeftDirectionAngle <= coneAngle and enemyConeRightDirectionAngle < coneAngle then
            if bFrontalCone then
                table.insert(result, enemy)
            else
                local enemyDistance = enemyDirection:Length2D()

                if enemyDistance <= coneLength then
                    table.insert(result, enemy)
                else
                    local coneCenterPosDirection = coneCenterFinalPos - vStartPos
                    coneCenterPosDirection.z = 0
    
                    local enemyConeCenterDirectionDot = DotProduct(coneCenterPosDirection:Normalized(), enemyDirection:Normalized())
                    local enemyMaxAllowedDistance = coneLength / enemyConeCenterDirectionDot
    
                    if enemyDistance <= enemyMaxAllowedDistance then
                        table.insert(result, enemy)
                    end
                end
            end
        end
    end

    return result
end




