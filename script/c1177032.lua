--Adaptive Trait - Sudden Mutation
--Scripted by EP Custom cards
local s,id=GetID()
function s.initial_effect(c)
	--activate and equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(s.condition)
	e1:SetCost(s.remcost)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--Special Summon from the Extra Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(s.cost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
s.listed_names={id}
s.listed_series={0x499}
--equip
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(s.confilter),tp,LOCATION_MZONE,0,1,nil)
end
function s.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0x499) and not c:IsType(TYPE_FUSION)
end
function s.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x499) and c:IsType(TYPE_FUSION) and c:IsAbleToRemoveAsCost()
end
function s.remcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_MZONE,0,1,nil) and aux.RemainFieldCost(e,tp,eg,ep,ev,re,r,rp,0) end
  aux.RemainFieldCost(e,tp,eg,ep,ev,re,r,rp,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		e1:SetLabelObject(g:GetFirst())
		e1:SetCountLimit(1)
		e1:SetOperation(s.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function s.eqfil(c)
	return c:IsFaceup() and c:IsSetCard(0x499)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.eqfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.eqfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.eqfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsStatus(STATUS_LEAVE_CONFIRMED) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		--equip
		Duel.Equip(tp,c,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(s.eqlimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	else
		c:CancelToGrave(false)
	end
end
function s.eqlimit(e,c)
	return c:GetControler()==e:GetHandlerPlayer() or e:GetHandler():GetEquipTarget()==c
end
--draw
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--sp summon
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x499) and (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 or not c:IsLocation(LOCATION_EXTRA)) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if #g>0 then
		local tg=g:RandomSelect(1-tp,1)
    Duel.ConfirmCards(1-tp,tg)
    if tg:IsExists(s.filter,1,nil,e,tp,c) then
      local tc=tg:GetFirst()
		  Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
      local fid=c:GetFieldID()
      tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
      tc:CompleteProcedure()
      local e1=Effect.CreateEffect(c)
      e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
      e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
      e1:SetCode(EVENT_PHASE+PHASE_END)
      e1:SetCountLimit(1)
      e1:SetLabel(fid)
      e1:SetLabelObject(tc)
      e1:SetCondition(s.rmcon)
      e1:SetOperation(s.rmop)
      Duel.RegisterEffect(e1,tp)
		end
	end
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetFlagEffectLabel(id)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end