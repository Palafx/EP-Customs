--Express Polymerization
local s,id=GetID()
function s.initial_effect(c)
	local e1=Fusion.CreateSummonEff(c,s.ffilter,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
function s.ffilter(c)
	return c:IsType(TYPE_FUSION)
end
