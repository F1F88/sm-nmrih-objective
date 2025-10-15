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
    HDL_Objective_UpdateBoundary,
    HDL_Objective_Total
}

static int    iObjectiveOffset[OFS_Objective_Total];
static Handle hObjevtiveHandle[HDL_Objective_Total];

#if 0
class CNMRiH_Objective                  // size 0x40 / 64
{
    int m_iID;                          // this
    const char *m_szName;               // this + 0x4
    const char *m_szDesc;               // this + 0x8
    CUtlVector<string_t> m_aEntityList; // this + 0xC  / 12
    int m_iEntityCount;                 // this + 0x18 / 24

    CUtlVector<int> m_aLinkList;        // this + 0x20 / 32
    int m_iLinkCount;                   // this + 0x2C / 44

    bool m_bIsAntiObjective;            // this + 0x34 / 52
    const char *m_szObjBoundrayName;    // this + 0x38 / 56
    HSCRIPT m_hScriptInstance;          // this + 0x3C / 60
}
#endif

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
    CreateNative("Objective.ContainsEntity", Native_Objective_ContainsEntity);
    CreateNative("Objective.GetEntity", Native_Objective_GetEntity);
    CreateNative("Objective.GetEntityCount", Native_Objective_GetEntityCount);
    CreateNative("Objective.GetEntityList", Native_Objective_GetEntityList);
    CreateNative("Objective.HasLink", Native_Objective_HasLink);
    CreateNative("Objective.GetLink", Native_Objective_GetLink);
    CreateNative("Objective.GetLinkCount", Native_Objective_GetLinkCount);
    CreateNative("Objective.IsEndObjective", Native_Objective_IsEndObjective);
    CreateNative("Objective.IsAntiObjective", Native_Objective_IsAntiObjective);
    CreateNative("Objective.GetObjectiveBoundaryName", Native_Objective_GetObjectiveBoundaryName);
    CreateNative("Objective.GetObjectiveBoundary", Native_Objective_GetObjectiveBoundary);
    CreateNative("Objective.UpdateBoundary", Native_Objective_UpdateBoundary);
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
    if ((hObjevtiveHandle[HDL_Objective_GetObjectiveBoundary] = EndPrepSDKCall()) == INVALID_HANDLE)
        SetFailState("Failed to load signature CNMRiH_Objective::GetObjectiveBoundary.");

    StartPrepSDKCall(SDKCall_Raw);
    PrepSDKCall_SetFromConf(gamedata, SDKConf_Signature, "CNMRiH_Objective::UpdateBoundary");
    if ((hObjevtiveHandle[HDL_Objective_UpdateBoundary] = EndPrepSDKCall()) == INVALID_HANDLE)
        SetFailState("Failed to load signature CNMRiH_Objective::UpdateBoundary.");
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
    return objective.m_iId; // native 会检查 objective
}

static int Native_Objective_GetName(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);

    int bytes;
    Stringt name = objective._sName; // native 会检查 objective
    if (name.IsNull())
    {
        SetNativeString(2, "", 1, _, bytes);
    }
    else
    {
        int     maxlen = GetNativeCell(3);
        char[]  buffer = new char[maxlen]; // 不需要扩容, 按照传入的最大长度限制写入
        name.ToCharArray(buffer, maxlen);
        SetNativeString(2, buffer, maxlen, _, bytes);
    }
    return bytes;
}

static int Native_Objective_GetDescription(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);

    int bytes;
    Stringt description = objective._sDescription; // native 会检查 objective
    if (description.IsNull())
    {
        SetNativeString(2, "", 1, _, bytes);
    }
    else
    {
        int     maxlen = GetNativeCell(3);
        char[]  buffer = new char[maxlen]; // 不需要扩容, 按照传入的最大长度限制写入
        description.ToCharArray(buffer, maxlen);
        SetNativeString(2, buffer, maxlen, _, bytes);
    }
    return bytes;
}

static any Native_Objective_ContainsEntity(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);

    int entitysCount = objective._iEntitysCount;
    if (entitysCount <= 0)
        return false;

    int entity = GetNativeCell(2);
    UtlVector entitys = objective._pEntitysVector;
    for (int i = 0; i < entitysCount; ++i)
        if (entitys.Get(i) == entity)
            return true;

    return false;
}

static any Native_Objective_GetEntity(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);

    UtlVector entityVector = objective._pEntitysVector; // native 会检查 objective
    if (entityVector.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective._pEntitysVector is null.");

    int index  = GetNativeCell(2);
    int entity = entityVector.Get(index); // UtlVector 会检查 index

    return IsValidEntity(entity) ? entity : -1;
}

static any Native_Objective_GetEntityCount(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    return objective._iEntitysCount; // native 会检查 objective
}

static any Native_Objective_GetEntityList(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);

    UtlVector entityVector = objective._pEntitysVector; // native 会检查 objective
    if (entityVector.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective._pEntitysVector is null.");

    int size = entityVector.size;
    ArrayList result = new ArrayList();

    for (int i = 0; i < size; ++i)
    {
        result.Push(entityVector.Get(i));
    }

    return result;
}

static any Native_Objective_HasLink(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);

    int linksCount = objective._iLinksCount; // native 会检查 objective
    if (linksCount <= 0)
        return false;

    int linkId = GetNativeCell(2);
    UtlVector linksVector = objective._pLinksVector;
    for (int i = 0; i < linksCount; ++i)
    {
        if (linksVector.Get(i) == linkId)
            return true;
    }

    return false;
}

static any Native_Objective_GetLink(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);

    UtlVector linkVector = objective._pLinksVector; // native 会检查 objective
    if (linkVector.IsNull())
        return -1;

    int index = GetNativeCell(2);
    return linkVector.Get(index); // UtlVector 会检查 index
}

static any Native_Objective_GetLinkCount(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    return objective._iLinksCount; // native 会检查 objective
}

static any Native_Objective_IsEndObjective(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    return objective._iLinksCount == 0; // native 会检查 objective
}

static any Native_Objective_IsAntiObjective(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    return objective._bIsAntiObjective; // native 会检查 objective
}

static any Native_Objective_GetObjectiveBoundaryName(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);

    int bytes;
    Stringt objectiveBoundaryName = objective._sObjectiveBoundaryName; // native 会检查 objective
    if (objectiveBoundaryName.IsNull())
    {
        SetNativeString(2, "", 1, _, bytes);
    }
    else
    {
        int     maxlen = GetNativeCell(3);
        char[]  buffer = new char[maxlen]; // 不需要扩容, 按照传入的最大长度限制写入
        objectiveBoundaryName.ToCharArray(buffer, maxlen);
        SetNativeString(2, buffer, maxlen, _, bytes);
    }
    return bytes;
}

static any Native_Objective_GetObjectiveBoundary(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective instance is null.");

    ObjectiveBoundary objectiveBoundary = SDKCall(hObjevtiveHandle[HDL_Objective_GetObjectiveBoundary], objective.addr);
    return objectiveBoundary;
}

static void Native_Objective_UpdateBoundary(Handle plugin, int numParams)
{
    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
        ThrowNativeError(SP_ERROR_PARAM, "Objective instance is null.");

    SDKCall(hObjevtiveHandle[HDL_Objective_UpdateBoundary], objective.addr);
}
