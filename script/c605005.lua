--Super Xyzmerization
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)
end
s.listed_names={id}
function s.fusionfilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsLevelBelow(4)  and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	if Duel.IsExistingMatchingCard(s.fusionfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then
		local ct=Duel.DiscardHand(tp,Card.IsDiscardable,2,4,REASON_COST+REASON_DISCARD)
		e:SetLabel(ct)
	else
		local ct=Duel.DiscardHand(tp,Card.IsDiscardable,2,3,REASON_COST+REASON_DISCARD)
		e:SetLabel(ct)
	end
end
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.xyzfilter(c,e,tp)
	local ct=Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsType,TYPE_MONSTER),tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	return ct>0 and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRank(ct) 
		and (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function s.matfilter(c,tc)
	return c:IsMonster() and not c:IsType(TYPE_TOKEN) and c~=tc
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	local ct=e:GetLabel()
	if ct>=2 then
		Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--2
	local ct=Duel.GetMatchingGroupCount(aux.FaceupFilter(aux.TRUE),tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local xg=Duel.SelectMatchingCard(tp,s.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #xg>0 then
		Duel.SpecialSummon(xg,0,tp,tp,false,false,POS_FACEUP)
	end
	if e:GetLabel()==2 then return end
	--3+
	if e:GetLabel()>=3 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) then
		local mg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if #mg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
			local ovg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
			local tc=ovg:GetFirst()
			if tc then
				Duel.HintSelection(ovg)
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
				local og=mg:Select(tp,1,2,tc)
				Duel.Overlay(tc,og)
			end
		end
	end
	if e:GetLabel()==3 then return end
	--4
	if e:GetLabel()==4 and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
		or Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local fg=Duel.SelectMatchingCard(tp,s.fusionfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #fg>0 then
			Duel.SpecialSummon(fg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end