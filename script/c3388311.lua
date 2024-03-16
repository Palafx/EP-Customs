--Catastrophe Vortex
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Send 1 monster to the GY
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={id}
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,4,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,4,4,REASON_COST+REASON_DISCARD,nil)
	local rc=Duel.AnnounceRace(tp,1,RACE_ALL)
	e:SetLabel(rc)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local race=e:GetLabel()
	local g=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_DECK,LOCATION_DECK,nil,race)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end