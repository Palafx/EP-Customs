--Prophecy of the Sun
--scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Ritual Summon
	Ritual.AddProcGreater({handler=c,filter=s.ritualfil,lvtype=RITPROC_GREATER,sumpos=POS_FACEUP_ATTACK|POS_FACEUP_DEFENSE,location=LOCATION_HAND+LOCATION_GRAVE})
end
s.listed_series={0x69}
function s.ritualfil(c)
	return c:IsSetCard(0x69) and c:IsRitualMonster()
end