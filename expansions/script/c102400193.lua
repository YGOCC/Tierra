--created & coded by Lyris, art from "Destiny HERO - Dreamer"
--フェイツ・イリュージョンガイ
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(cid.target)
	e2:SetOperation(cid.activate)
	c:RegisterEffect(e2)
	local e0=e2:Clone()
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCost(cid.cost)
	c:RegisterEffect(e0)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_RITUAL_LEVEL)
	e3:SetValue(cid.rlevel)
	c:RegisterEffect(e3)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(aux.PandSSetCon(c,0))
	e1:SetOperation(cid.ssetop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA+LOCATION_OVERLAY+LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetOperation(function(e)
		local c=e:GetHandler()
		if c:GetOriginalType()==TYPE_TRAP then
			c:AddMonsterAttribute(TYPE_MONSTER+TYPE_RITUAL+TYPE_EFFECT)
			c:SetCardData(CARDDATA_TYPE,TYPE_MONSTER+TYPE_RITUAL+TYPE_EFFECT)
		end
	end)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(0)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCode(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	c:RegisterEffect(e3)
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return aux.PandSSetCon(c,-1)(c,e,tp,eg,ep,ev,re,r,rp) end
	cid.ssetop(e,tp,eg,ep,ev,re,r,rp,c)
end
function cid.ssetop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	c:RegisterEffect(e1,true)
	Duel.SSet(c:GetControler(),c,c:GetControler(),false)
	e1:Reset()
	c:SetCardData(CARDDATA_TYPE,TYPE_TRAP)
end
function cid.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if e:GetHandler():IsLocation(LOCATION_SZONE) then lv=e:GetHandler():GetOriginalLevel() end
	if c:IsSetCard(0xf7a) and not c:IsCode(id) then
		local clv=c:GetLevel()
		if c:IsLocation(LOCATION_SZONE) then clv=c:GetOriginalLevel() end
		return lv*(0x1<<16)+clv
	else return lv end
end
function cid.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xf7a)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:IsHasType(EFFECT_TYPE_QUICK_O) and e:GetHandler() or nil
	if chk==0 then return Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_MZONE,0,1,c) end
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cid.filter,tp,LOCATION_MZONE,0,nil)
	local c=e:GetHandler()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(cid.efilter)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		nc:RegisterEffect(e1)
	end
end
function cid.efilter(e,te)
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer()
end
