--- Masked HERO Fouuntain
  -- Scripted by EP Custom Cards https://www.facebook.com/EP-Custom-Cards-103958475692047
local s,id=GetID()
function s.initial_effect(c)
--atk down
local e1=Effect.CreateEffect(c)
e1:SetType(EFFECT_TYPE_FIELD)
e1:SetCode(EFFECT_UPDATE_ATTACK)
e1:SetRange(LOCATION_GRAVE)
e1:SetTargetRange(0,LOCATION_MZONE)
e1:SetValue(s.atkval)
c:RegisterEffect(e1)
--Activate
local e2=Effect.CreateEffect(c)
e2:SetType(EFFECT_TYPE_QUICK_O)
e2:SetRange(LOCATION_GRAVE)
e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
e2:SetCode(EVENT_FREE_CHAIN)
e2:SetCountLimit(1,id)
e2:SetCost(aux.bfgcost)
e2:SetTarget(s.target)
e2:SetOperation(s.activate)
c:RegisterEffect(e2)
end
  -- CHANGE ATK
function s.filter(c,e,tp)
  return c:IsSetCard(0x8)
end
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(s.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*-200
end
  -- UNAFFECTED
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(s.efilter)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetOwnerPlayer(tp)
		tc:RegisterEffect(e3)
	end
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
