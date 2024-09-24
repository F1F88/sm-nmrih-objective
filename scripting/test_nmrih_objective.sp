#pragma newdecls required
#pragma semicolon 1

#include <sdktools>
#include <vscript_proxy>
#include <utl_vector>
#include <nmrih_objective>

#define PLUGIN_NAME                         "ObjectiveManager Proxy Test"
#define PLUGIN_DESCRIPTION                  "ObjectiveManager Proxy Test"
#define PLUGIN_VERSION                      "1.0.0"

public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = "F1F88",
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_VERSION,
    url         = "https://github.com/F1F88/"
};



public void OnPluginStart()
{
    RegConsoleCmd("to", CMD_Objective);
    // RegConsoleCmd("tob1", CMD_ObjectiveBoundary_Start);
    RegConsoleCmd("tob2", CMD_ObjectiveBoundary_Finish);
    RegConsoleCmd("tom1", CMD_Manager_Info);
    RegConsoleCmd("tom2", CMD_Manager_CompleteCurrentObjective);
    RegConsoleCmd("tom3", CMD_Manager_StartNextObjective);
    RegConsoleCmd("tom4", CMD_Fix);
    RegConsoleCmd("tom5", CMD_Test);
}


Action CMD_Objective(int client, int params)
{
    PrintToServer("========== CMD_Objective Start ==========");
    int count = ObjectiveManager.Instance().GetObjectiveCount();
    for (int index=0; index < count; ++index)
    {
        Objective objective = ObjectiveManager.Instance().GetObjectiveByIndex(index);
        PrintToServer("------- %d/%d Objective Address=%d -------", index, count, objective);
        if (!objective)
            continue;

        int id, entityCount, linkCount;
        char name[256], desc[256], boundaryName[256], buffer1[512], buffer2[512];
        UtlVector entitysVector, linksVector;
        bool isAntiObjective;
        ObjectiveBoundary objectiveBoundary;

        PrintToServer("--- propertys ---");

        id = objective.m_iId;
        objective._sName.ToCharArray(name, sizeof(name));
        objective._sDescription.ToCharArray(desc, sizeof(desc));

        entitysVector = objective._pEntitysVector;
        entityCount = objective._iEntitysCount;
        FormatEx(buffer1, sizeof(buffer1), "_pEntitysVector %d |", entityCount);
        for (int i=0; i<entityCount; ++i)
            FormatEx(buffer1, sizeof(buffer1), "%s %d=%d |", buffer1, i, entitysVector.Get(i));

        linksVector = objective._pLinksVector;
        linkCount = objective._iLinksCount;
        FormatEx(buffer2, sizeof(buffer2), "_pLinksVector %d |", linkCount);
        for (int i=0; i<linkCount; ++i)
            FormatEx(buffer2, sizeof(buffer2), "%s %d=%d |", buffer2, i, linksVector.Get(i));

        isAntiObjective = objective._bIsAntiObjective;
        objective._sObjectiveBoundaryName.ToCharArray(boundaryName, sizeof(boundaryName));

        PrintToServer("m_iId=%d | _sName=%s | _sDescription=%s | _bIsAntiObjective=%s | _sObjectiveBoundaryName=%s |"
            , id, name, desc, isAntiObjective ? "ture" : "false", boundaryName);

        PrintToServer(buffer1);

        PrintToServer(buffer2);


        PrintToServer("--- functions ---");

        id = objective.GetId();
        objective.GetName(name, sizeof(name));
        objective.GetDescription(desc, sizeof(desc));

        entityCount = objective.GetEntityCount();
        FormatEx(buffer1, sizeof(buffer1), "GetEntity %d |", entityCount);
        for (int i=0; i<entityCount; ++i)
            FormatEx(buffer1, sizeof(buffer1), "%s %d=%d |", buffer1, i, objective.GetEntity(i));

        linkCount = objective.GetLinkCount();
        FormatEx(buffer2, sizeof(buffer2), "GetLink %d |", linkCount);
        for (int i=0; i<linkCount; ++i)
            FormatEx(buffer2, sizeof(buffer2), "%s %d=%d |", buffer2, i, objective.GetLink(i));

        bool isEndObjective = objective.IsEndObjective();
        isAntiObjective = objective.IsEndObjective();
        objective.GetObjectiveBoundaryName(boundaryName, sizeof(boundaryName));
        objectiveBoundary = objective.GetObjectiveBoundary();

        PrintToServer("GetId=%d | GetName=%s | GetDescription=%s | IsEndObjective=%s | IsAntiObjective=%s | GetObjectiveBoundaryName=%s | GetObjectiveBoundary=0x%x |"
            , id, name, desc, isEndObjective ? "ture" : "false", isAntiObjective ? "ture" : "false", boundaryName, objectiveBoundary);

        PrintToServer(buffer1);

        PrintToServer(buffer2);
    }
    PrintToServer("========== CMD_Objective End ==========");
    return Plugin_Handled;
}

// Action CMD_ObjectiveBoundary_Start(int client, int param)
// {
//     PrintToServer("========== CMD_ObjectiveBoundary_Start Start ==========");

//     int index = param ? GetCmdArgInt(1) : ObjectiveManager.Instance().GetCurrentObjectiveIndex();
//     Objective objective = ObjectiveManager.Instance().GetObjectiveByIndex(index);
//     ObjectiveBoundary objectiveBoundary = objective.GetObjectiveBoundary();

//     PrintToServer("objective index=%d | objective=0x%x | objective id=%d | objectiveBoundary=0x%x |"
//         , index, objective, objective.GetId(), objectiveBoundary);
//     objectiveBoundary.Start();

//     PrintToServer("========== CMD_ObjectiveBoundary_Start End ==========");
//     return Plugin_Handled;
// }

Action CMD_ObjectiveBoundary_Finish(int client, int param)
{
    PrintToServer("========== CMD_ObjectiveBoundary_Finish Start ==========");

    ObjectiveManager objectiveManager = ObjectiveManager.Instance();
    int index = param ? GetCmdArgInt(1) : objectiveManager.GetCurrentObjectiveIndex();
    Objective objective = objectiveManager.GetObjectiveByIndex(index);
    ObjectiveBoundary objectiveBoundary = objective.GetObjectiveBoundary();

    PrintToServer("objectiveManager=0x%x | objective index=%d | objective=0x%x | objective id=%d | objectiveBoundary=0x%x |"
        , objectiveManager, index, objective, objective.GetId(), objectiveBoundary);
    objectiveBoundary.Finish();

    PrintToServer("========== CMD_ObjectiveBoundary_Finish End ==========");
    return Plugin_Handled;
}

Action CMD_Manager_Info(int client, int params)
{
    PrintToServer("========== CMD_Manager_Info Start ==========");

    ObjectiveManager objectiveManager = ObjectiveManager.Instance();
    PrintToServer("------- ObjectiveManager Address=%d -------", objectiveManager);
    if (!objectiveManager)
        return Plugin_Handled;

    UtlVector objectivesVector, objectiveChainVector;
    int objectivesCount, objectiveChainCount, currentObjectiveIndex;
    bool isCompleted, isFailed;
    char currentObjectiveBoundaryName[256], buffer1[512], buffer2[512];
    Objective currentObjective;

    PrintToServer("--- propertys ---");

    objectivesVector = objectiveManager._pObjectivesVector;
    objectivesCount = objectiveManager._iObjectivesCount;
    FormatEx(buffer1, sizeof(buffer1), "_pObjectivesVector %d |", objectivesCount);
    for (int i=0; i<objectivesCount; ++i)
        FormatEx(buffer1, sizeof(buffer1), "%s %d=%d |", buffer1, i, objectivesVector.Get(i));

    objectiveChainVector = objectiveManager._pObjectiveChainVector;
    objectiveChainCount = objectiveManager._iObjectiveChainCount;
    FormatEx(buffer2, sizeof(buffer2), "_pObjectiveChainVector %d |", objectiveChainCount);
    for (int i=0; i<objectiveChainCount; ++i)
        FormatEx(buffer2, sizeof(buffer2), "%s %d=%d |", buffer2, i, objectiveChainVector.Get(i));

    isCompleted = objectiveManager._bIsCompleted;
    isFailed = objectiveManager._bIsFailed;
    currentObjectiveIndex = objectiveManager._iCurrentObjectiveIndex;
    objectiveManager._sCurrentObjectiveBoundary.ToCharArray(currentObjectiveBoundaryName, sizeof(currentObjectiveBoundaryName));
    currentObjective = objectiveManager._pCurrentObjective;

    PrintToServer("_bIsCompleted=%s | _bIsFailed=%s | _iCurrentObjectiveIndex=%d | _sCurrentObjectiveBoundary=%s | _pCurrentObjective=0x%x |",
        isCompleted ? "ture" : "false", isFailed ? "ture" : "false", currentObjectiveIndex, currentObjectiveBoundaryName, currentObjective);

    PrintToServer(buffer1);

    PrintToServer(buffer2);


    PrintToServer("--- functions ---");

    objectiveManager.GetCurrentObjectiveBoundary(currentObjectiveBoundaryName, sizeof(currentObjectiveBoundaryName));
    currentObjectiveIndex = objectiveManager.GetCurrentObjectiveIndex();

    PrintToServer("GetCurrentObjectiveBoundary=%s | GetCurrentObjectiveIndex=%d |", currentObjectiveBoundaryName, currentObjectiveIndex);

    int index = 1;
    Objective objectByIndex = objectiveManager.GetObjectiveByIndex(index);
    int idByIndex = objectByIndex.GetId();
    char nameByIndex[256];
    objectByIndex.GetName(nameByIndex, sizeof(nameByIndex));
    PrintToServer("GetObjectiveByIndex(%d) = %d | id=%d | name=%s", index, objectByIndex, idByIndex, nameByIndex);

    Objective objectById = objectiveManager.GetObjectiveById(idByIndex);
    int idById = objectById.GetId();
    char nameById[256];
    objectByIndex.GetName(nameById, sizeof(nameById));
    PrintToServer("GetObjectiveById(%d) = %x | id=%d | name=%s", idByIndex, objectById, idById, nameById);

    Objective objectByName = objectiveManager.GetObjectiveByName(nameByIndex);
    int idByName = objectByName.GetId();
    char nameByName[256];
    objectByName.GetName(nameByName, sizeof(nameByName));
    PrintToServer("GetObjectiveByName(\"%s\") = %x | id=%d | name=%s", nameByIndex, objectByName, idByName, nameByName);

    objectiveChainCount = objectiveManager.GetObjectiveChainCount();
    PrintToServer("GetObjectiveChainCount=%d", objectiveChainCount);

    ArrayList objectiveChain = new ArrayList();
    objectiveManager.GetObjectiveChain(objectiveChain);
    for (int i=0; i<objectiveChain.Length; i++)
    {
        Objective objectByChain = objectiveChain.Get(i);
        int idByChain = objectByChain.GetId();
        char nameByChain[256];
        objectByChain.GetName(nameByChain, sizeof(nameByChain));
        PrintToServer("i=%d | value=%d | id=%d | name=%s", i, objectByChain, idByChain, nameByChain);
    }

    int objectiveCount = objectiveManager.GetObjectiveCount();
    PrintToServer("GetObjectiveCount() = %d", objectiveCount);

    isCompleted = objectiveManager.IsCompleted();
    PrintToServer("IsCompleted() = %d", isCompleted ? "true" : "false");

    isFailed = objectiveManager.IsFailed();
    PrintToServer("IsFailed() = %s", isFailed ? "true" : "false");

    PrintToServer("========== CMD_Manager_Info End ==========");
    return Plugin_Handled;
}

Action CMD_Manager_CompleteCurrentObjective(int client, int params)
{
    PrintToServer("========== CMD_Manager_CompleteCurrentObjective Start ==========");

    char targetname[256];
    if (params)
        GetCmdArg(1, targetname, sizeof(targetname));

    PrintToServer("targetname=\"%s\"", targetname);

    ObjectiveManager.Instance().CompleteCurrentObjective(targetname);

    PrintToServer("========== CMD_Manager_CompleteCurrentObjective End ==========");
    return Plugin_Handled;
}

Action CMD_Manager_StartNextObjective(int client, int params)
{
    PrintToServer("========== CMD_Manager_StartNextObjective Start ==========");

    ObjectiveManager.Instance().StartNextObjective();

    PrintToServer("========== CMD_Manager_StartNextObjective End ==========");
    return Plugin_Handled;
}

// https://github.com/dysphie/nmo-guard/issues/9
Action CMD_Fix(int client, int param)
{
    PrintToServer("========== CMD_Fix Start ==========");

    ObjectiveManager objectiveManager = ObjectiveManager.Instance();
    int index = param ? GetCmdArgInt(1) : objectiveManager.GetCurrentObjectiveIndex();
    Objective objective = objectiveManager.GetObjectiveByIndex(index);
    ObjectiveBoundary objectiveBoundary = objective.GetObjectiveBoundary();

    PrintToServer("objectiveManager=0x%x | objective index=%d | objective=0x%x | objective id=%d | objectiveBoundary=0x%x |"
        , objectiveManager, index, objective, objective.GetId(), objectiveBoundary);

    if (objectiveBoundary)
        objectiveBoundary.Finish();

    objectiveManager._iCurrentObjectiveIndex++;
    objectiveManager.StartNextObjective();

    PrintToServer("========== CMD_Fix End ==========");
    return Plugin_Handled;
}

Action CMD_Fix2(int client, int param)
{
    PrintToServer("========== CMD_Fix2 Start ==========");

    ObjectiveManager objectiveManager = ObjectiveManager.Instance();

    int objectiveBoundaryEntity = LoadFromAddress(objectiveManager.addr + 0x7C, NumberType_Int32) & 0xFFF;
    if (!IsValidEntity(objectiveBoundaryEntity))
        return Plugin_Handled;

    ObjectiveBoundary objectiveBoundary = LoadFromAddress(GetEntityAddress(objectiveBoundaryEntity) + 0x4, NumberType_Int32);

    if (objectiveBoundary)
        objectiveBoundary.Finish();

    objectiveManager._iCurrentObjectiveIndex++;
    objectiveManager.StartNextObjective();

    PrintToServer("========== CMD_Fix2 End ==========");
    return Plugin_Handled;
}

Action CMD_Test(int client, int param)
{
    PrintToServer("========== CMD_Test Start ==========");

    ObjectiveManager objectiveManager = ObjectiveManager.Instance();
    ObjectiveBoundary boundary = objectiveManager._pCurrentObjective.GetObjectiveBoundary();

    any boundary124 = LoadFromAddress(objectiveManager.addr + 124, NumberType_Int32);
    int entity = boundary124 & 0xFFF;

    PrintToServer("boundary.addr = %u | boundary124 = %u | boundary124 & 0xFFF = %u | boundary124 >> 12 = %u"
        , boundary.addr, boundary124, entity, boundary124 >> 12);

    PrintToServer("entity=%u | entity ref=%u | entity addr=%u", entity, EntIndexToEntRef(entity), GetEntityAddress(entity));

    PrintToServer("========== CMD_Test End ==========");

    return Plugin_Handled;
}

// Action CMD_Test2(int client, int param)
// {
//     PrintToServer("========== CMD_Test2 Start ==========");

//     // int entityIndex = GetCmdArgInt(1);
//     int entityIndex = param;

//     GameData gamedata  = new GameData("nmrih_objective.games");
//     if (!gamedata)
//         ThrowError("Couldn't find nmrih_objective.games gamedata");


//     Address g_pEntityList = gamedata.GetAddress("g_pEntityList");
//     if (!g_pEntityList)
//         ThrowError("Failed to load address g_pEntityList");

//     PrintToServer("g_pEntityList = %u | entityIndex = %u |", g_pEntityList, entityIndex);

//     Address entity = LoadFromAddress(g_pEntityList + entityIndex * 16, NumberType_Int32);
//     int ent4 = LoadFromAddress(g_pEntityList + entityIndex * 16 + 4, NumberType_Int32);
//     int ent8 = LoadFromAddress(g_pEntityList + entityIndex * 16 + 8, NumberType_Int32);

//     PrintToServer("entity=%u | +4 = %d | +8 = %d |", entity, ent4, ent8);

//     PrintToServer("========== CMD_Test2 End ==========");
//     return Plugin_Handled;
// }

// {
//     ObjectiveManager objectiveManager = ObjectiveManager.Instance();

//     int currentBoundaryRef = LoadFromAddress(objectiveManager.addr + 124, NumberType_Int32);
//     int currentBoundaryEntity = currentBoundaryRef & 0xFFF;
//     int checkNumber = currentBoundaryRef >> 12;

//     Address currentBoundaryEntityAddr = GetEntityAddress(currentBoundaryEntity);
//     Address currentBoundaryAddr = LoadFromAddress(currentBoundaryEntityAddr + 4, NumberType_Int32);
//     int checkNumber2 = LoadFromAddress(currentBoundaryEntityAddr + 8, NumberType_Int32);
// }

// script ObjectiveManager.CompleteCurrentObjective("")
// script printl(ObjectiveManager.GetObjectiveByIndex(6))
// script printl(ObjectiveManager.GetObjectiveByIndex(5).GetId())
// script printl(ObjectiveManager.GetObjectiveById(1723505))
// script printl(ObjectiveManager.GetObjectiveById(1723505).GetId())
// script printl(ObjectiveManager.GetObjectiveById(34).GetName())

// ! Bug 永远只返回第一个任务
// script printl("CurrentObjectiveIndex = "+ObjectiveManager.GetCurrentObjectiveIndex())
// script printl("CurrentObjectiveBoundary = " + ObjectiveManager.GetCurrentObjectiveBoundary())

// script printl("do CompleteCurrentObjective(\"\")")
// script ObjectiveManager.CompleteCurrentObjective("")

// script printl("CurrentObjectiveIndex = "+ObjectiveManager.GetCurrentObjectiveIndex())
// script printl("CurrentObjectiveBoundary = " + ObjectiveManager.GetCurrentObjectiveBoundary())

// script ObjectiveManager.GetObjectiveById()

// script local arr = [1, 2, 3]; printl(arr);
// script printl([1, 2, 3])
// script "local arr; ObjectiveManager.GetObjectiveChain(arr); printl(arr)"


// printl("Hello My Test nut");
// local chain = [1, 2, 3];
// printl(chain);
// ObjectiveManager.GetObjectiveChain(array);
// printl(chain);
// foreach (i in chain) {
//     printl(i);
// }

// script_execute test.nut




// Action CMD_Test(int client, int params)
// {
//     PrintToServer("===== CMD_Test Start =====");

//     NMRObjectiveManager objectiveManager = NMRObjectiveManager.Instance();
//     PrintToServer("Get global singleton ObjectiveManager object = 0x%x", objectiveManager);

//     // CompleteCurrentObjective

//     char buffer[256];
//     objectiveManager.GetCurrentObjectiveBoundary(buffer, sizeof(buffer));
//     PrintToServer("GetCurrentObjectiveBoundary(buffer, sizeof(buffer)) = '%s'", buffer);

//     int index = objectiveManager.GetCurrentObjectiveIndex();
//     PrintToServer("GetCurrentObjectiveIndex() = %d", index);

//     NMRObjective objectByIndex = objectiveManager.GetObjectiveByIndex(index);
//     PrintToServer("GetObjectiveByIndex(%d) = %d", index, objectByIndex);

//     NMRObjective objectById = objectiveManager.GetObjectiveById(objectByIndex.GetId());
//     PrintToServer("GetObjectiveById(%d) = %x", objectByIndex.GetId(), objectById);

//     objectById.GetName(buffer, sizeof(buffer));
//     NMRObjective objectByName = objectiveManager.GetObjectiveByName(buffer);
//     PrintToServer("GetObjectiveByName(\"%s\") = %x", buffer, objectByName);

//     int objectiveCount = objectiveManager.GetObjectiveCount();
//     PrintToServer("GetObjectiveCount() = %d", objectiveCount);

//     int objectiveChainLength = objectiveManager.GetObjectiveChainLength();
//     PrintToServer("GetObjectiveChainLength=%d", objectiveChainLength);

//     // GetObjectiveChain
//     ArrayList objectiveChain = objectiveManager.GetObjectiveChain();
//     PrintToServer("objectiveChain=%d | objectiveChain.Length=%d", objectiveChain, objectiveChain.Length);
//     for(int i=0; i<objectiveChain.Length; ++i)
//     {
//         NMRObjective objectByChain = objectiveChain.Get(i);
//         int id = objectByChain.GetId();
//         bool isEndObjective = objectByChain.IsEndObjective();
//         bool isAntiObjective = objectByChain.IsAntiObjective();
//         NMRObjectiveBoundary objectiveBoundary = objectByChain.GetObjectiveBoundary();

//         PrintToServer("objectByChain-A: i = %d | addr = 0x%x | id = %d | isEndObjective = %d | isAntiObjective = %d | objectiveBoundary = 0x%x"
//             , i, objectByChain.addr, id, isEndObjective, isAntiObjective, objectiveBoundary
//         );

//         char name[256], description[256], objectiveBoundaryName[256];
//         objectByChain.GetName(name, sizeof(name));
//         objectByChain.GetDescription(description, sizeof(description));
//         objectByChain.GetObjectiveBoundaryName(objectiveBoundaryName, sizeof(objectiveBoundaryName));

//         PrintToServer("objectByChain-B: i = %d | name = %s | description = %s | objectiveBoundaryName = %s |"
//             , i, name, description, objectiveBoundaryName
//         );
//     }
//     delete objectiveChain;

//     // GetId
//     // GetName
//     // GetDescription
//     // IsEndObjective
//     // IsAntiObjective
//     // GetObjectiveBoundaryName
//     // GetObjectiveBoundary

//     // Start
//     // Finish

//     PrintToServer("IsCompleted()=%d", objectiveManager.IsCompleted());

//     PrintToServer("IsFailed()=%d", objectiveManager.IsFailed());

//     UtlVector objectList = UtlVector(objectiveManager.addr + 20);
//     // PrintToServer("objectList=%d ", objectList);
//     PrintToServer("objectList=%d | size=%d | GetObjectiveCount=%d", objectList, objectList.size, objectiveManager.GetObjectiveCount());
//     for(int i=0; i<objectList.size && objectiveManager.GetObjectiveCount(); ++i)
//     {
//         PrintToServer("i=%d | value=%d", i, objectList.Get(i));
//     }

//     // StartNextObjective

//     PrintToServer("===== CMD_Test End =====\n");
//     return Plugin_Handled;
// }
