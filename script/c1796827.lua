--Oh F!!k!!!
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={id}
--35726888 Foolish Burial Goods
--57995165 Extra-Foolish Burial
--81439173 Foolish Burial
--83778600 Foolish Revival
--88369727 Foolish Return
function s.foofil(c)
	return c:IsCode(35726888,57995165,81439173,83778600,88369727)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local exct=Duel.GetMatchingGroupCount(Card.IsPosition,tp,LOCATION_EXTRA,0,nil,POS_FACEUP)
	local drct=Duel.GetMatchingGroup(s.foofil,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,drct) and exct==0 and Duel.IsExistingMatchingCard(s.foofil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(drct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,drct)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end