--- Help-a-Bot
local s,id=GetID()
function s.initial_effect(c)
-- Link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,nil,2,2,s.lcheck)
-- Send 1 Machine to the GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,id)
  e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
--link material
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsRace,1,nil,RACE_MACHINE,lc,sumtype,tp)
end
--send
function s.tgfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToGrave()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT) then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	  local hg=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	  if #hg>0 then
		  Duel.SendtoHand(hg,nil,REASON_EFFECT)
		  Duel.ConfirmCards(1-tp,hg)
    end
	end
end