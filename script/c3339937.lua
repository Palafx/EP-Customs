--Infinity Collapse
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,4))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_names={id}
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(table.unpack(s.listed_names))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(Card.IsMonster,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	return #g>=6 and (g:GetBitwiseOr(Card.GetAttribute) & (0xf|ATTRIBUTE_DARK)) == (0xf|ATTRIBUTE_DARK)
end
function s.rmfilter(c)
	return c:IsMonster() and c:IsAbleToRemove()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_ALL,LOCATION_ALL,1,nil) end
	local rg=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_ALL,LOCATION_ALL,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,#rg,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_ALL,LOCATION_ALL,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_REMOVED,0,1,nil,ATTRIBUTE_EARTH) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsAttribute,tp,LOCATION_REMOVED,0,1,1,nil,ATTRIBUTE_EARTH)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_REMOVED,0,1,nil,ATTRIBUTE_WATER) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsAttribute,tp,LOCATION_REMOVED,0,1,1,nil,ATTRIBUTE_WATER)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_REMOVED,0,1,nil,ATTRIBUTE_FIRE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsAttribute,tp,LOCATION_REMOVED,0,1,1,nil,ATTRIBUTE_FIRE)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_REMOVED,0,1,nil,ATTRIBUTE_WIND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsAttribute,tp,LOCATION_REMOVED,0,1,1,nil,ATTRIBUTE_WIND)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_REMOVED,0,1,nil,ATTRIBUTE_LIGHT) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsAttribute,tp,LOCATION_REMOVED,0,1,1,nil,ATTRIBUTE_LIGHT)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_REMOVED,0,1,nil,ATTRIBUTE_DARK) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsAttribute,tp,LOCATION_REMOVED,0,1,1,nil,ATTRIBUTE_DARK)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	--Opp
	if Duel.IsExistingMatchingCard(Card.IsAttribute,tp,0,LOCATION_REMOVED,1,nil,ATTRIBUTE_EARTH) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(1-tp,Card.IsAttribute,tp,0,LOCATION_REMOVED,1,1,nil,ATTRIBUTE_EARTH)
		if #g>0 then
			Duel.SendtoHand(g,1-tp,REASON_EFFECT)
			Duel.ConfirmCards(tp,g)
		end
	end
	if Duel.IsExistingMatchingCard(Card.IsAttribute,tp,0,LOCATION_REMOVED,1,nil,ATTRIBUTE_WATER) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(1-tp,Card.IsAttribute,tp,0,LOCATION_REMOVED,1,1,nil,ATTRIBUTE_WATER)
		if #g>0 then
			Duel.SendtoHand(g,1-tp,REASON_EFFECT)
			Duel.ConfirmCards(tp,g)
		end
	end
	if Duel.IsExistingMatchingCard(Card.IsAttribute,tp,0,LOCATION_REMOVED,1,nil,ATTRIBUTE_FIRE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(1-tp,Card.IsAttribute,tp,0,LOCATION_REMOVED,1,1,nil,ATTRIBUTE_FIRE)
		if #g>0 then
			Duel.SendtoHand(g,1-tp,REASON_EFFECT)
			Duel.ConfirmCards(tp,g)
		end
	end
	if Duel.IsExistingMatchingCard(Card.IsAttribute,tp,0,LOCATION_REMOVED,1,nil,ATTRIBUTE_WIND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(1-tp,Card.IsAttribute,tp,0,LOCATION_REMOVED,1,1,nil,ATTRIBUTE_WIND)
		if #g>0 then
			Duel.SendtoHand(g,1-tp,REASON_EFFECT)
			Duel.ConfirmCards(tp,g)
		end
	end
	if Duel.IsExistingMatchingCard(Card.IsAttribute,tp,0,LOCATION_REMOVED,1,nil,ATTRIBUTE_LIGHT) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(1-tp,Card.IsAttribute,tp,0,LOCATION_REMOVED,1,1,nil,ATTRIBUTE_LIGHT)
		if #g>0 then
			Duel.SendtoHand(g,1-tp,REASON_EFFECT)
			Duel.ConfirmCards(tp,g)
		end
	end
	if Duel.IsExistingMatchingCard(Card.IsAttribute,tp,0,LOCATION_REMOVED,1,nil,ATTRIBUTE_DARK) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(1-tp,Card.IsAttribute,tp,0,LOCATION_REMOVED,1,1,nil,ATTRIBUTE_DARK)
		if #g>0 then
			Duel.SendtoHand(g,1-tp,REASON_EFFECT)
			Duel.ConfirmCards(tp,g)
		end
	end
end