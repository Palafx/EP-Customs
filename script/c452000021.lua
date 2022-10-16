--malady
local s,id=GetID()
function s.initial_effect(c)
  	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
		--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	end
------------------------------------------------	
	function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,0,LOCATION_HAND,1,nil,e,tp) and Duel.IsPlayerCanSpecialSummon(1-tp) end
	end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x53d) and c:IsLevel(2) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
    if Duel.IsExistingMatchingCard(s.spfilter,tp,0,LOCATION_HAND,1,nil,e,1-tp) then 
        Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
        local tc=Duel.SelectMatchingCard(1-tp,s.spfilter,1-tp,LOCATION_HAND,0,1,1,nil,e,1-tp)
        if #tc>0 then
            Duel.SpecialSummon(tc,0,1-tp,1-tp,true,false,POS_FACEUP)
        end
    end
end
--draw
	function s.thfilter(c)
	return c:IsSetCard(0x53d) and c:IsLevel(2) and c:IsAbleToHand()
	end
	function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_HAND)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_HAND,0,1,1,nil)
    if #g>0 and
        Duel.SendtoHand(g,1-tp,REASON_EFFECT) then
        	Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
    end
end