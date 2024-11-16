--Elderax, The Adaptive Entity
--Scripted by EP Custom Cards
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--Special Summon procedure
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(s.eqtg)
	e3:SetOperation(s.eqop)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(function(e,c) return c:GetEquipCount()*1600 end)
	c:RegisterEffect(e4)
	--Cannot be material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_CANNOT_BE_MATERIAL)
	e5:SetValue(aux.cannotmatfilter(SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK))
	c:RegisterEffect(e5)
	--Attribute
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_ADD_ATTRIBUTE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(0xf|ATTRIBUTE_DARK)
	c:RegisterEffect(e6)
end
s.listed_names={id}
s.listed_series={0x499}
--special summon
function s.spfilter(c)
	return c:IsMonster() and c:IsSetCard(0x499) and (c:IsFaceup() or not c:IsOnField()) and c:IsAbleToRemoveAsCost() 
		and aux.SpElimFilter(c,true,true) and not c:IsAttribute(ATTRIBUTE_DIVINE)
end
function s.rescon(sg,e,tp)
    return aux.ChkfMMZ(1)(sg,e,tp,nil)
        and (sg:GetBitwiseOr(Card.GetAttribute) & (0xf|ATTRIBUTE_DARK)) == (0xf|ATTRIBUTE_DARK)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-6 and #rg>5
		and aux.SelectUnselectGroup(rg,e,tp,6,6,s.rescon,0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local g=aux.SelectUnselectGroup(rg,e,tp,6,6,s.rescon,1,tp,HINTMSG_REMOVE,nil,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:DeleteGroup()
end
--equip
function s.eqfilter(c,ec)
	return c:IsType(TYPE_EQUIP+TYPE_TRAP) and c:IsSetCard(0x499) and not c:IsContinuousTrap()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.eqfilter,tp,0x13,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,0x13)
end
function s.eqlimit(e,c)
	return c:GetControler()==e:GetHandlerPlayer() or e:GetHandler():GetEquipTarget()==c
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local ec=Duel.SelectMatchingCard(tp,s.eqfilter,tp,0x13,0,1,1,nil):GetFirst()
	if ec then
		Duel.Equip(tp,ec,c,true)
		local e1=Effect.CreateEffect(ec)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(s.eqlimit)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		ec:RegisterEffect(e1)
	end
end