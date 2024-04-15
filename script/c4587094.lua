--Saprophyte Musher
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCondition(s.descon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end
s.listed_names={id}
--atk gain
function s.atkval(e,c)
	local races=RACE_ZOMBIE|RACE_ROCK|RACE_PLANT|RACE_INSECT
	local g=Duel.GetMatchingGroup(Card.IsRace,e:GetHandler():GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil,races)
	return g:GetSum(Card.GetAttack)/2
end
--destroy
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local races=RACE_ZOMBIE|RACE_ROCK|RACE_PLANT|RACE_INSECT
	if chk==0 then return not e:GetHandler():IsLocation(LOCATION_DECK) end
	if not Duel.IsExistingMatchingCard(Card.IsRace,e:GetHandler():GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,1,nil,races) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local races=RACE_ZOMBIE|RACE_ROCK|RACE_PLANT|RACE_INSECT
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if Duel.IsExistingMatchingCard(Card.IsRace,e:GetHandler():GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,2,nil,races)
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		local g=Duel.SelectMatchingCard(tp,Card.IsRace,tp,LOCATION_GRAVE,0,2,2,nil,races)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	else Duel.Destroy(c,REASON_EFFECT) end
end