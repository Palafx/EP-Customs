--Parasitic Decay
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
  local n1=g:FilterCount(s.pfilter,nil)
  local n2=g:FilterCount(s.ownfilter,nil,tp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 and Duel.GetDrawCount(tp)>0 and n1>n2
end
function s.pfilter(c)
  return c:IsPublic() and c:IsSetCard(0x53d) and c:IsLevel(2)
end
function s.ownfilter(c,tp)
  return c:GetOwner()==1-tp
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
  local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	local gt=Duel.GetDecktopGroup(1-tp,1)
	if gt then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,gt,1,0,0)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
  _replace_count=_replace_count+1
  if _replace_count>_replace_max or not e:GetHandler():IsRelateToEffect(e) then return end
	local gt=Duel.GetDecktopGroup(1-tp,1)
	if gt then
		Duel.SendtoHand(gt,tp,REASON_EFFECT)
	end
end