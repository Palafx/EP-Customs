--Dicebound Quicksand Quagmire
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--dice
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE+CATEGORY_DESTROY+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.roll_dice=true
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	if chk==0 then return a:IsOnField() end
	Duel.SetTargetCard(a)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,a,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local d=math.random(1,20)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if d==1 then
		if tc:IsRelateToEffect(e) and tc:CanAttack() and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	elseif d>1 and d<11 then
		local r=Duel.TossDice(1-tp,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(r*-200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	elseif d>10 and d<20 then
		Duel.NegateAttack()
	else
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,LOCATION_SZONE,0,1,1,false,nil)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end