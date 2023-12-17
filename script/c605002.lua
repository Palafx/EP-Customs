--Helios
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_THUNDER),aux.FilterBoolFunctionEx(Card.IsType,TYPE_NORMAL),aux.FilterBoolFunctionEx(Card.IsRace,RACE_DRAGON))
end