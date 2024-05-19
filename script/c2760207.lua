--Cosmic Glyph - Void Warp
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END|TIMINGS_CHECK_MONSTER_E)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={id}
s.listed_series={0xc51}
function s.filter(c)
	return c:IsMonster() and c:IsAbleToHand() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc51) and c:IsType(TYPE_SYNCHRO)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sel=0
	local ac=0
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ALL,1,nil) then sel=sel+1 end
	if Duel.IsExistingTarget(aux.FaceupFilter(Card.IsAbleToRemove),tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then sel=sel+2 end
	if sel==1 then
		ac=Duel.SelectOption(tp,aux.Stringid(id,1))
	elseif sel==2 then
		ac=Duel.SelectOption(tp,aux.Stringid(id,0))+1
	elseif Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil,true) then
		ac=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,0),aux.Stringid(id,2))
	else
		ac=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,0))
	end
	e:SetLabel(ac)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	if ac==0 or ac==2 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(s.val)
		e1:SetReset(RESET_PHASE+PHASE_END,1)
		Duel.RegisterEffect(e1,tp)
	end
	if ac==1 or ac==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if #g==0 then return end
		Duel.HintSelection(g,true)
		Duel.BreakEffect()
		aux.RemoveUntil(g,nil,REASON_EFFECT,PHASE_END,id,e,tp,aux.DefaultFieldReturnOp)
	end
end
function s.val(e,re,val,r,rp,rc)
	return math.floor(val/2)
end
