--Helios
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,15025844,605002,75347539)
end
s.listed_names={15025844,605002,75347539}