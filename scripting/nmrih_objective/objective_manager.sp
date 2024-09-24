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
    OFS_ObjectiveManager__sCurrentObjectiveBoundary,
    OFS_ObjectiveManager__pCurrentObjective,
    OFS_ObjectiveManager_Total
};

enum    // Signature
{
    HDL_ObjectiveManager_CompleteCurrentObjective,
    HDL_ObjectiveManager_GetObjectiveById,
    // HDL_ObjectiveManager_GetObjectiveByIndex, // * Note: 由于找不到 windows sig, 所以改用 sp 模拟内部逻辑来实现
    HDL_ObjectiveManager_GetObjectiveByName,
    HDL_ObjectiveManager_StartNextObjective,
    HDL_ObjectiveManager_Total
}

static Address ObjectiveManagerAddress;
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
    CreateNative("ObjectiveManager._sCurrentObjectiveBoundary.get", Native_ObjectiveManager_Get__sCurrentObjectiveBoundary);
    CreateNative("ObjectiveManager._pCurrentObjective.get", Native_ObjectiveManager_Get__pCurrentObjective);
    CreateNative("ObjectiveManager._pCurrentObjective.set", Native_ObjectiveManager_Set__pCurrentObjective);
    CreateNative("ObjectiveManager.CompleteCurrentObjective", Native_ObjectiveManager_CompleteCurrentObjective);
    CreateNative("ObjectiveManager.GetCurrentObjectiveBoundary", Native_ObjectiveManager_GetCurrentObjectiveBoundary);
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
}

void LoadObjectiveManagerAddress(GameData gamedata)
{
    ObjectiveManagerAddress = gamedata.GetAddress("CNMRiH_ObjectiveManager");
    if (!ObjectiveManagerAddress)
        SetFailState("Failed to load address CNMRiH_ObjectiveManager");
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
    LoadOffset(gamedata, "CNMRiH_ObjectiveManager::_sCurrentObjectiveBoundary", OFS_ObjectiveManager__sCurrentObjectiveBoundary);
    LoadOffset(gamedata, "CNMRiH_ObjectiveManager::_pCurrentObjective", OFS_ObjectiveManager__pCurrentObjective);
}

static void LoadOffset(GameData gamedata, const char[] key, int index)
{
    if (index <0 || index >= OFS_ObjectiveManager_Total)
        SetFailState("Invalid iObjectiveManagerOffset index %d", index);

    int offset = gamedata.GetOffset(key);
    if (offset == -1)
        SetFailState("Failed to load offset %s", key);

    iObjectiveManagerOffset[index] = offset;
}

void LoadObjectiveManagerSignature(GameData gamedata)
{
    StartPrepSDKCall(SDKCall_Raw);
    PrepSDKCall_SetFromConf(gamedata, SDKConf_Signature, "CNMRiH_ObjectiveManager::CompleteCurrentObjective");
    PrepSDKCall_AddParameter(SDKType_String, SDKPass_Pointer);
    if ((hObjevtiveManagerHandle[HDL_ObjectiveManager_CompleteCurrentObjective] = EndPrepSDKCall()) == INVALID_HANDLE)
        SetFailState("Failed to load signature CNMRiH_ObjectiveManager::CompleteCurrentObjective");

    StartPrepSDKCall(SDKCall_Raw);
    PrepSDKCall_SetFromConf(gamedata, SDKConf_Signature, "CNMRiH_ObjectiveManager::GetObjectiveById");
    PrepSDKCall_SetReturnInfo(SDKType_PlainOldData, SDKPass_Plain);
    PrepSDKCall_AddParameter(SDKType_PlainOldData, SDKPass_Plain);
    if ((hObjevtiveManagerHandle[HDL_ObjectiveManager_GetObjectiveById] = EndPrepSDKCall()) == INVALID_HANDLE)
        SetFailState("Failed to load signature CNMRiH_ObjectiveManager::GetObjectiveById");

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
        SetFailState("Failed to load signature CNMRiH_ObjectiveManager::GetObjectiveByName");

    StartPrepSDKCall(SDKCall_Raw);
    PrepSDKCall_SetFromConf(gamedata, SDKConf_Signature, "CNMRiH_ObjectiveManager::StartNextObjective");
    if ((hObjevtiveManagerHandle[HDL_ObjectiveManager_StartNextObjective] = EndPrepSDKCall()) == INVALID_HANDLE)
        SetFailState("Failed to load signature CNMRiH_ObjectiveManager::StartNextObjective");
}


static any Native_ObjectiveManager_Instance(Handle plugin, int numParams)
{
    if (!ObjectiveManagerAddress)
        ThrowNativeError(SP_ERROR_NATIVE, "Invalid objective manager 0x%x", ObjectiveManagerAddress);

    return view_as<ObjectiveManager>(ObjectiveManagerAddress);
}

static any Native_ObjectiveManager_Get__pObjectivesVector(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (!objectiveManager)
        ThrowNativeError(SP_ERROR_PARAM, "Invalid objective manager 0x%x", objectiveManager);

    return UtlVector(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__pObjectivesVector]);
}

static any Native_ObjectiveManager_Get__iObjectivesCount(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (!objectiveManager)
        ThrowNativeError(SP_ERROR_PARAM, "Invalid objective manager 0x%x", objectiveManager);

    return LoadFromAddress(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__iObjectivesCount], NumberType_Int32);
}

static any Native_ObjectiveManager_Get__pObjectiveChainVector(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (!objectiveManager)
        ThrowNativeError(SP_ERROR_PARAM, "Invalid objective manager 0x%x", objectiveManager);

    return UtlVector(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__pObjectiveChainVector]);
}

static any Native_ObjectiveManager_Get__iObjectiveChainCount(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (!objectiveManager)
        ThrowNativeError(SP_ERROR_PARAM, "Invalid objective manager 0x%x", objectiveManager);

    return LoadFromAddress(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__iObjectiveChainCount], NumberType_Int32);
}

static any Native_ObjectiveManager_Get__bIsCompleted(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (!objectiveManager)
        ThrowNativeError(SP_ERROR_PARAM, "Invalid objective manager 0x%x", objectiveManager);

    return LoadFromAddress(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__bIsCompleted], NumberType_Int8);
}

static any Native_ObjectiveManager_Set__bIsCompleted(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (!objectiveManager)
        ThrowNativeError(SP_ERROR_PARAM, "Invalid objective manager 0x%x", objectiveManager);

    bool value = GetNativeCell(2);
    StoreToAddress(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__bIsCompleted], value, NumberType_Int8);
    return true;
}

static any Native_ObjectiveManager_Get__bIsFailed(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (!objectiveManager)
        ThrowNativeError(SP_ERROR_PARAM, "Invalid objective manager 0x%x", objectiveManager);

    return LoadFromAddress(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__bIsFailed], NumberType_Int8);
}

static any Native_ObjectiveManager_Set__bIsFailed(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (!objectiveManager)
        ThrowNativeError(SP_ERROR_PARAM, "Invalid objective manager 0x%x", objectiveManager);

    bool value = GetNativeCell(2);
    StoreToAddress(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__bIsFailed], value, NumberType_Int8);
    return true;
}

static any Native_ObjectiveManager_Get__iCurrentObjectiveIndex(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (!objectiveManager)
        ThrowNativeError(SP_ERROR_PARAM, "Invalid objective manager 0x%x", objectiveManager);

    return LoadFromAddress(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__iCurrentObjectiveIndex], NumberType_Int32);
}

static any Native_ObjectiveManager_Set__iCurrentObjectiveIndex(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (!objectiveManager)
        ThrowNativeError(SP_ERROR_PARAM, "Invalid objective manager 0x%x", objectiveManager);

    int value = GetNativeCell(2);
    StoreToAddress(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__iCurrentObjectiveIndex], value, NumberType_Int32);
    return true;
}

static any Native_ObjectiveManager_Get__sCurrentObjectiveBoundary(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (!objectiveManager)
        ThrowNativeError(SP_ERROR_PARAM, "Invalid objective manager 0x%x", objectiveManager);

    return LoadFromAddress(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__sCurrentObjectiveBoundary], NumberType_Int32);
}

static any Native_ObjectiveManager_Get__pCurrentObjective(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (!objectiveManager)
        ThrowNativeError(SP_ERROR_PARAM, "Invalid objective manager 0x%x", objectiveManager);

    return LoadFromAddress(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__pCurrentObjective], NumberType_Int32);
}

static any Native_ObjectiveManager_Set__pCurrentObjective(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (!objectiveManager)
        ThrowNativeError(SP_ERROR_PARAM, "Invalid objective manager 0x%x", objectiveManager);

    Objective value = GetNativeCell(2);
    StoreToAddress(objectiveManager.addr + iObjectiveManagerOffset[OFS_ObjectiveManager__pCurrentObjective], value, NumberType_Int32);
    return true;
}

static any Native_ObjectiveManager_CompleteCurrentObjective(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (!objectiveManager)
        ThrowNativeError(SP_ERROR_PARAM, "Invalid objective manager 0x%x", objectiveManager);

    int maxlen;
    GetNativeStringLength(2, maxlen);       // 获取传入的字符串长度
    char[] targetname = new char[++maxlen]; // 需要增加一位用于存储 '\0'
    GetNativeString(2, targetname, maxlen); // 读取传入的字符串

    return SDKCall(hObjevtiveManagerHandle[HDL_ObjectiveManager_CompleteCurrentObjective], objectiveManager.addr, targetname);
}

static any Native_ObjectiveManager_GetCurrentObjectiveBoundary(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    Stringt currentObjectiveBoundary = objectiveManager._sCurrentObjectiveBoundary;
    if (!currentObjectiveBoundary) // 非任务进行时
    {
        SetNativeString(2, "", 1);
        return false;
    }

    int     maxlen = GetNativeCell(3);
    char[]  buffer = new char[maxlen]; // 不需要扩容, 按照传入的最大长度限制写入
    currentObjectiveBoundary.ToCharArray(buffer, maxlen);
    SetNativeString(2, buffer, maxlen);
    return true;
}

static any Native_ObjectiveManager_GetCurrentObjectiveIndex(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    return objectiveManager._iCurrentObjectiveIndex;
}

static any Native_ObjectiveManager_GetObjectiveById(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (!objectiveManager)
        ThrowNativeError(SP_ERROR_PARAM, "Invalid objective manager 0x%x", objectiveManager);

    int id = GetNativeCell(2);
    return SDKCall(hObjevtiveManagerHandle[HDL_ObjectiveManager_GetObjectiveById], objectiveManager.addr, id);
}

static any Native_ObjectiveManager_GetObjectiveByIndex(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    UtlVector objectiveVector = objectiveManager._pObjectivesVector;
    if (!objectiveVector)
        ThrowNativeError(SP_ERROR_NATIVE, "Invalid objectiv vector 0x%x", objectiveVector);

    int index = GetNativeCell(2);
    return objectiveVector.Get(index); // UtlVector 会检查 index
}

static any Native_ObjectiveManager_GetObjectiveByName(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (!objectiveManager)
        ThrowNativeError(SP_ERROR_PARAM, "Invalid objective manager 0x%x", objectiveManager);

    int maxlen;
    GetNativeStringLength(2, maxlen); // 获取传入的字符串长度
    char[] name = new char[++maxlen]; // 需要增加一位用于存储 '\0'
    GetNativeString(2, name, maxlen);

    return SDKCall(hObjevtiveManagerHandle[HDL_ObjectiveManager_GetObjectiveByName], objectiveManager.addr, name);
}

static any Native_ObjectiveManager_GetObjectiveChain(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    ArrayList objectiveChain = GetNativeCell(2);
    if (!objectiveChain)
        ThrowNativeError(SP_ERROR_PARAM, "Invalid objectiveChain handle 0x%x", objectiveChain);

    UtlVector objectiveChainVector = objectiveManager._pObjectiveChainVector;
    if (!objectiveChainVector)
        return false;

    int objectiveChainCount = objectiveChainVector.size;
    if (objectiveChainCount <= 0)
        return false;

    for (int i=0; i < objectiveChainCount; ++i)
    {
        int id = objectiveChainVector.Get(i);
        Objective objectiveById = objectiveManager.GetObjectiveById(id);
        if (objectiveById)
        {
            objectiveChain.Push(objectiveById);
        }
    }
    return true;
}

static any Native_ObjectiveManager_GetObjectiveChainCount(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    return objectiveManager._iObjectiveChainCount;
}

static any Native_ObjectiveManager_GetObjectiveCount(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    return objectiveManager._iObjectivesCount;
}

static any Native_ObjectiveManager_IsCompleted(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    return objectiveManager._bIsCompleted;
}

static any Native_ObjectiveManager_IsFailed(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    return objectiveManager._bIsFailed;
}

static any Native_ObjectiveManager_StartNextObjective(Handle plugin, int numParams)
{
    ObjectiveManager objectiveManager = GetNativeCell(1);
    if (!objectiveManager)
        ThrowNativeError(SP_ERROR_PARAM, "Invalid objective manager 0x%x", objectiveManager);

    return SDKCall(hObjevtiveManagerHandle[HDL_ObjectiveManager_StartNextObjective], objectiveManager.addr);
}
