#pragma newdecls required
#pragma semicolon 1

enum
{
    HDL_ObjectiveBoundary_Start,
    HDL_ObjectiveBoundary_Finish,
    HDL_ObjectiveBoundary_Total
}

static Handle hObjectiveBoundaryHandle[HDL_ObjectiveBoundary_Total];


void LoadObjectiveBoundaryNative()
{
    CreateNative("ObjectiveBoundary.Start", Native_ObjectiveBoundary_Start);
    CreateNative("ObjectiveBoundary.Finish", Native_ObjectiveBoundary_Finish);
}

void LoadObjectiveBoundarySignature(GameData gamedata)
{
    if (g_OS == OS_Linux)
    {
        StartPrepSDKCall(SDKCall_Raw);
        PrepSDKCall_SetFromConf(gamedata, SDKConf_Signature, "CNMRiH_ObjectiveBoundary::Start");
        if ((hObjectiveBoundaryHandle[HDL_ObjectiveBoundary_Start] = EndPrepSDKCall()) == INVALID_HANDLE)
            SetFailState("Failed to load signature CNMRiH_ObjectiveBoundary::Start.");
    }

    StartPrepSDKCall(SDKCall_Raw);
    PrepSDKCall_SetFromConf(gamedata, SDKConf_Signature, "CNMRiH_ObjectiveBoundary::Finish");
    if ((hObjectiveBoundaryHandle[HDL_ObjectiveBoundary_Finish] = EndPrepSDKCall()) == INVALID_HANDLE)
        SetFailState("Failed to load signature CNMRiH_ObjectiveBoundary::Finish.");
}


static void Native_ObjectiveBoundary_Start(Handle plugin, int numParams)
{
    if (g_OS == OS_Linux)
    {
        ObjectiveBoundary objectiveBoundary = GetNativeCell(1);
        if (objectiveBoundary.IsNull())
            ThrowNativeError(SP_ERROR_PARAM, "ObjectiveBoundary instance is null.");

        SDKCall(hObjectiveBoundaryHandle[HDL_ObjectiveBoundary_Start], objectiveBoundary.addr);
    }
    else
    {
        ThrowNativeError(SP_ERROR_NOT_RUNNABLE, "CNMRiH_ObjectiveBoundary::Start() only support on linux.");
    }
}

static void Native_ObjectiveBoundary_Finish(Handle plugin, int numParams)
{
    ObjectiveBoundary objectiveBoundary = GetNativeCell(1);
    if (objectiveBoundary.IsNull())
        ThrowNativeError(SP_ERROR_INVALID_ADDRESS, "ObjectiveBoundary instance is null.");

    SDKCall(hObjectiveBoundaryHandle[HDL_ObjectiveBoundary_Finish], objectiveBoundary.addr);
}
