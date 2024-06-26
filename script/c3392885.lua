--Amorphage Treachery
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--maintenance cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(s.descon)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	--special summon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetTarget(s.sumlimit)
	c:RegisterEffect(e3)
	--activation limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(1,1)
	e4:SetCondition(s.relcon)
	e4:SetTarget(s.rellimit)
	c:RegisterEffect(e4)
	--Lizard check
	aux.addContinuousLizardCheck(c,LOCATION_MZONE,s.lizfilter,0xff,0xff)
	--Tributed or destroyed
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_RELEASE)
	e5:SetCountLimit(1,{id,1})
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_DESTROYED)
	c:RegisterEffect(e6)
end
s.listed_names={id}
s.listed_series={SET_AMORPHAGE}
--cannot special summon
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0xe0)
end
--mantain
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c),true)
	if Duel.CheckReleaseGroup(tp,Card.IsReleasableByEffect,1,c) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local g=Duel.SelectReleaseGroup(tp,Card.IsReleasableByEffect,1,1,c)
		Duel.Release(g,REASON_COST)
	else
		Duel.Destroy(c,REASON_COST)
	end
end
--cannot normal summon
function s.relcon(e)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,SET_AMORPHAGE),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.rellimit(e,c,tp,sumtp)
	return not c:IsSetCard(SET_AMORPHAGE)
end
function s.lizfilter(e,c)
	return not c:IsOriginalSetCard(SET_AMORPHAGE)
end
--summon when tributed or destroyed
function s.filter(c,e,tp)
	return c:IsSetCard(SET_AMORPHAGE) and c:IsLevelBelow(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and not c:IsCode(id)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK|LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK|LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK|LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		local atk=tc:GetAttack()
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetOperation(s.destop)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetCountLimit(1)
			tc:RegisterEffect(e2,true)
		end
		Duel.SpecialSummonComplete()
	end
end
function s.destop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end