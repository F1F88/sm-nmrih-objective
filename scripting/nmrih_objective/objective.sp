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

/*
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
*/

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
    //CreateNative("Objective.entity.set", Native_Objective_GetId);
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
        g_hLogger.Fatal("Invalid param gamedata.");

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
        g_hLogger.FatalF("Invalid iObjectiveOffset index %d.", index);

    int offset = gamedata.GetOffset(key);
    if (offset == -1)
        g_hLogger.FatalF("Failed to load offset \"%s\".", key);

    iObjectiveOffset[index] = offset;
    g_hLogger.TraceF("Load %s offset %d.", key, offset);
}

void LoadObjectiveSignature(GameData gamedata)
{
    StartPrepSDKCall(SDKCall_Raw);
    PrepSDKCall_SetFromConf(gamedata, SDKConf_Signature, "CNMRiH_Objective::GetObjectiveBoundary");
    PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
    if ((hObjevtiveHandle[HDL_Objective_GetObjectiveBoundary] = EndPrepSDKCall()) == INVALID_HANDLE)
        g_hLogger.Fatal("Failed to load signature CNMRiH_Objective::GetObjectiveBoundary.");
    else
        g_hLogger.Trace("Load signature CNMRiH_Objective::GetObjectiveBoundary.");

    StartPrepSDKCall(SDKCall_Raw);
    PrepSDKCall_SetFromConf(gamedata, SDKConf_Signature, "CNMRiH_Objective::UpdateBoundary");
    if ((hObjevtiveHandle[HDL_Objective_UpdateBoundary] = EndPrepSDKCall()) == INVALID_HANDLE)
        g_hLogger.Fatal("Failed to load signature CNMRiH_Objective::UpdateBoundary.");
    else
        g_hLogger.Trace("Load signature CNMRiH_Objective::UpdateBoundary.");
}



static any Native_Objective_Get_m_iId(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective.m_iId.get called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        return 0;
    }

    return LoadFromAddress(objective.addr + iObjectiveOffset[OFS_Objective_m_iId], NumberType_Int32);
}

static any Native_Objective_Set_m_iId(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective.m_iId.set called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        return 0;
    }

    int value = GetNativeCell(2);
    g_hLogger.DebugF("Param value %d.", value);
    StoreToAddress(objective.addr + iObjectiveOffset[OFS_Objective_m_iId], value, NumberType_Int32);
    return 0;
}

static any Native_Objective_Get__sName(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective._sName.get called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        return Address_Null;
    }

    return LoadFromAddress(objective.addr + iObjectiveOffset[OFS_Objective__sName], NumberType_Int32);
}

static any Native_Objective_Get__sDescription(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective._sDescription.get called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        return Address_Null;
    }

    return LoadFromAddress(objective.addr + iObjectiveOffset[OFS_Objective__sDescription], NumberType_Int32);
}

static any Native_Objective_Get__pEntitysVector(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective._pEntitysVector.get called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        return Address_Null;
    }

    return UtlVector(objective.addr + iObjectiveOffset[OFS_Objective__pEntitysVector]);
}

static any Native_Objective_Get__iEntitysCount(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective._iEntitysCount.get called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        return 0;
    }

    return LoadFromAddress(objective.addr + iObjectiveOffset[OFS_Objective__iEntitysCount], NumberType_Int32);
}

static any Native_Objective_Get__pLinksVector(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective._pLinksVector.get called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        return Address_Null;
    }

    return UtlVector(objective.addr + iObjectiveOffset[OFS_Objective__pLinksVector]);
}

static any Native_Objective_Get__iLinksCount(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective._iLinksCount.get called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        return 0;
    }

    return LoadFromAddress(objective.addr + iObjectiveOffset[OFS_Objective__iLinksCount], NumberType_Int32);
}

static any Native_Objective_Get__bIsAntiObjective(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective._bIsAntiObjective.get called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        return false;
    }

    return LoadFromAddress(objective.addr + iObjectiveOffset[OFS_Objective__bIsAntiObjective], NumberType_Int8);
}

static any Native_Objective_Set__bIsAntiObjective(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective._bIsAntiObjective.set called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        return 0;
    }

    bool value = GetNativeCell(2);
    g_hLogger.DebugF("Param value %s.", value ? "true" : "false");
    StoreToAddress(objective.addr + iObjectiveOffset[OFS_Objective__bIsAntiObjective], value, NumberType_Int8);
    return 0;
}

static any Native_Objective_Get__sObjectiveBoundaryName(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective._sObjectiveBoundaryName.get called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        return Address_Null;
    }

    return LoadFromAddress(objective.addr + iObjectiveOffset[OFS_Objective__sObjectiveBoundaryName], NumberType_Int32);
}


static any Native_Objective_GetId(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective.GetId called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        return 0;
    }

    return objective.m_iId;
}

static int Native_Objective_GetName(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective.GetName called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        SetNativeString(2, "", 1);
        return 0;
    }

    Stringt name = objective._sName;
    if (name.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective._sName is null.");
        SetNativeString(2, "", 1);
        return 0;
    }

    int maxlen = GetNativeCell(3);
    if (maxlen <= 0)
    {
        g_hLogger.LogStackTraceF(LogLevel_Warn, "Invalid maxlen %d.", maxlen);
        SetNativeString(2, "", 1);
        return 0;
    }

    char[] buffer = new char[maxlen]; // 不需要扩容, 按照传入的最大长度限制写入
    name.ToCharArray(buffer, maxlen);

    int bytes;
    SetNativeString(2, buffer, maxlen, _, bytes);
    return bytes;
}

static int Native_Objective_GetDescription(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective.GetDescription called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        SetNativeString(2, "", 1);
        return 0;
    }

    Stringt description = objective._sDescription;
    if (description.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective._sDescription is null.");
        SetNativeString(2, "", 1);
        return 0;
    }

    int maxlen = GetNativeCell(3);
    if (maxlen <= 0)
    {
        g_hLogger.LogStackTraceF(LogLevel_Warn, "Invalid maxlen %d.", maxlen);
        SetNativeString(2, "", 1);
        return 0;
    }

    char[] buffer = new char[maxlen]; // 不需要扩容, 按照传入的最大长度限制写入
    description.ToCharArray(buffer, maxlen);

    int bytes;
    SetNativeString(2, buffer, maxlen, _, bytes);
    return bytes;
}

static any Native_Objective_ContainsEntity(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective.ContainsEntity called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        return false;
    }

    UtlVector entityVector = objective._pEntitysVector;
    if (entityVector.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective._pEntitysVector is null.");
        return false;
    }

    char entity[256];
    view_as<Stringt>(GetNativeCell(2)).ToCharArray(entity, sizeof(entity));
    g_hLogger.DebugF("Param entity %s.", entity);

    char buffer[256];
    int size = entityVector.size;
    for (int i = 0; i < size; ++i)
    {
        view_as<Stringt>(entityVector.Get(i)).ToCharArray(buffer, sizeof(buffer));
        g_hLogger.DebugF("element [%d/%d] %s.", i, size, buffer);

        if (strcmp(entity, buffer) == 0)
            return true;
    }

    return false;
}

static any Native_Objective_GetEntity(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective.GetEntity called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        return Address_Null;
    }

    UtlVector entityVector = objective._pEntitysVector;
    if (entityVector.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective._pEntitysVector is null.");
        return Address_Null;
    }

    int index = GetNativeCell(2);
    if (index < 0 || index >= entityVector.size)
    {
        g_hLogger.LogStackTraceF(LogLevel_Warn, "Invalid index %d. [0-%d)", index, entityVector.size);
        return Address_Null;
    }
    else
    {
        g_hLogger.DebugF("Param index %d.", index);
    }

    return entityVector.Get(index);
}

static any Native_Objective_GetEntityCount(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective.GetEntityCount called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        return 0;
    }

    return objective._iEntitysCount;
}

static any Native_Objective_GetEntityList(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective.GetEntityList called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        return INVALID_HANDLE;
    }

    UtlVector entityVector = objective._pEntitysVector;
    if (entityVector.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective._pEntitysVector is null.");
        return INVALID_HANDLE;
    }

    int size = entityVector.size;
    ArrayList result = new ArrayList();

    for (int i = 0; i < size; ++i)
    {
        Stringt entity = entityVector.Get(i);
        if (g_hLogger.ShouldLog(LogLevel_Debug))
        {
            char buffer[256];
            entity.ToCharArray(buffer, sizeof(buffer));
            g_hLogger.DebugF("element [%d/%d] %s.", i, size, buffer);
        }

        result.Push(entity);
    }

    return result;
}

static any Native_Objective_HasLink(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective.HasLink called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        return false;
    }

    UtlVector linksVector = objective._pLinksVector;
    if (linksVector.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective.linksVector is null.");
        return false;
    }

    int linkId = GetNativeCell(2);
    g_hLogger.DebugF("Param linkId %d.", linkId);

    int size = linksVector.size;
    for (int i = 0; i < size; ++i)
    {
        int id = linksVector.Get(i);
        g_hLogger.DebugF("element [%d/%d] %d.", i, size, id);

        if (id == linkId)
            return true;
    }

    return false;
}

static any Native_Objective_GetLink(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective.GetLink called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        return -1;
    }

    UtlVector linkVector = objective._pLinksVector;
    if (linkVector.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective._pLinksVector is null.");
        return -1;
    }

    int index = GetNativeCell(2);
    if (index < 0 || index >= linkVector.size)
    {
        g_hLogger.LogStackTraceF(LogLevel_Warn, "Invalid index %d. [0-%d)", index, linkVector.size);
        return -1;
    }
    else
    {
        g_hLogger.DebugF("Param index %d.", index);
    }

    return linkVector.Get(index);
}

static any Native_Objective_GetLinkCount(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective.GetLinkCount called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        return 0;
    }

    return objective._iLinksCount;
}

static any Native_Objective_IsEndObjective(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective.IsEndObjective called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        return false;
    }

    return objective._iLinksCount == 0;
}

static any Native_Objective_IsAntiObjective(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective.IsAntiObjective called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        return false;
    }

    return objective._bIsAntiObjective;
}

static any Native_Objective_GetObjectiveBoundaryName(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective.GetObjectiveBoundaryName called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        SetNativeString(2, "", 1);
        return 0;
    }

    Stringt objectiveBoundaryName = objective._sObjectiveBoundaryName;
    if (objectiveBoundaryName.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective._sObjectiveBoundaryName is null.");
        SetNativeString(2, "", 1);
        return 0;
    }


    int maxlen = GetNativeCell(3);
    if (maxlen <= 0)
    {
        g_hLogger.LogStackTraceF(LogLevel_Warn, "Invalid maxlen %d.", maxlen);
        SetNativeString(2, "", 1);
        return 0;
    }

    char[] buffer = new char[maxlen]; // 不需要扩容, 按照传入的最大长度限制写入
    objectiveBoundaryName.ToCharArray(buffer, maxlen);

    int bytes;
    SetNativeString(2, buffer, maxlen, _, bytes);
    return bytes;
}

static any Native_Objective_GetObjectiveBoundary(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective.GetObjectiveBoundary called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        return Address_Null;
    }

    ObjectiveBoundary objectiveBoundary = SDKCall(hObjevtiveHandle[HDL_Objective_GetObjectiveBoundary], objective.addr);
    return objectiveBoundary;
}

static any Native_Objective_UpdateBoundary(Handle plugin, int numParams)
{
    g_hLogger.Debug("Objective.UpdateBoundary called.");

    Objective objective = GetNativeCell(1);
    if (objective.IsNull())
    {
        g_hLogger.LogStackTrace(LogLevel_Warn, "Objective is null.");
        return 0;
    }

    SDKCall(hObjevtiveHandle[HDL_Objective_UpdateBoundary], objective.addr);
    return 0;
}
