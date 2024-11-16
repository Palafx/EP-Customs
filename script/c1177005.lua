--Eluf, The Adaptive Gust
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.addtg)
	e1:SetOperation(s.addop)
	c:RegisterEffect(e1)
	--bounce
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_EQUIP)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.recon)
	e3:SetTarget(s.retg)
	e3:SetOperation(s.reop)
	c:RegisterEffect(e3)
end
s.listed_names={id}
s.listed_series={0x499}
--search
function s.addfilter(c)
	return c:IsType(TYPE_EQUIP+TYPE_TRAP) and c:IsAbleToHand() and c:IsSetCard(0x499)
end
function s.addtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.addfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.addop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.addfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--bounce
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSetCard,1,nil,0x499)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() and chkc:IsController(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
--recover
function s.recon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION and e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function s.refilter(c)
	return c:IsSetCard(0x499) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.refilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.refilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.refilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)~=0
		and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		if tc:IsLocation(LOCATION_DECK) then Duel.ShuffleDeck(tc:GetControler()) end
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end