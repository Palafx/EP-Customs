--Dust Flockatrice
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon 2 "Dust Flockatrice" and 2 "Petrify Tokens"
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
--sp summon
function s.spfilter(c,e,tp)
	return c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+LOCATION_HAND)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp)
	if #g<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,2,2,nil)
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) 
    and Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>1
	and Duel.IsPlayerCanSpecialSummonMonster(1-tp,id+1,0,TYPES_TOKEN,2500,0,6,RACE_ROCK,ATTRIBUTE_EARTH,POS_FACEUP,1-tp) then
		for i=1,2 do
			local token=Duel.CreateToken(1-tp,id+1)
			Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP)
			--Cannot attack
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_CANNOT_ATTACK)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e0,true)
			--Cannot be tributed for a tribute summon
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(3304)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1,true)
			--Cannot be used as Fusion material
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetDescription(3309)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e2,true)
			--Cannot be used as Synchro material
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(3310)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e3,true)
			--Cannot be used as Link material
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetDescription(3312)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e4:SetValue(1)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e4,true)
		end
		Duel.SpecialSummonComplete()
		--Cannot Special Summon monsters, except Xyz Monsters until the end of the turn
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,0))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(function(e,c) return not c:IsType(TYPE_XYZ) end)
		e1:SetReset(RESET_PHASE|PHASE_END,1)
		Duel.RegisterEffect(e1,tp)
	end
end