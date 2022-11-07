--Parasitic Outbreak
--Scripted by EP Custom Cards https://www.facebook.com/EP-Custom-Cards-103958475692047
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetHintTiming(0,TIMING_DRAW_PHASE)
  e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
  e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
  local n1=g:FilterCount(s.pfilter,nil)
  local n2=g:FilterCount(s.ownfilter,nil,tp)
  return n1>0 and n2==0 and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_HAND)>=5
end
function s.pfilter(c)
  return c:IsPublic() and c:IsSetCard(0x53d) and c:IsLevel(2)
end
function s.ownfilter(c,tp)
  return c:GetOwner()==1-tp
end
function s.filter(c)
	return c:IsLevel(2) and c:IsSetCard(0x53d) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ALL,0,1,nil) end
  local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ALL,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_ALL)
  Duel.SetOperationInfo(0,CATEGORY_HANDES,Duel.GetFieldGroup(tp,0,LOCATION_HAND),1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,300)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_ALL,0,nil)
	if #g>0 then
		Duel.SendtoHand(g,1-tp,REASON_EFFECT)
    local tg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
    local tct=ct*400
    local gt=Duel.GetDecktopGroup(1-tp,ct)
    Duel.BreakEffect()
    if gt then
    Duel.SendtoHand(gt,tp,REASON_EFFECT)
    Duel.Recover(1-tp,tct,REASON_EFFECT)
    Duel.SendtoDeck(tg,1-tp,0,REASON_EFFECT)
    Duel.ShuffleDeck(1-tp)
    --Duel.SendtoGrave(tg,REASON_EFFECT+REASON_DISCARD)
    end
	end
end