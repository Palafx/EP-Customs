--Dicebound Cursed Relic
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE)
	c:RegisterEffect(e1)
	--dice
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER+CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_DICE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
s.roll_dice=true
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	if #eg~=1 then return false end
	local tc=eg:GetFirst()
	return tc~=e:GetHandler() and tc:IsFaceup() and tc:IsSummonPlayer(1-tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,eg:GetFirst():GetLevel()*200)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local d=math.random(1,20)
	local c=e:GetHandler()
	if d==1 then
		Duel.Draw(1-tp,1,REASON_EFFECT)
	elseif d>1 and d<11 then
		local tc=eg:GetFirst()
		if tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) and tc:HasLevel() and not tc:IsImmuneToEffect(e) then
			local atk=tc:GetAttack()
			local nv=math.min(atk,tc:GetLevel()*300)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(-tc:GetLevel()*300)
			tc:RegisterEffect(e1)
		elseif tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) and tc:IsType(TYPE_XYZ) and not tc:IsImmuneToEffect(e) then
			local atk=tc:GetAttack()
			local nv=math.min(atk,tc:GetRank()*300)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(-tc:GetRank()*300)
			tc:RegisterEffect(e1)
		elseif tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) and tc:IsType(TYPE_LINK) and not tc:IsImmuneToEffect(e) then
			local atk=tc:GetAttack()
			local nv=math.min(atk,tc:GetLink()*300)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetValue(-tc:GetLink()*300)
			tc:RegisterEffect(e1)
		end
	elseif d>10 and d<20 then
		Duel.Recover(tp,1000,REASON_EFFECT)
	else
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end