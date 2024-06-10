--Necrotic Verses
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	local e1=Ritual.CreateProc({handler=c,lvtype=RITPROC_GREATER,filter=s.ritualfil,extrafil=s.extrafil,extraop=s.extraop,matfilter=s.forcedgroup,location=LOCATION_HAND+LOCATION_GRAVE})
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
s.listed_names={id}
function s.ritualfil(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_PSYCHIC)
end
function s.exfilter0(c)
	return (c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYNCHRO)) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function s.fsxfilter(c)
	return c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ)
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.IsExistingMatchingCard(s.fsxfilter,tp,LOCATION_MZONE,0,1,nil) then
		return Duel.GetMatchingGroup(s.exfilter0,tp,LOCATION_EXTRA,0,nil)
	end
end
function s.extraop(mg,e,tp,eg,ep,ev,re,r,rp)
	local mat2=mg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
	mg:Sub(mat2)
	Duel.ReleaseRitualMaterial(mg)
	Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
end
function s.forcedgroup(c,e,tp)
	return (c:IsMonster() and c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD)) or (c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA))
end