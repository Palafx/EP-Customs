--Apocalypse False Emperor
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,s.ffilter,4)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
	e1:SetCost(s.cost)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--Cannot be destroyed by effects
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
s.listed_names={id}
s.listed_series={0x462}
--fusion
function s.ffilter(c,fc,sumtype,tp)
	return c:IsLevel(4) and c:IsSetCard(0x462,fc,sumtype,tp)
end
--destroy
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_ONFIELD|LOCATION_DECK|LOCATION_HAND,0,7,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_ONFIELD|LOCATION_DECK|LOCATION_HAND,0,e:GetHandler())
	if #g>6 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,7,7,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_COST)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>2 or Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>2 end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local dg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if #hg>2 and #dg>2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
		e:SetLabel(op)
		--choose hand
		if op==0 then
			Duel.ConfirmCards(tp,hg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
			local tg=hg:FilterSelect(tp,aux.TRUE,3,3,nil)
			if #tg>2 then
				Duel.Destroy(tg,REASON_EFFECT)
			end
			Duel.ShuffleHand(1-tp)
		--choose deck
		else
			Duel.ConfirmCards(tp,dg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
			local tg=dg:FilterSelect(tp,aux.TRUE,3,3,nil)
			if #tg>2 then
				Duel.Destroy(tg,REASON_EFFECT)
			end
			Duel.ShuffleDeck(1-tp)
		end
	elseif #hg>2 then
		Duel.ConfirmCards(tp,hg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
		local tg=hg:FilterSelect(tp,aux.TRUE,3,3,nil)
		if #tg>2 then
			Duel.Destroy(tg,REASON_EFFECT)
		end
		Duel.ShuffleHand(1-tp)
	else
		Duel.ConfirmCards(tp,dg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
		local tg=dg:FilterSelect(tp,aux.TRUE,3,3,nil)
		if #tg>2 then
			Duel.Destroy(tg,REASON_EFFECT)
		end
		Duel.ShuffleDeck(1-tp)
	end
end