--Natsuki Subaru
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	Pendulum.AddProcedure(c)
	--To Extra
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,{id,1})
	e1:SetTarget(s.tetg)
	e1:SetOperation(s.teop)
	c:RegisterEffect(e1)
	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,{id,2})
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.addcon)
	c:RegisterEffect(e3)
	--Special Summon 1 "Blue-Eyes" monster, or 1 "Chaos" or "Black Luster Soldier" Ritual Monster, from your Extra Deck or GY
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCountLimit(1,{id,3})
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end
s.listed_names={id,25258741}
--to extra
function s.tefilter(c)
	return c:IsType(TYPE_PENDULUM) and Card.ListsCode(c,25258742)
end
function s.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and Card.ListsCode(c,25258742) and c:IsAbleToHand()
end
function s.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tefilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)	
end
function s.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	local g=Duel.SelectMatchingCard(tp,s.tefilter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 then 
		Duel.SendtoExtraP(g,tp,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--add when pendulum summmoned
function s.addcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 or Duel.SendtoHand(g,nil,REASON_EFFECT)==0 then return end
	local tc=g:GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	if tc:IsCode(25258741) and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--special summon self
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and rp==1-tp
end
function s.spfilter(c,e,tp,mmz_chk)
	if not (e:GetHandler() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then
		return false
	end
	if c:IsLocation(LOCATION_GRAVE) then
		return mmz_chk
	else
		return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
	end
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mmz_chk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_EXTRA|LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local mmz_chk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(e:GetHandler()),tp,LOCATION_EXTRA|LOCATION_GRAVE,0,1,1,nil,e,tp,mmz_chk)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end