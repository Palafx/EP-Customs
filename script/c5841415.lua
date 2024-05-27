--Quantum Pilgrim's Astral Arch
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Synchro summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target(TYPE_XYZ,Card.IsXyzSummonable))
	e1:SetOperation(s.operation(TYPE_XYZ,Card.IsXyzSummonable,function(sc,g,tp) Duel.XyzSummon(tp,sc,nil,g) end))
	c:RegisterEffect(e1)
	--Add this card to the hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(s.thcost)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
s.listed_names={id}
s.listed_series={0xc58}
--acivate
function s.relfilter(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.matfilter(c,e,tp)
	return c:IsSetCard(0xc58) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.filter(montype,chkfun)
	return function(c,mg,tp,chk)
		return c:IsSetCard(0xc58) and c:IsType(montype) and (not chk or Duel.GetLocationCountFromEx(tp,tp,mg,c)>0) and (not mg or chkfun(c,nil,mg,#mg,#mg))
	end
end
function s.rescon(exg,chkfun)
	return function(sg,e,tp,mg)
		local _1,_2=aux.dncheck(sg,e,tp,mg)
		return _1 and exg:IsExists(chkfun,1,nil,nil,sg,#sg,#sg),_2
	end
end
function s.target(montype,chkfun)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local exg=Duel.GetMatchingGroup(s.filter(montype,chkfun),tp,LOCATION_EXTRA,0,nil,nil,tp)
		local cancelcon=s.rescon(exg,chkfun)
		if chkc then return chkc:IsControler(tp) and c:IsLocation(LOCATION_REMOVED) and c:IsSetCard(0xc58)
		and chkc:IsCanBeSpecialSummoned(e,0,tp,false,false) and cancelcon(Group.FromCards(chkc)) end
		local mg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_REMOVED,0,nil,e,tp)
		local min=math.min(math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and 1 or 99),1)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft>4 then ft=5 end
		if chk==0 then return min>0 and Duel.IsPlayerCanSpecialSummonCount(tp,2)
			and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
			and aux.SelectUnselectGroup(mg,e,tp,min,ft,cancelcon,0) end
		local sg=aux.SelectUnselectGroup(mg,e,tp,min,ft,cancelcon,chk,tp,HINTMSG_SPSUMMON,cancelcon)
		Duel.SetTargetCard(sg)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,#sg,0,0)
	end
end
function s.operation(montype,chkfun,fun)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetTargetCards(e):Filter(s.relfilter,nil,e,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<#g or #g==0 or (Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and #g>1) then return end
		for tc in aux.Next(g) do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			tc:RegisterEffect(e2)
		end
		Duel.SpecialSummonComplete()
		Duel.BreakEffect()
		local syng=Duel.GetMatchingGroup(s.filter(montype,chkfun),tp,LOCATION_EXTRA,0,nil,g,tp,true)
		if #syng>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local c=syng:Select(tp,1,1,nil):GetFirst()
			fun(c,g,tp)
		end
	end
end
--to hand 
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,c,0xc58) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_GRAVE,0,1,1,c,0xc58)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SendtoHand(c,nil,REASON_EFFECT)==0 then return end
	Duel.ConfirmCards(1-tp,c)
end