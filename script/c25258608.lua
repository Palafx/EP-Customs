--Dicebound Gambler's Gambit
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--dice
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.dicetg)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.roll_dice=true
function s.dicetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local d=math.random(1,20)
	local c=e:GetHandler()
	if d==1 then
		Duel.Draw(1-tp,3,REASON_EFFECT)
		Duel.Damage(tp,1500,REASON_EFFECT)
	elseif d>1 and d<11 then
		local dct1=Duel.GetDecktopGroup(1-tp,5)
		local dct2=Duel.GetDecktopGroup(tp,5)
		if #dct2<5 or #dct1<5 then return end
		--player banishes opp deck
		Duel.ConfirmDecktop(1-tp,5)
		local g=Duel.GetDecktopGroup(1-tp,5)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
			Duel.DisableShuffleCheck()
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			Duel.MoveToDeckBottom(g)
			Duel.SortDeckbottom(1-tp,1-tp,4)
		end
		--opp banishes oplayer's deck
		Duel.ConfirmDecktop(tp,5)
		local g=Duel.GetDecktopGroup(tp,5)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
			local sg=g:FilterSelect(1-tp,Card.IsAbleToRemove,1,1,nil)
			Duel.DisableShuffleCheck()
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			Duel.MoveToDeckBottom(g)
			Duel.SortDeckbottom(tp,tp,4)
		end
	elseif d>10 and d<20 then
		if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil)
		or Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) then
			--Select option
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
			local op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
			e:SetLabel(op)
			if op==0 then --banish monster
				local ct=Duel.TossDice(tp,1)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
				local tc=g:GetFirst()
				if tc==nil then return end
				if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
					tc:SetTurnCounter(0)
					tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
					e1:SetReset(RESET_PHASE+PHASE_STANDBY,ct)
					e1:SetLabel(ct)
					e1:SetLabelObject(tc)
					e1:SetCountLimit(1)
					e1:SetCondition(s.turncon)
					e1:SetOperation(s.turnop)
					Duel.RegisterEffect(e1,tp)
					local e2=e1:Clone()
					e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
					e2:SetCondition(s.retcon)
					e2:SetOperation(s.retop)
					Duel.RegisterEffect(e2,tp)
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
					e3:SetCode(1082946)
					e3:SetOwnerPlayer(tp)
					e3:SetLabelObject(e1)
					e3:SetOperation(s.reset)
					e3:SetReset(RESET_PHASE+PHASE_STANDBY,ct)
					c:RegisterEffect(e3)
				end
			else --banish from hand
				local ct=Duel.TossDice(tp,1)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1,nil)
				local tc=g:GetFirst()
				if tc==nil then return end
				if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
					tc:SetTurnCounter(0)
					tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
					e1:SetReset(RESET_PHASE+PHASE_STANDBY,ct)
					e1:SetLabel(ct)
					e1:SetLabelObject(tc)
					e1:SetCountLimit(1)
					e1:SetCondition(s.turncon)
					e1:SetOperation(s.turnop)
					Duel.RegisterEffect(e1,tp)
					local e2=e1:Clone()
					e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
					e2:SetCondition(s.retcon)
					e2:SetOperation(s.retop)
					Duel.RegisterEffect(e2,tp)
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
					e3:SetCode(1082946)
					e3:SetOwnerPlayer(tp)
					e3:SetLabelObject(e1)
					e3:SetOperation(s.reset)
					e3:SetReset(RESET_PHASE+PHASE_STANDBY,ct)
					c:RegisterEffect(e3)
				end
			end
		elseif Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) then
			local ct=Duel.TossDice(tp,1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
			local tc=g:GetFirst()
			if tc==nil then return end
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
				tc:SetTurnCounter(0)
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
				e1:SetReset(RESET_PHASE+PHASE_STANDBY,ct)
				e1:SetLabel(ct)
				e1:SetLabelObject(tc)
				e1:SetCountLimit(1)
				e1:SetCondition(s.turncon)
				e1:SetOperation(s.turnop)
				Duel.RegisterEffect(e1,tp)
				local e2=e1:Clone()
				e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
				e2:SetCondition(s.retcon)
				e2:SetOperation(s.retop)
				Duel.RegisterEffect(e2,tp)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
				e3:SetCode(1082946)
				e3:SetOwnerPlayer(tp)
				e3:SetLabelObject(e1)
				e3:SetOperation(s.reset)
				e3:SetReset(RESET_PHASE+PHASE_STANDBY,ct)
				c:RegisterEffect(e3)
			end
		else
			local ct=Duel.TossDice(tp,1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1,nil)
			local tc=g:GetFirst()
			if tc==nil then return end
			if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
				tc:SetTurnCounter(0)
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
				e1:SetReset(RESET_PHASE+PHASE_STANDBY,ct)
				e1:SetLabel(ct)
				e1:SetLabelObject(tc)
				e1:SetCountLimit(1)
				e1:SetCondition(s.turncon)
				e1:SetOperation(s.turnop)
				Duel.RegisterEffect(e1,tp)
				local e2=e1:Clone()
				e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
				e2:SetCondition(s.retcon)
				e2:SetOperation(s.retop)
				Duel.RegisterEffect(e2,tp)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
				e3:SetCode(1082946)
				e3:SetOwnerPlayer(tp)
				e3:SetLabelObject(e1)
				e3:SetOperation(s.reset)
				e3:SetReset(RESET_PHASE+PHASE_STANDBY,ct)
				c:RegisterEffect(e3)
			end
		end
	else
		Duel.Draw(tp,3,REASON_EFFECT)
		Duel.Recover(tp,3000,REASON_EFFECT)
	end
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	e:GetHandler():SetTurnCounter(ct+1)
	if ct==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT) end
		Duel.SpecialSummon(e:GetHandler(),0,1-tp,tp,false,false,POS_FACEUP)
	else e:SetLabel(1) end
end
function s.reset(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetLabelObject() then e:Reset() return end
	s.turnop(e:GetLabelObject(),tp,eg,ep,ev,e,r,rp)
end
function s.turncon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffect(id)~=0
end
function s.turnop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local ct=tc:GetTurnCounter()
	ct=ct+1
	tc:SetTurnCounter(ct)
	if ct>e:GetLabel() then
		e:Reset()
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local ct=tc:GetTurnCounter()
	if ct==e:GetLabel() then
		return true
	end
	if ct>e:GetLabel() then
		e:Reset()
		if re then re:Reset() end
	end
	return false
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc)
end