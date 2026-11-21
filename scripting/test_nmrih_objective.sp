#pragma newdecls required
#pragma semicolon 1
#pragma dynamic 32768

#if !defined DEBUG
    #define  DEBUG
#endif

#if !defined _DEBUG
    #define  _DEBUG
#endif

#if defined NDEBUG
    #undef  NDEBUG
#endif

#include <sdktools>
#include <sourcemod>

#include <vscript_proxy>
#include <nmrih_objective>

#include <log4sp>

// #define ASSERT_QUIET
#include <assert>

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


Logger g_hLogger;

public void OnPluginStart()
{
    char filename[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, filename, sizeof(filename), "logs/test/nmrih_objective.log");

    g_hLogger = new Logger();
    g_hLogger.AddSinkAndClose(new BasicFileSink(filename, true));
    g_hLogger.AddSinkAndClose(new ServerConsoleSink());
    g_hLogger.SetLevel(LogLevel_Trace);
    g_hLogger.SetFlushLevel(LogLevel_Trace);
    g_hLogger.SetThrowLevel(LogLevel_Error);

    RegConsoleCmd("sm_test_obj_mgr_1",  CMD_ObjMgr_CompleteCurrentObjective);
    RegConsoleCmd("sm_test_obj_mgr_2",  CMD_ObjMgr_Clear);
    RegConsoleCmd("sm_test_obj_mgr_3",  CMD_ObjMgr_Finish);
    RegConsoleCmd("sm_test_obj_mgr_4",  CMD_ObjMgr_StartNextObjective);
    RegConsoleCmd("sm_test_obj_mgr_5",  CMD_ObjMgr_UpdateObjectiveBoundaries);
    RegConsoleCmd("sm_test_obj_mgr_6",  CMD_ObjMgr_FailCurrentObjective);
    RegConsoleCmd("sm_test_obj_1",      CMD_Obj_UpdateBoundary);
    RegConsoleCmd("sm_test_obj_bdy_1",  CMD_Obj_Bdy_Start);
    RegConsoleCmd("sm_test_obj_bdy_2",  CMD_Obj_Bdy_Finish);

    g_hLogger.Info("[SM] " ... PLUGIN_NAME ... " (" ... PLUGIN_VERSION ... ") initialize complete!");
}

Action CMD_ObjMgr_CompleteCurrentObjective(int client, int params)
{
    g_hLogger.Trace("========== CMD_ObjMgr_CompleteCurrentObjective Start ==========");

    ObjectiveManager objMgr = ObjectiveManager.Instance();
    g_hLogger.Debug(ObjectiveManagerToString(objMgr));

    char targetname[256];
    if (params)
        GetCmdArg(1, targetname, sizeof(targetname));

    g_hLogger.DebugF("targetname=\"%s\"", targetname);

    ObjectiveManager.CompleteCurrentObjective(targetname);

    g_hLogger.Trace("========== CMD_ObjMgr_CompleteCurrentObjective End ==========");
    return Plugin_Handled;
}

Action CMD_ObjMgr_Clear(int client, int params)
{
    g_hLogger.Trace("========== CMD_ObjMgr_Clear Start ==========");

    ObjectiveManager objMgr = ObjectiveManager.Instance();
    g_hLogger.Debug(ObjectiveManagerToString(objMgr));

    ObjectiveManager.Clear();

    g_hLogger.Trace("========== CMD_ObjMgr_Clear End ==========");
    return Plugin_Handled;
}

Action CMD_ObjMgr_Finish(int client, int params)
{
    g_hLogger.Trace("========== CMD_ObjMgr_Finish Start ==========");

    ObjectiveManager objMgr = ObjectiveManager.Instance();
    g_hLogger.Debug(ObjectiveManagerToString(objMgr));

    ObjectiveManager.Finish();

    g_hLogger.Trace("========== CMD_ObjMgr_Finish End ==========");
    return Plugin_Handled;
}

Action CMD_ObjMgr_StartNextObjective(int client, int params)
{
    g_hLogger.Trace("========== StartNextObjective Start ==========");

    ObjectiveManager objMgr = ObjectiveManager.Instance();
    g_hLogger.Debug(ObjectiveManagerToString(objMgr));

    ObjectiveManager.StartNextObjective();

    g_hLogger.Trace("========== StartNextObjective End ==========");
    return Plugin_Handled;
}

Action CMD_ObjMgr_UpdateObjectiveBoundaries(int client, int params)
{
    g_hLogger.Trace("========== UpdateObjectiveBoundaries Start ==========");

    ObjectiveManager objMgr = ObjectiveManager.Instance();
    g_hLogger.Debug(ObjectiveManagerToString(objMgr));

    ObjectiveManager.UpdateObjectiveBoundaries();

    g_hLogger.Trace("========== UpdateObjectiveBoundaries End ==========");
    return Plugin_Handled;
}

Action CMD_ObjMgr_FailCurrentObjective(int client, int params)
{
    g_hLogger.Trace("========== FailCurrentObjective Start ==========");

    ObjectiveManager objMgr = ObjectiveManager.Instance();
    g_hLogger.Debug(ObjectiveManagerToString(objMgr));

    ObjectiveManager.FailCurrentObjective();

    g_hLogger.Trace("========== FailCurrentObjective End ==========");
    return Plugin_Handled;
}

Action CMD_Obj_UpdateBoundary(int client, int params)
{
    g_hLogger.Trace("========== CMD_Obj_Current Start ==========");

    Objective objective = ObjectiveManager.GetCurrentObjective();
    g_hLogger.Debug(ObjectiveToString(objective));

    objective.UpdateBoundary();

    g_hLogger.Trace("========== CMD_Obj_Current End ==========");
    return Plugin_Handled;
}

Action CMD_Obj_Bdy_Start(int client, int params)
{
    g_hLogger.Trace("========== CMD_ObjBoundary_Start Start ==========");

    ObjectiveBoundary objectiveBoundary = ObjectiveManager.GetCurrentObjective().GetObjectiveBoundary();
    g_hLogger.Debug(ObjectiveBoundaryToString(objectiveBoundary));

    objectiveBoundary.Start();

    g_hLogger.Trace("========== CMD_ObjBoundary_Start End ==========");
    return Plugin_Handled;
}

Action CMD_Obj_Bdy_Finish(int client, int params)
{
    g_hLogger.Trace("========== CMD_ObjBoundary_Finish Start ==========");

    ObjectiveBoundary objectiveBoundary = ObjectiveManager.GetCurrentObjective().GetObjectiveBoundary();
    g_hLogger.Debug(ObjectiveBoundaryToString(objectiveBoundary));

    objectiveBoundary.Finish();

    g_hLogger.Trace("========== CMD_ObjBoundary_Finish End ==========");
    return Plugin_Handled;
}



stock char[] ObjectiveToString(Objective objective)
{
    SetTestContext("Objective");

    AssertEq("m_iId == GetId()", objective.m_iId, objective.GetId());

    {
        char buf1[256], buf2[256];
        objective._sName.ToCharArray(buf1, sizeof(buf1));
        objective.GetName(buf2, sizeof(buf2));
        AssertStrEq("_sName == GetName()", buf1, buf2);
    }

    {
        char buf1[256], buf2[256];
        objective._sDescription.ToCharArray(buf1, sizeof(buf1));
        objective.GetDescription(buf2, sizeof(buf2));
        AssertStrEq("_sDescription == GetDescription()", buf1, buf2);
    }

    {
        char buf1[256], buf2[256];
        objective._sObjectiveBoundaryName.ToCharArray(buf1, sizeof(buf1));
        objective.GetObjectiveBoundaryName(buf2, sizeof(buf2));
        AssertStrEq("_sObjectiveBoundaryName == GetObjectiveBoundaryName()", buf1, buf2);
    }

    UtlVector/* <Stringt> */ entitysVector = objective._pEntitysVector;
    ArrayList/* <Stringt> */ entityList    = objective.GetEntityList();

    AssertEq("entitysVector.size == _iEntitysCount",    entitysVector.size, objective._iEntitysCount);
    AssertEq("entitysVector.size == GetEntityCount",    entitysVector.size, objective.GetEntityCount());
    AssertEq("entitysVector.size == entityList.Length", entitysVector.size, entityList.Length);

    for (int i = 0; i < entitysVector.size; ++i)
    {
        AssertEq("entitysVector.Get(i) == entityList.Get(i)", entitysVector.Get(i), entityList.Get(i));
        AssertEq("entitysVector.Get(i) == GetEntity(i)",      entitysVector.Get(i), objective.GetEntity(i));

        {
            char buf1[256], buf2[256], buf3[256];
            view_as<Stringt>(entitysVector.Get(i)).ToCharArray(buf1, sizeof(buf1));
            view_as<Stringt>(entityList.Get(i)).ToCharArray(buf2, sizeof(buf2));
            view_as<Stringt>(objective.GetEntity(i)).ToCharArray(buf3, sizeof(buf3));

            AssertStrEq("entitysVector.Get(i) == entityList.Get(i)", buf1, buf2);
            AssertStrEq("entitysVector.Get(i) == GetEntity.Get(i)", buf1, buf3);
        }

        AssertTrue("ContainsEntity", objective.ContainsEntity(entitysVector.Get(i)));
    }
    delete entityList;

    UtlVector/* <int> */ linksVector = objective._pLinksVector;
    AssertEq("linksVector.size == _iLinksCount", linksVector.size, objective._iLinksCount);
    AssertEq("linksVector.size == GetLinkCount", linksVector.size, objective.GetLinkCount());

    for (int i = 0; i < linksVector.size; ++i)
    {
        AssertEq("linksVector.Get(i) == GetLink(i)", linksVector.Get(i), objective.GetLink(i));
        AssertTrue("HasLink", objective.HasLink(linksVector.Get(i)));
    }

    char buffer[4096];
    FormatEx(
        buffer, sizeof(buffer),
        "Objective{\n\taddr=%d,\n\tIsNull=%s,\n\tm_iId=%d,\n\t_sName=%s,\n\t_sDescription=%s,\n\t_pEntitysVector=%s,\n\t_iEntitysCount=%d,\n\t_pLinksVector=%s,\n\t_iLinksCount=%d,\n\t_bIsAntiObjective=%s,\n\t_sObjectiveBoundaryName=%s,\n\tIsEndObjective=%s,\n\tIsAntiObjective=%s,\n\tGetObjectiveBoundary=%s\n}",
        objective.addr,
        objective.IsNull() ? "true" : "false",
        objective.m_iId,
        StringtToString(objective._sName),
        StringtToString(objective._sDescription),
        UtlVectorToString(objective._pEntitysVector),
        objective._iEntitysCount,
        UtlVectorToString(objective._pLinksVector),
        objective._iLinksCount,
        objective._bIsAntiObjective ? "true" : "false",
        StringtToString(objective._sObjectiveBoundaryName),
        objective.IsEndObjective() ? "true" : "false",
        objective.IsAntiObjective() ? "true" : "false",
        ObjectiveBoundaryToString(objective.GetObjectiveBoundary())
    );
    return buffer;
}

stock char[] ObjectiveBoundaryToString(ObjectiveBoundary objectiveBoundary)
{
    char buffer[256];
    FormatEx(
        buffer, sizeof(buffer),
        "ObjectiveBoundary{this=%d,addr=%d,IsNull=%s}",
        objectiveBoundary,
        objectiveBoundary.addr,
        objectiveBoundary.IsNull() ? "true" : "false"
    );
    return buffer;
}

stock char[] ObjectiveManagerToString(ObjectiveManager objMgr)
{
    SetTestContext("ObjectiveManager");

    UtlVector/* <Objective> */ objectivesVector   = objMgr._pObjectivesVector;
    ArrayList/* <Objective> */ objectiveChainList = ObjectiveManager.GetObjectiveChain();

    AssertEq("objectivesVector.size == _iObjectivesCount",           objectivesVector.size, objMgr._iObjectivesCount);
    AssertEq("objectivesVector.size == GetObjectiveCount",           objectivesVector.size, ObjectiveManager.GetObjectiveCount());
    AssertEq("objectivesVector.size == objectiveChainList.Length",   objectivesVector.size, objectiveChainList.Length);

    UtlVector/* <int> */ objectiveChainVector = objMgr._pObjectiveChainVector;
    AssertEq("objectiveChainVector.size == _iObjectiveChainCount",   objectiveChainVector.size, objMgr._iObjectiveChainCount);
    AssertEq("objectiveChainVector.size == GetObjectiveChainCount",  objectiveChainVector.size, ObjectiveManager.GetObjectiveChainCount());

    for (int i = 0; i < objectivesVector.size; ++i)
    {
        AssertEq("objectivesVector.Get(i) == objectiveChainList.Get(i)", objectivesVector.Get(i), objectiveChainList.Get(i));
        AssertEq("objectivesVector.Get(i) == GetObjectiveByIndex(i)",    objectivesVector.Get(i), ObjectiveManager.GetObjectiveByIndex(i));

        Objective obj = objectivesVector.Get(i);
        int id = obj.GetId();
        AssertEq("objectivesVector.Get(i).GetId() == objectiveChainVector.Get(i)", id, objectiveChainVector.Get(i));

        AssertEq("objectivesVector.Get(i) == GetObjectiveById(id)",      objectivesVector.Get(i), ObjectiveManager.GetObjectiveById(id));
        AssertEq("objectivesVector.Get(i) == GetObjectiveById(id)",      objectivesVector.Get(i), ObjectiveManager.GetObjectiveById(id));

        char name[512];
        obj.GetName(name, sizeof(name));
        AssertEq("objectivesVector.Get(i) == GetObjectiveByName(name)",  objectivesVector.Get(i), ObjectiveManager.GetObjectiveByName(name));
    }
    delete objectiveChainList;

    {
        AssertEq("_bIsFailed == IsFailed", objMgr._bIsFailed, ObjectiveManager.IsFailed());
        AssertEq("_bIsFailed == IsFailed", objMgr._bIsCompleted, ObjectiveManager.IsCompleted());
    }

    {
        int index = objMgr._iCurrentObjectiveIndex;
        AssertEq("_iCurrentObjectiveIndex == GetCurrentObjectiveIndex", index, ObjectiveManager.GetCurrentObjectiveIndex());
        AssertEq("objectivesVector.Get(index) == _pCurrentObjective", objectivesVector.Get(index), objMgr._pCurrentObjective);
        AssertEq("objectivesVector.Get(index) == GetCurrentObjective", objectivesVector.Get(index), ObjectiveManager.GetCurrentObjective());
    }

    UtlVector/* <Objective> */ antiObjectivesVector = objMgr._pAntiObjectivesVector;
    for (int i = 0; i < antiObjectivesVector.size; ++i)
    {
        Objective obj = antiObjectivesVector.Get(i);
        AssertTrue("antiObjectivesVector.Get(i) IsAntiObjective", obj.IsAntiObjective());
    }

    char buffer[8192];
    FormatEx(
        buffer, sizeof(buffer),
        "ObjectiveManager{\n\taddr=%d,\n\tIsNull=%s,\n\t_pObjectivesVector=%s,\n\t_iObjectivesCount=%d,\n\t_pAntiObjectivesVector=%s,\n\t_iAntiObjectivesCount=%d,\n\t_pObjectiveChainVector=%s,\n\t_iObjectiveChainCount=%d,\n\t_bIsCompleted=%s,\n\t_bIsFailed=%s,\n\t_iCurrentObjectiveIndex=%d,\n\t_pCurrentObjective=%s,\n\tGetCurrentObjectiveBoundary=%s\n}",
        objMgr.addr,
        objMgr.IsNull() ? "true" : "false",
        UtlVectorToString(objMgr._pObjectivesVector),
        objMgr._iObjectivesCount,
        UtlVectorToString(objMgr._pAntiObjectivesVector),
        objMgr._iAntiObjectivesCount,
        UtlVectorToString(objMgr._pObjectiveChainVector),
        objMgr._iObjectiveChainCount,
        objMgr._bIsCompleted ? "true" : "false",
        objMgr._bIsFailed ? "true" : "false",
        objMgr._iCurrentObjectiveIndex,
        ObjectiveToString(objMgr._pCurrentObjective),
        ObjectiveBoundaryToString(ObjectiveManager.GetCurrentObjectiveBoundary())
    );
    return buffer;
}

stock char[] StringtToString(Stringt stringt)
{
    char buffer[1024];
    stringt.ToCharArray(buffer, sizeof(buffer));
    Format(
        buffer, sizeof(buffer),
        "Stringt{addr=%d,IsNull=%s,str=%s}",
        stringt.addr,
        stringt.IsNull() ? "true" : "false",
        buffer
    );
    return buffer;
}

stock char[] UtlVectorToString(UtlVector vector)
{
    char buffer[1024];
    FormatEx(buffer, sizeof(buffer), "[");
    for (int i = 0; i < vector.size; ++i)
    {
        if (i == 0)
            Format(buffer, sizeof(buffer), "%s%d", buffer, vector.Get(i));
        else
            Format(buffer, sizeof(buffer), "%s,%d", buffer, vector.Get(i));
    }
    StrCat(buffer, sizeof(buffer), "]");

    Format(
        buffer, sizeof(buffer),
        "UtlVector{addr=%d,IsNull=%s,size=%d,elements=%s}",
        vector.addr,
        vector.IsNull() ? "true" : "false",
        vector.size,
        buffer
    );
    return buffer;
}


public void ASSERT_OPTION_ON_PASS(int counter, const char[] suite, const char[] name, const char[] msg)
{
    g_hLogger.InfoF("[%2u] [ OK ] [%s] %s%s%s.", counter, suite, name, (name[0] ? " " : ""), msg);
}

public void ASSERT_OPTION_ON_FAIL(int counter, const char[] suite, const char[] name, const char[] msg)
{
    g_hLogger.LogStackTraceF(LogLevel_Fatal, "[%2u] [FAIL] [%s] %s%s%s.", counter, suite, name, (name[0] ? " " : ""), msg);
}
