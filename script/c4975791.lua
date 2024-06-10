--Incantation
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Fusion Summon 1 Fusion monster using materials from the hand
	local e1=Fusion.CreateSummonEff(c,nil,s.matfilter,s.fextra,s.extraop,nil,nil,nil,nil,nil,nil,nil,nil,nil,s.extratg)
	c:RegisterEffect(e1)
end
s.listed_series={SET_INVOKED}
function s.matfilter(c)
	return (c:IsLocation(LOCATION_HAND) and c:IsAbleToGrave()) or (c:IsOnField() and c:IsAbleToRemove())
end
function s.checkmat(tp,sg,fc)
	return fc:IsSetCard(SET_INVOKED) or not sg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE|LOCATION_ONFIELD)
end
function s.fextra(e,tp,mg)
	if not Duel.IsPlayerAffectedByEffect(tp,CARD_SPIRIT_ELIMINATION) then
		return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil),s.checkmat
	end
	return nil,s.checkmat
end
function s.extraop(e,tc,tp,sg)
	local rg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE|LOCATION_ONFIELD)
	if #rg>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		sg:Sub(rg)
	end
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,0,PLAYER_EITHER,LOCATION_MZONE|LOCATION_GRAVE)
end