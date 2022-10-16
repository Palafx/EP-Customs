---	Hyper Parasitoid Piliade
local s,id=GetID()
function s.initial_effect(c)
 	---	Link Summon
    Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x53d),2,4)
    c:EnableReviveLimit()
	---	Add Parasite to Opponent Hand (Trigger)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.rmcon)
	e3:SetTarget(s.rmtg)
	e3:SetOperation(s.rmop)
	c:RegisterEffect(e3)
	local e2=e3:Clone()
    e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SUMMON_SUCCESS)
    c:RegisterEffect(e4)
	---	Add Parasite to Opponent Hand (Ignition)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
    c:RegisterEffect(e1)
    ---	Special Summon Token + Add Parasite to Opponent Hand
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(id,1))
    e5:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_DESTROYED)
    e5:SetTarget(s.drtg)
    e5:SetOperation(s.drop)
    c:RegisterEffect(e5)
end
	-------------------------------------------------------
--	to opponent hand trigger
function s.thfilter(c)
	return c:IsSetCard(0x53d) and c:IsAbleToHand() and c:IsLevel(2)
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsContains(e:GetHandler()) then return false end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,LOCATION_MZONE,nil,TYPE_LINK)
	for tc in aux.Next(g) do
		if aux.zptgroupcon(eg,nil,tc) then return true end
	end
	return false
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,1-tp,REASON_EFFECT)
	end
end
--	to opponent hand ignition
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
     Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_HAND)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
    if #g>0 and
        Duel.SendtoHand(g,1-tp,REASON_EFFECT) then
        local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    if #g==0 then return end
    local sg=g:RandomSelect(tp,1)
    Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
--token + add to hand
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) 
and Duel.IsPlayerCanSpecialSummonMonster(tp,982198099,0,TYPES_TOKEN,0,0,1,RACE_INSECT,ATTRIBUTE_EARTH)
end
Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.gyfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsSetCard(0x53d) and c:IsLevel(2)
	end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,982198099,0,TYPES_TOKEN,0,0,1,RACE_INSECT,ATTRIBUTE_EARTH) then
            Duel.BreakEffect()
            local token=Duel.CreateToken(tp,982198099)
            Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
            local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.gyfilter),tp,LOCATION_GRAVE,0,nil)
		if #g>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end