--Quantum Pilgrim's Stellar Scales
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,{id,1})
	e1:SetCondition(s.condition)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--Add self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,{id,1})
	e2:SetCost(s.ascost)
	e2:SetTarget(s.astg)
	e2:SetOperation(s.asop)
	c:RegisterEffect(e2)
end
s.listed_names={id}
s.listed_series={0xc58}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0xc58),tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_REMOVED,0,nil)>2
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_REMOVED,0,nil)>2 end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,3,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)
	local c=e:GetHandler()
	--Return 1 card on the field or banishment to the hand
	if ct>2 and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD|LOCATION_REMOVED,LOCATION_ONFIELD|LOCATION_REMOVED,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
	--Banish 1 random card from your opponent's hand until the End Phase
	if ct>5 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
		if #g==0 then return end
		local rg=g:RandomSelect(tp,1)
		local tc=rg:GetFirst()
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(tc)
		e1:SetCondition(s.retcon)
		e1:SetOperation(s.retop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	--Banish 1 card on the field
	if ct>8 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if #rc>0 then
			Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
		end
	end
	--Banish 3 cards from either GY
	if ct>11 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,3,3,nil)
		if #rc>0 then
			Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
		end
	end
	--All monsters you control gain ATK & DEF
	if ct>14 and Duel.IsExistingMatchingCard(aux.FaceupFilter(aux.TRUE),tp,LOCATION_MZONE,0,1,nil) then
		local atkg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local val=Duel.GetMatchingGroupCount(aux.TRUE,e:GetHandler():GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil)*100
		for tc in aux.Next(atkg) do
			tc:UpdateAttack(val,nil,c)
		end
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(id)==0 then
		e:Reset()
		return false
	else
		return true
	end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,1-tp,REASON_EFFECT)
end
--add self
function s.ascost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.astg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_ALL)
end
function s.asop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end