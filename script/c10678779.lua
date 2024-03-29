--Aegaion the Sea Kingdom
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	Xyz.AddProcedure(c,nil,10,3)
	c:EnableReviveLimit()
	--remove from deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCondition(s.atcon)
	e1:SetTarget(s.rmtg1)
	e1:SetOperation(s.rmop1)
	c:RegisterEffect(e1)
	--remove from extra
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetTarget(s.rmtg2)
	e2:SetOperation(s.rmop2)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,{id,1})
	e3:SetCost(s.descost)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3,false,REGISTER_FLAG_DETACH_XMAT)
end
s.listed_names={10678778,id}
--if has code as material
function s.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,10678778)
end
--banish from deck
function s.rmfilter(c)
	return c:IsAbleToRemove()
end
function s.rmtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,0,LOCATION_DECK,5,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,5,1-tp,LOCATION_DECK)
end
function s.rmop1(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_DECK,nil)
  if #g<4 then return end
  local tg=g:RandomSelect(tp,5)
  Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
  local atk=tg:GetSum(Card.GetAttack)
  if atk<0 then atk=0 end
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SET_ATTACK_FINAL)
  e1:SetValue(atk)
  e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
  c:RegisterEffect(e1)
end
--banish from extra
function s.rmfilter2(c)
	return c:IsAbleToRemove()
end
function s.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter2,tp,0,LOCATION_EXTRA,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,1-tp,LOCATION_EXTRA)
end
function s.rmop2(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(s.rmfilter2,tp,0,LOCATION_EXTRA,nil)
  if #g<1 then return end
  local tg=g:RandomSelect(tp,2)
  Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
  local atk=tg:GetSum(Card.GetAttack)
  if atk<0 then atk=0 end
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_SET_ATTACK_FINAL)
  e1:SetValue(atk)
  e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
  c:RegisterEffect(e1)
end
--destroy
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.filter(c,tp)
	local ctype=(c:GetType()&TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK)
	return c:IsFaceup() and ctype~=0 and c:IsAbleToExtra()
		and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsType,ctype),tp,0,LOCATION_MZONE,1,nil)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(1-tp) and s.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,0,LOCATION_REMOVED,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_REMOVED,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	local ctype=(g:GetFirst():GetType()&TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK)
	local dg=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsType,ctype),tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)~=0 then
		local ctype=(tc:GetType()&TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.FaceupFilter(Card.IsType,ctype),tp,0,LOCATION_MZONE,1,1,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end