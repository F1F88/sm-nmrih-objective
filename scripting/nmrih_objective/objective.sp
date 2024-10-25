#pragma newdecls required
#pragma semicolon 1

enum    // Offset
{
    OFS_Objective_m_iId,
    OFS_Objective__sName,
    OFS_Objective__sDescription,
    OFS_Objective__pEntitysVector,
    OFS_Objective__iEntitysCount,
    OFS_Objective__pLinksVector,
    OFS_Objective__iLinksCount,
    OFS_Objective__bIsAntiObjective,
    OFS_Objective__sObjectiveBoundaryName,
    OFS_Objective_Total
};

enum
{
    HDL_Objective_GetObjectiveBoundary,
    HDL_Objective_Total
}

static int    iObjectiveOffset[OFS_Objective_Total];
static Handle hObjevtiveHandle[HDL_Objective_Total];


void LoadObjectiveNative()
{
    CreateNative("Objective.m_iId.get", Native_Objective_Get_m_iId);
    CreateNative("Objective.m_iId.set", Native_Objective_Set_m_iId);
    CreateNative("Objective._sName.get", Native_Objective_Get__sName);
    CreateNative("Objective._sDescription.get", Native_Objective_Get__sDescription);
    CreateNative("Objective._pEntitysVector.get", Native_Objective_Get__pEntitysVector);
    CreateNative("Objective._iEntitysCount.get", Native_Objective_Get__iEntitysCount);
    CreateNative("Objective._pLinksVector.get", Native_Objective_Get__pLinksVector);
    CreateNative("Objective._iLinksCount.get", Native_Objective_Get__iLinksCount);
    CreateNative("Objective._bIsAntiObjective.get", Native_Objective_Get__bIsAntiObjective);
    CreateNative("Objective._bIsAntiObjective.set", Native_Objective_Set__bIsAntiObjective);
    CreateNative("Objective._sObjectiveBoundaryName.get", Native_Objective_Get__sObjectiveBoundaryName);
    CreateNative("Objective.entity.set", Native_Objective_GetId);
    CreateNative("Objective.GetId", Native_Objective_GetId);
    CreateNative("Objective.GetName", Native_Objective_GetName);
    CreateNative("Objective.GetDescription", Native_Objective_GetDescription);
    CreateNative("Objective.GetEntity", Native_Objective_GetEntity);
    CreateNative("Objective.GetEntityCount", Native_Objective_GetEntityCount);
    CreateNative("Objective.GetLink", Native_Objective_GetLink);
    CreateNative("Objective.GetLinkCount", Native_Objective_GetLinkCount);
    CreateNative("Objective.IsEndObjective", Native_Objective_IsEndObjective);
    CreateNative("Objective.IsAntiObjective", Native_Objective_IsAntiObjective);
    CreateNative("Objective.GetObjectiveBoundaryName", Native_Objective_GetObjectiveBoundaryName);
    CreateNative("Objective.GetObjectiveBoundary", Native_Objective_GetObjectiveBoundary);
}

void LoadObjectiveOffset(GameData gamedata)
{
    if (!gamedata)
        SetFailState("Invalid param gamedata.");

    LoadOffset(gamedata, "CNMRiH_Objective::m_iId", OFS_Objective_m_iId);
    LoadOffset(gamedata, "CNMRiH_Objective::_sName", OFS_Objective__sName);
    LoadOffset(gamedata, "CNMRiH_Objective::_sDescription", OFS_Objective__sDescription);
    LoadOffset(gamedata, "CNMRiH_Objective::_pEntitysVector", OFS_Objective__pEntitysVector);
    LoadOffset(gamedata, "CNMRiH_Objective::_iEntitysCount", OFS_Objective__iEntitysCount);
    LoadOffset(gamedata, "CNMRiH_Objective::_pLinksVector", OFS_Objective__pLinksVector);
    LoadOffset(gamedata, "CNMRiH_Objective::_iLinksCount", OFS_Objective__iLinksCount);
    LoadOffset(gamedata, "CNMRiH_Objective::_bIsAntiObjective", OFS_Objective__bIsAntiObjective);
    LoadOffset(gamedata, "CNMRiH_Objective::_sObjectiveBoundaryName", OFS_Objective__sObjectiveBoundaryName);
}

static void LoadOffset(GameData gamedata, const char[] key, int index)
{
    if (index < 0 || index >= OFS_Objective_Total)
        SetFailState("Invalid iObjectiveOffset index %d.", index);

    int offset = gamedata.GetOffset(key);
    if (offset == -1)
        SetFailState("Failed to load offset \"%s\".", key);

    iObjectiveOffset[index] = offset;
}

void LoadObjectiveSignature(GameData gamedata)
{
    StartPrepSDKCall(SDKCall_Raw);
    PrepSDKCall_SetFromConf(gamedata, SDKConf_Signature, "CNMRiH_Objective::GetObjectiveBoundary");
    PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
    if ((hObjevtiveHandle[HDL_Objective_GetObjectiveBoundary] = EndPrepSDKCall()) == null)
        SetFailState("Failed to load signature CNMRiH_Objective::GetObjectiveBoundary.");
}



static any Native_Objective_Get_m_iId(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective instance addr is null.");

    return LoadFromAddress(objective.addr + iObjectiveOffset[OFS_Objective_m_iId], NumberType_Int32);
}

static void Native_Objective_Set_m_iId(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective instance addr is null.");

    int value = GetNativeCell(2);
    StoreToAddress(objective.addr + iObjectiveOffset[OFS_Objective_m_iId], value, NumberType_Int32);
}

static any Native_Objective_Get__sName(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective instance addr is null.");

    return LoadFromAddress(objective.addr + iObjectiveOffset[OFS_Objective__sName], NumberType_Int32);
}

static any Native_Objective_Get__sDescription(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective instance is null.");

    return LoadFromAddress(objective.addr + iObjectiveOffset[OFS_Objective__sDescription], NumberType_Int32);
}

static any Native_Objective_Get__pEntitysVector(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective instance is null.");

    return UtlVector(objective.addr + iObjectiveOffset[OFS_Objective__pEntitysVector]);
}

static any Native_Objective_Get__iEntitysCount(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective instance is null.");

    return LoadFromAddress(objective.addr + iObjectiveOffset[OFS_Objective__iEntitysCount], NumberType_Int32);
}

static any Native_Objective_Get__pLinksVector(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective instance is null.");

    return UtlVector(objective.addr + iObjectiveOffset[OFS_Objective__pLinksVector]);
}

static any Native_Objective_Get__iLinksCount(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective instance is null.");

    return LoadFromAddress(objective.addr + iObjectiveOffset[OFS_Objective__iLinksCount], NumberType_Int32);
}

static any Native_Objective_Get__bIsAntiObjective(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective instance is null.");

    return LoadFromAddress(objective.addr + iObjectiveOffset[OFS_Objective__bIsAntiObjective], NumberType_Int8);
}

static void Native_Objective_Set__bIsAntiObjective(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective instance is null.");

    bool value = GetNativeCell(2);
    StoreToAddress(objective.addr + iObjectiveOffset[OFS_Objective__bIsAntiObjective], value, NumberType_Int8);
}

static any Native_Objective_Get__sObjectiveBoundaryName(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective instance is null.");

    return LoadFromAddress(objective.addr + iObjectiveOffset[OFS_Objective__sObjectiveBoundaryName], NumberType_Int32);
}


static any Native_Objective_GetId(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    return objective.m_iId;
}

static void Native_Objective_GetName(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective instance is null.");

    Stringt name = objective._sName;
    if (name.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective._sName is null.");

    int     maxlen = GetNativeCell(3);
    char[]  buffer = new char[maxlen]; // 不需要扩容, 按照传入的最大长度限制写入
    name.ToCharArray(buffer, maxlen);
    SetNativeString(2, buffer, maxlen);
}

static void Native_Objective_GetDescription(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective instance is null.");

    Stringt description = objective._sDescription;
    if (description.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective._sDescription is null.");

    int     maxlen = GetNativeCell(3);
    char[]  buffer = new char[maxlen]; // 不需要扩容, 按照传入的最大长度限制写入
    description.ToCharArray(buffer, maxlen);
    SetNativeString(2, buffer, maxlen);
}

static any Native_Objective_GetEntity(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective instance is null.");

    UtlVector entityVector = objective._pEntitysVector;
    if (entityVector.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective._pEntitysVector is null.");

    int index = GetNativeCell(2);
    return entityVector.Get(index); // UtlVector 会检查 index
}

static any Native_Objective_GetEntityCount(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    return objective._iEntitysCount;
}

static any Native_Objective_GetLink(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective instance is null.");

    UtlVector linkVector = objective._pLinksVector;
    if (linkVector.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective._pLinksVector is null.");

    int index = GetNativeCell(2);
    return linkVector.Get(index); // UtlVector 会检查 index
}

static any Native_Objective_GetLinkCount(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective instance is null.");

    return objective._iLinksCount;
}

static any Native_Objective_IsEndObjective(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective instance is null.");

    return objective._iLinksCount == 0;
}

static any Native_Objective_IsAntiObjective(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective instance is null.");

    return objective._bIsAntiObjective;
}

static any Native_Objective_GetObjectiveBoundaryName(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective instance is null.");

    Stringt objectiveBoundaryName = objective._sObjectiveBoundaryName;
    if (objectiveBoundaryName.IsNull()) // 可能只是回合没有开始或者wave模式
        ThrowNativeError(SP_ERROR_PARAM, "Objective._sObjectiveBoundaryName is null.");

    int     maxlen = GetNativeCell(3);
    char[]  buffer = new char[maxlen]; // 不需要扩容, 按照传入的最大长度限制写入
    objectiveBoundaryName.ToCharArray(buffer, maxlen);
    SetNativeString(2, buffer, maxlen);
    return true;
}

static any Native_Objective_GetObjectiveBoundary(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective instance is null.");

    return SDKCall(hObjevtiveHandle[HDL_Objective_GetObjectiveBoundary], objective.addr);
}
