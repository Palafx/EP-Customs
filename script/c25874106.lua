--Garmungandr
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,2665273,25874104)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.rectg)
	e1:SetOperation(s.recop)
	c:RegisterEffect(e1)
	aux.GlobalCheck(s,function()
		s[0]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		aux.AddValuesReset(function()
			s[0]=0
		end)
	end)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
s.listed_names={2665273,25874104}
s.listed_series={SET_GENERAIDER}
--fusion
function s.ffilter(c,fc,sumtype,tp)
	return c:IsSetCard(SET_VAYLANTZ,fc,sumtype,tp) and c:IsLevelAbove(5)
end
function s.contactfil(tp)
	return Duel.GetReleaseGroup(tp)
end
function s.contactop(g)
	Duel.Release(g,REASON_COST+REASON_MATERIAL)
end
function s.splimit(e,se,sp,st)
	local c=e:GetHandler()
	return not (c:IsLocation(LOCATION_EXTRA) and c:IsFacedown())
end
--rec
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	s[0]=s[0]+eg:FilterCount(Card.IsType,nil,TYPE_MONSTER)
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return s[0]~=0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(s[0]*1000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,s[0]*1000)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.Recover(p,s[0]*1000,REASON_EFFECT)
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.BreakEffect()
		--Gains ATK
		c:UpdateAttack(ct)
	end
end
--special summon
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and c:GetLocation()~=LOCATION_DECK
		and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp and c:IsPreviousControler(tp)
end
function s.filter1(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(SET_GENERAIDER) and Duel.GetLocationCountFromEx(tp,tp,ec,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return false end
		local g=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp)
		return g:GetClassCount(Card.GetCode)>=1
	end
	e:GetHandler():CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetMatchingGroup(s.filter1,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp)
	local sg=aux.SelectUnselectGroup(g,e,tp,1,1,aux.dncheck,1,tp,HINTMSG_SPSUMMON)
	if sg then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
