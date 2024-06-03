--Dicebound Arcane Scout
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--dice
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_DRAW+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.dicetg)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.roll_dice=true
function s.filter(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc59)
end
function s.dicetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local d=math.random(1,20)
	local c=e:GetHandler()
	if d==1 then
		Duel.Draw(1-tp,2,REASON_EFFECT)
	elseif d>1 and d<11 then
		if not Duel.IsPlayerCanDiscardDeck(tp,3) then return end
		Duel.ConfirmDecktop(tp,3)
		local g=Duel.GetDecktopGroup(tp,3)
		if #g>0 then
			Duel.DisableShuffleCheck()
			if g:IsExists(s.filter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:FilterSelect(tp,s.filter,1,1,nil)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				g:Sub(sg)
			end
			Duel.SendtoGrave(g,REASON_EFFECT|REASON_EXCAVATE)
		end
	elseif d>10 and d<20 then
		local g0=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		Duel.ConfirmCards(tp,g0)
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			if Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_END then
				e1:SetLabel(Duel.GetTurnCount())
				e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
			else
				e1:SetLabel(0)
				e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			end
			e1:SetLabelObject(tc)
			e1:SetCondition(s.retcon)
			e1:SetOperation(s.retop)
			Duel.RegisterEffect(e1,tp)
		end
		Duel.ShuffleHand(1-tp)
	else
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(id)==0 then
		e:Reset()
		return false
	else
		return Duel.GetTurnPlayer()==1-tp and Duel.GetTurnCount()~=e:GetLabel()
	end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,1-tp,REASON_EFFECT)
end
