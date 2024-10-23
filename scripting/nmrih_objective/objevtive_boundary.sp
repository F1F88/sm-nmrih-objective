#pragma newdecls required
#pragma semicolon 1

enum
{
    // HDL_ObjectiveBoundary_Start,
    HDL_ObjectiveBoundary_Finish,
    HDL_ObjectiveBoundary_Total
}

static Handle hObjectiveBoundaryHandle[HDL_ObjectiveBoundary_Total];


void LoadObjectiveBoundaryNative()
{
    // CreateNative("ObjectiveBoundary.Start", Native_ObjectiveBoundary_Start);
    CreateNative("ObjectiveBoundary.Finish", Native_ObjectiveBoundary_Finish);
}

void LoadObjectiveBoundarySignature(GameData gamedata)
{
    // StartPrepSDKCall(SDKCall_Raw);
    // PrepSDKCall_SetFromConf(gamedata, SDKConf_Signature, "CNMRiH_ObjectiveBoundary::Start");
    // if ((hObjectiveBoundaryHandle[HDL_ObjectiveBoundary_Start] = EndPrepSDKCall()) == null)
    //     SetFailState("Failed to load signature CNMRiH_ObjectiveBoundary::Start");

    StartPrepSDKCall(SDKCall_Raw);
    PrepSDKCall_SetFromConf(gamedata, SDKConf_Signature, "CNMRiH_ObjectiveBoundary::Finish.");
    if ((hObjectiveBoundaryHandle[HDL_ObjectiveBoundary_Finish] = EndPrepSDKCall()) == null)
        SetFailState("Failed to load signature CNMRiH_ObjectiveBoundary::Finish.");
}


// static any Native_ObjectiveBoundary_Start(Handle plugin, int numParams)
// {
//     ObjectiveBoundary objectiveBoundary = GetNativeCell(1);
//     if (!objectiveBoundary)
//         ThrowNativeError(SP_ERROR_PARAM, "Invalid objective boundary 0x%x", objectiveBoundary);

//     return SDKCall(hObjectiveBoundaryHandle[HDL_ObjectiveBoundary_Start], objectiveBoundary.addr);
// }

static any Native_ObjectiveBoundary_Finish(Handle plugin, int numParams)
{
    ObjectiveBoundary objectiveBoundary = GetNativeCell(1);
    if (objectiveBoundary.IsNull())
        ThrowNativeError(SP_ERROR_INVALID_ADDRESS, "ObjectiveBoundary instance is null.");

    return SDKCall(hObjectiveBoundaryHandle[HDL_ObjectiveBoundary_Finish], objectiveBoundary.addr);
}
