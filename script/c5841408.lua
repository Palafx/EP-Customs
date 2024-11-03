--Quantum Pilgrim - Shattered Stars
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Xyz Summon procedure
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_PSYCHIC),4,2)
	--Any Spell/Trap sent to the GY is banished instead
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.rmtarget)
	e1:SetTargetRange(0xff,0xff)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTargetRange(0xff,0xff)
	e2:SetTarget(s.checktg)
	c:RegisterEffect(e2)
	--Destroy on Xyz Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,{id,1})
	e3:SetCondition(s.descon)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
	--Change positions and modify atk
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_POSITION+CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,{id,2})
	e4:SetCost(aux.dxmcostgen(1,1,nil))
	e4:SetTarget(s.atktg)
	e4:SetOperation(s.atkop)
	c:RegisterEffect(e4)
	c:RegisterEffect(e4,false,REGISTER_FLAG_DETACH_XMAT)
end
s.listed_names={id}
s.listed_series={0xc53}
--remove s/ts
function s.rmtarget(e,c)
	return not c:IsLocation(0x80) and not c:IsMonster()
end
function s.checktg(e,c)
	return not c:IsPublic()
end
--destroy
function s.stfilter(c)
	return c:IsFaceup() and c:IsSpellTrap() and c:IsSetCard(0xc58)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and Duel.GetMatchingGroupCount(s.stfilter,tp,LOCATION_REMOVED,0,nil)>0
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetMatchingGroupCount(s.stfilter,tp,LOCATION_REMOVED,0,nil)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() and ct>0 end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	Duel.Destroy(g,REASON_EFFECT)
end
--position and atk
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 
	and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND|LOCATION_ONFIELD|LOCATION_GRAVE,0,2,2,nil)
	if #rc>0 and Duel.Remove(rc,POS_FACEDOWN,REASON_EFFECT)>1 then
		Duel.ChangePosition(g,POS_FACEUP_ATTACK)
		Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil):ForEach(function(tc)
			local val=Duel.GetMatchingGroupCount(aux.TRUE,e:GetHandler():GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*-100
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(val)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end)
	end
end