--- Masked HERO Dusk Crow
local s,id=GetID()
function s.initial_effect(c)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.rmtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
--	ADD MASK CHANGE
local e2=Effect.CreateEffect(c)
e2:SetDescription(aux.Stringid(id,1))
e2:SetCategory(CATEGORY_TOHAND)
e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
e2:SetProperty(EFFECT_FLAG_DELAY)
e2:SetCode(EVENT_TO_GRAVE)
e2:SetCountLimit(1,id)
e2:SetCondition(s.thcon)
e2:SetTarget(s.thtg)
e2:SetOperation(s.thop)
c:RegisterEffect(e2)
end
  --banish all monsters in opp hand
function s.filter(c,e,tp)
		return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
    local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    if Duel.IsPlayerAffectedByEffect(1-tp,30459350) or #hg==0 then return end
    local g=Duel.GetMatchingGroup(s.filter,1-tp,LOCATION_HAND,0,nil)
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    Duel.ShuffleHand(1-tp)
		g:KeepAlive()
    local c=e:GetHandler()
    local fid=c:GetFieldID()
    for tc in g:Iter() do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DRAW_COUNT)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(0,1)
			e1:SetValue(2)
			e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,1)
			Duel.RegisterEffect(e1,tp)
      tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
    end
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_PHASE+PHASE_END)
    e2:SetCountLimit(1)
    e2:SetLabel(fid)
    e2:SetLabelObject(g)
    e2:SetCondition(s.retcon)
    e2:SetOperation(s.retop)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)	
end
function s.desfilter(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(s.desfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(s.desfilter,nil,e:GetLabel())
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
end
	-- add mask change
	function s.thcon(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		return re and re:GetHandler():IsType(TYPE_SPELL) and c:IsReason(REASON_EFFECT)
end
function s.thfilter(c)
	return c:IsSetCard(0xa5) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end