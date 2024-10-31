#pragma newdecls required
#pragma semicolon 1

enum    // Offset
{
    OFS_ObjectiveManager__pObjectivesVector,
    OFS_ObjectiveManager__iObjectivesCount,
    // OFS_ObjectiveManager__pAntiObjectiveVector, // 暂时用不到, 逆向工程里也没有提供相关的 API
    // OFS_ObjectiveManager__iAntiObjectiveCount,
    OFS_ObjectiveManager__pObjectiveChainVector,
    OFS_ObjectiveManager__iObjectiveChainCount,
    OFS_ObjectiveManager__bIsCompleted,
    OFS_ObjectiveManager__bIsFailed,
    OFS_ObjectiveManager__iCurrentObjectiveIndex,
    OFS_ObjectiveManager__pCurrentObjective,
    OFS_ObjectiveManager_Total
};

enum    // Signature
{
    HDL_ObjectiveManager_CompleteCurrentObjective,
    HDL_ObjectiveManager_Clear,
    HDL_ObjectiveManager_Finish,
    HDL_ObjectiveManager_GetObjectiveById,
    // HDL_ObjectiveManager_GetObjectiveByIndex, // * Note: 由于找不到 windows sig, 所以改用 sp 模拟内部逻辑来实现
    HDL_ObjectiveManager_GetObjectiveByName,
    HDL_ObjectiveManager_StartNextObjective,
    HDL_ObjectiveManager_UpdateObjectiveBoundaries,
    HDL_ObjectiveManager_Total
}

static Address g_pObjectiveManager;
static int     iObjectiveManagerOffset[OFS_ObjectiveManager_Total];
static Handle  hObjevtiveManagerHandle[HDL_ObjectiveManager_Total];


void LoadObjectiveManagerNative()
{
    CreateNative("ObjectiveManager.Instance", Native_ObjectiveManager_Instance);
    CreateNative("ObjectiveManager._pObjectivesVector.get", Native_ObjectiveManager_Get__pObjectivesVector);
    CreateNative("ObjectiveManager._iObjectivesCount.get", Native_ObjectiveManager_Get__iObjectivesCount);
    CreateNative("ObjectiveManager._pObjectiveChainVector.get", Native_ObjectiveManager_Get__pObjectiveChainVector);
    CreateNative("ObjectiveManager._iObjectiveChainCount.get", Native_ObjectiveManager_Get__iObjectiveChainCount);
    CreateNative("ObjectiveManager._bIsCompleted.get", Native_ObjectiveManager_Get__bIsCompleted);
    CreateNative("ObjectiveManager._bIsCompleted.set", Native_ObjectiveManager_Set__bIsCompleted);
    CreateNative("ObjectiveManager._bIsFailed.get", Native_ObjectiveManager_Get__bIsFailed);
    CreateNative("ObjectiveManager._bIsFailed.set", Native_ObjectiveManager_Set__bIsFailed);
    CreateNative("ObjectiveManager._iCurrentObjectiveIndex.get", Native_ObjectiveManager_Get__iCurrentObjectiveIndex);
    CreateNative("ObjectiveManager._iCurrentObjectiveIndex.set", Native_ObjectiveManager_Set__iCurrentObjectiveIndex);
    CreateNative("ObjectiveManager._pCurrentObjective.get", Native_ObjectiveManager_Get__pCurrentObjective);
    CreateNative("ObjectiveManager._pCurrentObjective.set", Native_ObjectiveManager_Set__pCurrentObjective);
    CreateNative("ObjectiveManager.CompleteCurrentObjective", Native_ObjectiveManager_CompleteCurrentObjective);
    CreateNative("ObjectiveManager.GetCurrentObjectiveBoundary", Native_ObjectiveManager_GetCurrentObjectiveBoundary);
    CreateNative("ObjectiveManager.Clear", Native_ObjectiveManager_Clear);
    CreateNative("ObjectiveManager.Finish", Native_ObjectiveManager_Finish);
    CreateNative("ObjectiveManager.GetCurrentObjective", Native_ObjectiveManager_GetCurrentObjective);
    CreateNative("ObjectiveManager.GetCurrentObjectiveIndex", Native_ObjectiveManager_GetCurrentObjectiveIndex);
    CreateNative("ObjectiveManager.GetObjectiveById", Native_ObjectiveManager_GetObjectiveById);
    CreateNative("ObjectiveManager.GetObjectiveByIndex", Native_ObjectiveManager_GetObjectiveByIndex);
    CreateNative("ObjectiveManager.GetObjectiveByName", Native_ObjectiveManager_GetObjectiveByName);
    CreateNative("ObjectiveManager.GetObjectiveChain", Native_ObjectiveManager_GetObjectiveChain);
    CreateNative("ObjectiveManager.GetObjectiveChainCount", Native_ObjectiveManager_GetObjectiveChainCount);
    CreateNative("ObjectiveManager.GetObjectiveCount", Native_ObjectiveManager_GetObjectiveCount);
    CreateNative("ObjectiveManager.IsCompleted", Native_ObjectiveManager_IsCompleted);
    CreateNative("ObjectiveManager.IsFailed", Native_ObjectiveManager_IsFailed);
    CreateNative("ObjectiveManager.StartNextObjective", Native_ObjectiveManager_StartNextObjective);
    CreateNative("ObjectiveManager.UpdateObjectiveBoundaries", Native_ObjectiveManager_UpdateObjectiveBoundaries);
    CreateNative("ObjectiveManager.FailCurrentObjective", Native_ObjectiveManager_FailCurrentObjective);
}

void LoadObjectiveManagerAddress(GameData gamedata)
{
    g_pObjectiveManager = gamedata.GetAddress("CNMRiH_ObjectiveManager");
    if (g_pObjectiveManager == Address_Null)
        SetFailState("Failed to load address CNMRiH_ObjectiveManager.");
}

void LoadObjectiveManagerOffset(GameData gamedata)
{
    LoadOffset(gamedata, "CNMRiH_ObjectiveManager::_pObjectivesVector", OFS_ObjectiveManager__pObjectivesVector);
    LoadOffset(gamedata, "CNMRiH_ObjectiveManager::_iObjectivesCount", OFS_ObjectiveManager__iObjectivesCount);
    // LoadOffset(gamedata, "CNMRiH_ObjectiveManager::_pAntiObjectiveVector", OFS_ObjectiveManager__pAntiObjectiveVector);
    // LoadOffset(gamedata, "CNMRiH_ObjectiveManager::_iAntiObjectiveCount", OFS_ObjectiveManager__iAntiObjectiveCount);
    LoadOffset(gamedata, "CNMRiH_ObjectiveManager::_pObjectiveChainVector", OFS_ObjectiveManager__pObjectiveChainVector);
    LoadOffset(gamedata, "CNMRiH_ObjectiveManager::_iObjectiveChainCount", OFS_ObjectiveManager__iObjectiveChainCount);
    LoadOffset(gamedata, "CNMRiH_ObjectiveManager::_bIsCompleted", OFS_ObjectiveManager__bIsCompleted);
    LoadOffset(gamedata, "CNMRiH_ObjectiveManager::_bIsFailed", OFS_ObjectiveManager__bIsFailed);
    LoadOffset(gamedata, "CNMRiH_ObjectiveManager::_iCurrentObjectiveIndex", OFS_ObjectiveManager__iCurrentObjectiveIndex);
    LoadOffset(gamedata, "CNMRiH_ObjectiveManager::_pCurrentObjective", OFS_ObjectiveManager__pCurrentObjective);
}

static void LoadOffset(GameData gamedata, const char[] key, int index)
{
    if (index <0 || index >= OFS_ObjectiveManager_Total)
        SetFailState("Invalid iObjectiveManagerOffset index %d.", index);

    int offset = gamedata.GetOffset(key);
    if (offset == -1)
        SetFailState("Failed to load offset %s.", key);

    iObjectiveManagerOffset[index] = offset;
}

void LoadObjectiveManagerSignature(GameData gamedata)
{
    StartPrepSDKCall(SDKCall_Raw);
    PrepSDKCall_SetFromConf(gamedata, SDKConf_Signature, "CNMRiH_ObjectiveManager::CompleteCurrentObjective");
    PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
    if ((hObjevtiveManagerHandle[HDL_ObjectiveManager_CompleteCurrentObjective] = EndPrepSDKCall()) == INVALID_HANDLE)
        SetFailState("Failed to load signature CNMRiH_ObjectiveManager::CompleteCurrentObjective.");

    StartPrepSDKCall(SDKCall_Raw);
    PrepSDKCall_SetFromConf(gamedata, SDKConf_Signature, "CNMRiH_ObjectiveManager::Clear");
    if ((hObjevtiveManagerHandle[HDL_ObjectiveManager_Clear] = EndPrepSDKCall()) == INVALID_HANDLE)
        SetFailState("Failed to load signature CNMRiH_ObjectiveManager::Clear.");

    if (g_OS == OS_Linux)
    {
        StartPrepSDKCall(SDKCall_Raw);
        PrepSDKCall_SetFromConf(gamedata, SDKConf_Signature, "CNMRiH_ObjectiveManager::Finish");
        if ((hObjevtiveManagerHandle[HDL_ObjectiveManager_Finish] = EndPrepSDKCall()) == INVALID_HANDLE)
            SetFailState("Failed to load signature CNMRiH_ObjectiveManager::Finish.");
    }

    StartPrepSDKCall(SDKCall_Raw);
    PrepSDKCall_SetFromConf(gamedata, SDKConf_Signature, "CNMRiH_ObjectiveManager::GetObjectiveById");
    PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
    PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
    if ((hObjevtiveManagerHandle[HDL_ObjectiveManager_GetObjectiveById] = EndPrepSDKCall()) == INVALID_HANDLE)
        SetFailState("Failed to load signature CNMRiH_ObjectiveManager::GetObjectiveById.");

    // StartPrepSDKCall(SDKCall_Raw);
    // PrepSDKCall_SetFromConf(gamedata, SDKConf_Signature, "CNMRiH_ObjectiveManager::GetObjectiveByIndex");
    // PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
    // PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
    // if ((hObjevtiveManagerHandle[HDL_ObjectiveManager_GetObjectiveByIndex] = EndPrepSDKCall()) == INVALID_HANDLE)
    //     SetFailState("Failed to load signature CNMRiH_ObjectiveManager::GetObjectiveByIndex");

    StartPrepSDKCall(SDKCall_Raw);
    PrepSDKCall_SetFromConf(gamedata, SDKConf_Signature, "CNMRiH_ObjectiveManager::GetObjectiveByName");
    PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
    PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
    if ((hObjevtiveManagerHandle[HDL_ObjectiveManager_GetObjectiveByName] = EndPrepSDKCall()) == INVALID_HANDLE)
        SetFailState("Failed to load signature CNMRiH_ObjectiveManager::GetObjectiveByName.");

    StartPrepSDKCall(SDKCall_Raw);
    PrepSDKCall_SetFromConf(gamedata, SDKConf_Signature, "CNMRiH_ObjectiveManager::StartNextObjective");
    if ((hObjevtiveManagerHandle[HDL_ObjectiveManager_StartNextObjective] = EndPrepSDKCall()) == INVALID_HANDLE)
        SetFailState("Failed to load signature CNMRiH_ObjectiveManager::StartNextObjective.");

    StartPrepSDKCall(SDKCall_Raw);
    PrepSDKCall_SetFromConf(gamedata, SDKConf_Signature, "CNMRiH_ObjectiveManager::UpdateObjectiveBoundaries");
    if ((hObjevtiveManagerHandle[HDL_ObjectiveManager_UpdateObjectiveBoundaries] = EndPrepSDKCall()) == INVALID_HANDLE)
        SetFailState("Failed to load signature CNMRiH_ObjectiveManager::UpdateObjectiveBoundaries.");
}


static any Native_ObjectiveManager_Instance(Handle plugin, int numParams)
{
    return g_pObjectiveManager;
}

static any Native_ObjectiveManager_Get__pObjectivesVector(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (objectiveManager.IsNull())
        ThrowNativeError(SP_ERROR_INVALID_ADDRESS, "ObjectiveManager instance is null.");

    return UtlVector(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__pObjectivesVector]);
}

static any Native_ObjectiveManager_Get__iObjectivesCount(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (objectiveManager.IsNull())
        ThrowNativeError(SP_ERROR_INVALID_ADDRESS, "ObjectiveManager instance is null.");

    return LoadFromAddress(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__iObjectivesCount], NumberType_Int32);
}

static any Native_ObjectiveManager_Get__pObjectiveChainVector(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (objectiveManager.IsNull())
        ThrowNativeError(SP_ERROR_INVALID_ADDRESS, "ObjectiveManager instance is null.");

    return UtlVector(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__pObjectiveChainVector]);
}

static any Native_ObjectiveManager_Get__iObjectiveChainCount(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (objectiveManager.IsNull())
        ThrowNativeError(SP_ERROR_INVALID_ADDRESS, "ObjectiveManager instance is null.");

    return LoadFromAddress(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__iObjectiveChainCount], NumberType_Int32);
}

static any Native_ObjectiveManager_Get__bIsCompleted(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (objectiveManager.IsNull())
        ThrowNativeError(SP_ERROR_INVALID_ADDRESS, "ObjectiveManager instance is null.");

    return LoadFromAddress(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__bIsCompleted], NumberType_Int8);
}

static void Native_ObjectiveManager_Set__bIsCompleted(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (objectiveManager.IsNull())
        ThrowNativeError(SP_ERROR_INVALID_ADDRESS, "ObjectiveManager instance is null.");

    bool value = GetNativeCell(2);
    StoreToAddress(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__bIsCompleted], value, NumberType_Int8);
}

static any Native_ObjectiveManager_Get__bIsFailed(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (objectiveManager.IsNull())
        ThrowNativeError(SP_ERROR_INVALID_ADDRESS, "ObjectiveManager instance is null.");

    return LoadFromAddress(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__bIsFailed], NumberType_Int8);
}

static void Native_ObjectiveManager_Set__bIsFailed(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (objectiveManager.IsNull())
        ThrowNativeError(SP_ERROR_INVALID_ADDRESS, "ObjectiveManager instance is null.");

    bool value = GetNativeCell(2);
    StoreToAddress(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__bIsFailed], value, NumberType_Int8);
}

static any Native_ObjectiveManager_Get__iCurrentObjectiveIndex(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (objectiveManager.IsNull())
        ThrowNativeError(SP_ERROR_INVALID_ADDRESS, "ObjectiveManager instance is null.");

    return LoadFromAddress(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__iCurrentObjectiveIndex], NumberType_Int32);
}

static void Native_ObjectiveManager_Set__iCurrentObjectiveIndex(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (objectiveManager.IsNull())
        ThrowNativeError(SP_ERROR_INVALID_ADDRESS, "ObjectiveManager instance is null.");

    int value = GetNativeCell(2);
    StoreToAddress(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__iCurrentObjectiveIndex], value, NumberType_Int32);
}

static any Native_ObjectiveManager_Get__pCurrentObjective(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (objectiveManager.IsNull())
        ThrowNativeError(SP_ERROR_INVALID_ADDRESS, "ObjectiveManager instance is null.");

    return LoadFromAddress(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__pCurrentObjective], NumberType_Int32);
}

static void Native_ObjectiveManager_Set__pCurrentObjective(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (objectiveManager.IsNull())
        ThrowNativeError(SP_ERROR_INVALID_ADDRESS, "ObjectiveManager instance is null.");

    Objective value = GetNativeCell(2);
    StoreToAddress(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__pCurrentObjective], value, NumberType_Int32);
}

static void Native_ObjectiveManager_CompleteCurrentObjective(Handle plugin, int numParams)
{
    int maxlen;
    GetNativeStringLength(1, maxlen);       // 获取传入的字符串长度
    char[] targetname = new char[++maxlen]; // 需要增加一位用于存储 '\0'
    GetNativeString(1, targetname, maxlen); // 读取传入的字符串

    SDKCall(hObjevtiveManagerHandle[HDL_ObjectiveManager_CompleteCurrentObjective], g_pObjectiveManager, targetname);
}

static any Native_ObjectiveManager_GetCurrentObjectiveBoundary(Handle plugin, int numParams)
{
    Objective currentObjective = ObjectiveManager.GetCurrentObjective();
    return currentObjective.GetObjectiveBoundary();
}

static void Native_ObjectiveManager_Clear(Handle plugin, int numParams)
{
    SDKCall(hObjevtiveManagerHandle[HDL_ObjectiveManager_Clear], g_pObjectiveManager);
}

static void Native_ObjectiveManager_Finish(Handle plugin, int numParams)
{
    if (g_OS == OS_Linux)
    {
        SDKCall(hObjevtiveManagerHandle[HDL_ObjectiveManager_Finish], g_pObjectiveManager);
    }
    else
    {
        ThrowNativeError(SP_ERROR_NOT_RUNNABLE, "ObjectiveManager::Finish() only support on linux.");
    }
}

static any Native_ObjectiveManager_GetCurrentObjective(Handle plugin, int numParams)
{
    // 参考自 CNMRiH_ObjectiveManager::ScriptGetObjectiveByIndex 的逆向
    ObjectiveManager objectiveManager = ObjectiveManager.Instance();
    int index = objectiveManager._iCurrentObjectiveIndex;
    int count = objectiveManager._iObjectivesCount;
    if (index < 0 || index >= count)
        ThrowNativeError(SP_ERROR_NATIVE, "Invalid objective index (%d) [0-%d].", index, count);

    UtlVector chain = objectiveManager._pObjectiveChainVector;
    if (chain.IsNull())
        ThrowNativeError(SP_ERROR_NATIVE, "ObjectiveManager._pObjectivesVector is null.");

    return chain.Get(index);
}

static any Native_ObjectiveManager_GetCurrentObjectiveIndex(Handle plugin, int numParams)
{
    return ObjectiveManager.Instance()._iCurrentObjectiveIndex;
}

static any Native_ObjectiveManager_GetObjectiveById(Handle plugin, int numParams)
{
    int id = GetNativeCell(1);
    return SDKCall(hObjevtiveManagerHandle[HDL_ObjectiveManager_GetObjectiveById], g_pObjectiveManager, id);
}

static any Native_ObjectiveManager_GetObjectiveByIndex(Handle plugin, int numParams)
{
    UtlVector objectiveVector = ObjectiveManager.Instance()._pObjectivesVector;
    if (objectiveVector.IsNull())
        ThrowNativeError(SP_ERROR_INVALID_ADDRESS, "ObjectiveManager._pObjectivesVector is null.");

    int index = GetNativeCell(2);
    return objectiveVector.Get(index); // UtlVector 会检查 index
}

static any Native_ObjectiveManager_GetObjectiveByName(Handle plugin, int numParams)
{
    int maxlen;
    GetNativeStringLength(1, maxlen); // 获取传入的字符串长度
    char[] name = new char[++maxlen]; // 需要增加一位用于存储 '\0'
    GetNativeString(1, name, maxlen);

    return SDKCall(hObjevtiveManagerHandle[HDL_ObjectiveManager_GetObjectiveByName], g_pObjectiveManager, name);
}

static any Native_ObjectiveManager_GetObjectiveChain(Handle plugin, int numParams)
{
    UtlVector objectiveChainVector = ObjectiveManager.Instance()._pObjectiveChainVector;
    if (objectiveChainVector.IsNull())
        ThrowNativeError(SP_ERROR_INVALID_ADDRESS, "ObjectiveManager._pObjectivesVector is null.");

    int objectiveChainCount = objectiveChainVector.size;
    ArrayList objectiveChain = new ArrayList();

    for (int i=0; i < objectiveChainCount; ++i)
    {
        int id = objectiveChainVector.Get(i);
        Objective objectiveById = ObjectiveManager.GetObjectiveById(id);
        if (objectiveById)
        {
            objectiveChain.Push(objectiveById);
        }
    }
    return objectiveChain;
}

static any Native_ObjectiveManager_GetObjectiveChainCount(Handle plugin, int numParams)
{
    return ObjectiveManager.Instance()._iObjectiveChainCount;
}

static any Native_ObjectiveManager_GetObjectiveCount(Handle plugin, int numParams)
{
    return ObjectiveManager.Instance()._iObjectivesCount;
}

static any Native_ObjectiveManager_IsCompleted(Handle plugin, int numParams)
{
    return ObjectiveManager.Instance()._bIsCompleted;
}

static any Native_ObjectiveManager_IsFailed(Handle plugin, int numParams)
{
    return ObjectiveManager.Instance()._bIsFailed;
}

static void Native_ObjectiveManager_StartNextObjective(Handle plugin, int numParams)
{
    SDKCall(hObjevtiveManagerHandle[HDL_ObjectiveManager_StartNextObjective], g_pObjectiveManager);
}

static void Native_ObjectiveManager_UpdateObjectiveBoundaries(Handle plugin, int numParams)
{
    SDKCall(hObjevtiveManagerHandle[HDL_ObjectiveManager_UpdateObjectiveBoundaries], g_pObjectiveManager);
}

static void Native_ObjectiveManager_FailCurrentObjective(Handle plugin, int numParams)
{
    ObjectiveManager.Instance()._bIsFailed = true;
}
