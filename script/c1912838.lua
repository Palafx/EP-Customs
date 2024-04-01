--Umbral Nightmare
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Number 43: Gain LP
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(s.rccon)
	e2:SetTarget(s.rctg)
	e2:SetOperation(s.rcop)
	c:RegisterEffect(e2)
	--Number 96: Change opponent's monsters to Attack Position
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_POSITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(s.poscon)
	e3:SetTarget(s.postg)
	e3:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e3)
	--Number 96: Opponent's monsters cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCondition(s.poscon)
	e4:SetTarget(aux.TRUE)
	c:RegisterEffect(e4)
	--Number 65: Negate Spell/Traps
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_STZONE)
	e5:SetCountLimit(1,{id,1})
	e5:SetCondition(s.negcon)
	e5:SetTarget(s.negtg)
	e5:SetOperation(s.negop)
	c:RegisterEffect(e5)
	aux.DoubleSnareValidity(c,LOCATION_STZONE)
	--Number 104: Remove milled cards
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e6:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e6:SetRange(LOCATION_STZONE)
	--e6:SetTarget(s.rmtarget)
	e6:SetTargetRange(LOCATION_DECK,LOCATION_DECK)
	e6:SetCondition(s.rmcon)
	e6:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e6)
	--Number 104: Mill cards
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,0))
	e7:SetCategory(CATEGORY_DECKDES)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCode(EVENT_REMOVE)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCondition(s.millcon)
	e7:SetTarget(s.milltg)
	e7:SetOperation(s.millop)
	c:RegisterEffect(e7)
end
s.listed_names={id,56051086,3790062,55727845,2061963}
s.listed_series={SET_UMBRAL_HORROR,SET_NUMBER}
--number 43 gain lp
function s.rccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,56051086),tp,LOCATION_ONFIELD,0,1,nil)
end
function s.rcfilter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function s.rctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.rcfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.rcfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.rcfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
end
function s.rcop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
	end
end
--number 96
function s.poscon(e,c)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,55727845),e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function s.postg(e,c)
	return c:IsFaceup() or c:IsFacedown()
end
--number 65: Negate
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,3790062),tp,LOCATION_ONFIELD,0,1,nil)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Damage(1-tp,1000,REASON_EFFECT)
		Duel.SendtoGrave(eg,REASON_EFFECT)
	end
end
--mill
function s.rmcon(e,c)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,2061963),e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function s.millcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():GetControler()==1-tp and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,2061963),tp,LOCATION_ONFIELD,0,1,nil)
end
function s.milltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,1-tp,3)
end
function s.millop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.DiscardDeck(1-tp,3,REASON_EFFECT)
end
