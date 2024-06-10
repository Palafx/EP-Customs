--Dicebound Rollplay
--scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--summon count limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetCondition(s.limcon)
	e2:SetTarget(s.limittg)
	c:RegisterEffect(e2)
	--counter
	local et=Effect.CreateEffect(c)
	et:SetType(EFFECT_TYPE_FIELD)
	et:SetCode(EFFECT_LEFT_SPSUMMON_COUNT)
	et:SetRange(LOCATION_SZONE)
	et:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	et:SetTargetRange(1,1)
	e2:SetCondition(s.limcon)
	et:SetValue(s.countval)
	c:RegisterEffect(et)
	--activate spell limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_FZONE)
	e5:SetOperation(s.aclimit1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTargetRange(1,0)
	e6:SetCondition(s.econ1)
	e6:SetValue(s.elimit)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetOperation(s.aclimit3)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCondition(s.econ2)
	e8:SetTargetRange(0,1)
	c:RegisterEffect(e8)
	-- Prevent battle destruction once
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e9:SetRange(LOCATION_FZONE)
	e9:SetTargetRange(LOCATION_MZONE,0)
	e9:SetCountLimit(1)
	e9:SetValue(function(_,_,r) return r&REASON_BATTLE==REASON_BATTLE end)
	e9:SetTarget(function(_,c) return c:IsSetCard(0xc59) end)
	c:RegisterEffect(e9)
	--+50% damage
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetRange(LOCATION_FZONE)
	e10:SetCode(EFFECT_CHANGE_DAMAGE)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetTargetRange(1,0)
	e10:SetValue(s.val)
	c:RegisterEffect(e10)
	--Coin for Loot
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_DRAW)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e11:SetRange(LOCATION_FZONE)
	e11:SetCode(EVENT_BATTLE_DESTROYING)
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e11:SetCondition(s.reccon)
	e11:SetTarget(s.rectg)
	e11:SetOperation(s.recop)
	c:RegisterEffect(e11)
end
s.listed_series={0xc59}
--summon limit
function s.limcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0xc59),tp,LOCATION_MZONE,0,1,nil)
end
function s.limittg(e,c,tp)
	local t1=Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)
	return t1>=2
end
function s.countval(e,re,tp)
	local t1=Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)
	if t1>=2 then return 0 else return 2-t1-t2-t3 end
end
--spell limit
function s.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_CONTROL+RESET_PHASE+PHASE_END,0,1)
end
function s.econ1(e,c)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return e:GetHandler():GetFlagEffect(id)~=0 and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0xc59),tp,LOCATION_MZONE,0,1,nil)
end
function s.aclimit3(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	e:GetHandler():RegisterFlagEffect(id+1,RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_CONTROL+RESET_PHASE+PHASE_END,0,1)
end
function s.econ2(e,c)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return e:GetHandler():GetFlagEffect(id+1)~=0 and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0xc59),tp,LOCATION_MZONE,0,1,nil)
end
function s.elimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
--damage 
function s.val(e,re,dam,r,rp,rc)
	return math.floor(dam*1.5)
end
--coin
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	return rc:IsRelateToBattle()
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=eg:GetFirst():GetBattleTarget()
	if not tc:IsFaceup() then
		tc=eg:GetNext():GetBattleTarget()
	end
	local op=tc:GetPreviousControler()
	e:SetLabel(op)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local heads=Duel.CountHeads(Duel.TossCoin(1-op,1))
	local ct=heads
	if ct>0 then
		Duel.Draw(1-op,1,REASON_EFFECT)
	else
		Duel.Recover(1-op,1000,REASON_EFFECT)
	end
end
