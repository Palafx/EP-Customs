--Vylon αpeirωn
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	----PENDULUM EFFECT
	--pendulum summon
	Pendulum.AddProcedure(c)
	--Add or Special Summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,{id,1})
	e0:SetTarget(s.thtg)
	e0:SetOperation(s.thop)
	c:RegisterEffect(e0)
	----MONSTER EFFECT
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,56768355,93157004)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit,s.spcon)
	-- Register "Vylon Alpha" & "Vylon Omega" Special Summon
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--Cannot attack unless equipped
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetCondition(aux.NOT(s.eqcon))
	c:RegisterEffect(e2)
	--multiattack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(function (e,c) return e:GetHandler():GetEquipCount()-1 end)
	c:RegisterEffect(e3)
	--Place self in Pendulum Zone
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(s.pencon)
	e4:SetTarget(s.pentg)
	e4:SetOperation(s.penop)
	c:RegisterEffect(e4)
end
s.listed_names={id,56768355,93157004,CARD_POLYMERIZATION}
s.listed_series={SET_VYLON}
s.listed_materials={56768355,93157004}
----pendulum
function s.thfilter(c)
	return c:IsSpell() and c:IsSetCard(SET_VYLON)  and c:IsAbleToHand()
end
function s.thcostfilter(c)
	return c:IsSetCard(SET_VYLON) and c:IsMonster()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(SET_VYLON) and c:IsLevelBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spcostfilter(c)
	return c:IsSetCard(SET_VYLON) and c:IsSpell()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil) 
	and Duel.IsExistingMatchingCard(s.thcostfilter,tp,LOCATION_HAND|LOCATION_ONFIELD,0,1,nil))
	or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,0x13,0,1,nil,e,tp)
		and  Duel.IsExistingMatchingCard(s.spcostfilter,tp,LOCATION_HAND|LOCATION_ONFIELD,0,1,nil)) end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x13)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(s.thcostfilter,tp,LOCATION_HAND|LOCATION_ONFIELD,0,1,nil)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,0x13,0,1,nil,e,tp)
	and Duel.IsExistingMatchingCard(s.spcostfilter,tp,LOCATION_HAND|LOCATION_ONFIELD,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
		e:SetLabel(op)
		if op==0 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,s.spcostfilter,tp,LOCATION_HAND|LOCATION_ONFIELD,0,1,1,nil)
			Duel.SendtoGrave(g,REASON_EFFECT)
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,0x13,0,1,1,nil,e,tp)
			local tc=sg:GetFirst()
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,s.thcostfilter,tp,LOCATION_HAND|LOCATION_ONFIELD,0,1,1,nil)
			Duel.SendtoGrave(g,REASON_EFFECT)
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil)
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	elseif Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil)
	and Duel.IsExistingMatchingCard(s.thcostfilter,tp,LOCATION_HAND|LOCATION_ONFIELD,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.thcostfilter,tp,LOCATION_HAND|LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.spcostfilter,tp,LOCATION_HAND|LOCATION_ONFIELD,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,0x13,0,1,1,nil,e,tp)
		local tc=sg:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
	end
end
----monster
--fusion procedure
function s.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_ONFIELD+0x13,0,nil)
end
function s.contactop(g)
	Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_MATERIAL)
end
function s.spcon(tp)
	return Duel.GetFlagEffect(tp,id)~=0 and Duel.GetFlagEffect(tp,id+1)~=0
end
function s.reg(c)
	if c:IsCode(56768355) then
		Duel.RegisterFlagEffect(c:GetControler(),id,0,0,0)
	elseif c:IsCode(93157004) then
		Duel.RegisterFlagEffect(c:GetControler(),id+1,0,0,0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	eg:ForEach(s.reg)
end
--unaffected
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--cannot attack unles equipped
function s.eqcon(e)
	local c=e:GetHandler()
	local eg=c:GetEquipGroup()
	return #eg>0
end
--place in pzone
function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
		and c:IsReason(REASON_BATTLE) and c:GetReasonPlayer()==1-tp
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckPendulumZones(tp) end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckPendulumZones(tp) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end