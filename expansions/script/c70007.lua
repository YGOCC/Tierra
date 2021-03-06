--"Espadachim - Luar"
local m=70007
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Special Summon"
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(70007,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,70007)
    e1:SetCondition(c70007.spcon)
    e1:SetTarget(c70007.sptg)
    e1:SetOperation(c70007.spop)
    c:RegisterEffect(e1)
    --"Attack All"
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_ATTACK_ALL)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --"To hand"
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(70007,1))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_BATTLE_DESTROYING)
    e3:SetCondition(c70007.thcon)
    e3:SetTarget(c70007.thtg)
    e3:SetOperation(c70007.thop)
    c:RegisterEffect(e3)
end
function c70007.spcfilter(c,tp)
    return c:IsControler(tp) and c:IsSetCard(0x509)
end
function c70007.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c70007.spcfilter,1,nil,tp)
end
function c70007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c70007.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c70007.thcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c70007.filter(c)
    return (c:IsSetCard(0x509) and c:IsType(TYPE_MONSTER)) or (c:IsSetCard(0x510) and c:IsType(TYPE_EQUIP)) and c:IsAbleToHand()
end
function c70007.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c70007.filter(chkc) end
    if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c70007.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c70007.thop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end