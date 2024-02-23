--Centicreep Lumis
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_INSECT),2,nil,s.matcheck)
	--discard deck & destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,{id,1})
	e2:SetTarget(s.distg)
	e2:SetOperation(s.desop)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	c:RegisterEffect(e2)
end
s.listed_series={0x4cf}
s.listed_names={id}
--link
function s.matcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,2,nil,0x4cf,lc,sumtype,tp)
end
--destroy
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function s.cfilter(c)
	return c:IsMonster() and c:IsSetCard(0x4cf) and c:IsLocation(LOCATION_GRAVE)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,d,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(s.cfilter,nil)
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if ct~=0 and #dg>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sdg=dg:Select(tp,ct,ct,nil)
		Duel.HintSelection(sdg)
		Duel.Destroy(sdg,REASON_EFFECT)
	else
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
