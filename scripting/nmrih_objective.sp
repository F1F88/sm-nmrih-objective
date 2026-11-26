#include <sourcemod>
#include <sdktools>

#include <stringt>

#include <log4sp>
#undef  REQUIRE_PLUGIN
#include <log4sp/registry>
#define REQUIRE_PLUGIN

#include <nmrih_objective>

#pragma newdecls required
#pragma semicolon 1

/**
 * Reference    https://github.com/dysphie/nmo-guard
 *              https://github.com/dysphie/dystopia-servers/blob/2b7f30024efa3315bd16028be47fb8b0c87648ec/addons/sourcemod/scripting/include/nmr_objectives.inc
 */
#define PLUGIN_NAME        "Library NMRiH Objective"
#define PLUGIN_DESCRIPTION "Library NMRiH Objective"
#define PLUGIN_VERSION     "3.0.1"
#define LOGGER_NAME        "lib-objective"

public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = "F1F88",
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_VERSION,
    url         = "https://github.com/F1F88/sm-nmrih-objective"
};


enum OperatingSystem
{
    OS_Unknown  = -1,
    OS_Win32    = 0,
    OS_Win64    = 1,
    OS_Linux32  = 10,
    OS_Linux64  = 11,
    OS_Mac32    = 20,
    OS_Mac64    = 21
}

OperatingSystem g_eOS;
Logger          g_hLogger;


#include "nmrih_objective/objective.sp"
#include "nmrih_objective/objevtive_boundary.sp"
#include "nmrih_objective/objective_manager.sp"


public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
    LoadObjectiveNative();
    LoadObjectiveBoundaryNative();
    LoadObjectiveManagerNative();
    return APLRes_Success;
}

public void OnPluginStart()
{
    /* ------- Log Debug ------- */
    g_hLogger = CreateLogger();

    /* ------- Load GameData ------- */
    GameData gamedata  = new GameData("nmrih_objective.games");
    if (!gamedata)
        g_hLogger.Fatal("Couldn't find nmrih_objective.games gamedata.");

    g_eOS = view_as<OperatingSystem>(gamedata.GetOffset("OS"));
    if (g_eOS == OS_Unknown)
        g_hLogger.Fatal("Failed to load offset \"OS\".");
    else if (g_eOS == OS_Mac32 || g_eOS == OS_Mac64)
        g_hLogger.Fatal("This plugin does not support Mac OS.");
    else
        g_hLogger.DebugF("Read gamedata \"OS\" offset %d.", g_eOS);

    LoadObjectiveOffset(gamedata);
    LoadObjectiveSignature(gamedata);

    LoadObjectiveBoundarySignature(gamedata);

    LoadObjectiveManagerAddress(gamedata);
    LoadObjectiveManagerOffset(gamedata);
    LoadObjectiveManagerSignature(gamedata);

    delete gamedata;

    /* ------- Load ConVar ------- */
    CreateConVar("sm_lib_nmrih_objective_version", PLUGIN_VERSION, PLUGIN_DESCRIPTION, FCVAR_SPONLY | FCVAR_DONTRECORD);

    /* ------- Register Libray ------- */
    RegPluginLibrary("nmrih_objective");

    g_hLogger.Info("[SM] " ... PLUGIN_NAME ... " (" ... PLUGIN_VERSION ... ") initialize complete!");
}

public void OnAllPluginsLoaded()
{
    if (!LoggerRegistry.IsAvailable())
    {
        g_hLogger.Warn("The plugin log4sp_manager is unavailable.");
    }
    else
    {
        LoggerRegistry.Instance().RegisterOrReplaceLogger(g_hLogger);
    }
}

public void OnPluginEnd()
{
    if (LoggerRegistry.IsAvailable())
        LoggerRegistry.Instance().Drop(LOGGER_NAME);

    delete g_hLogger;
}


static Logger CreateLogger()
{
    char name[] = LOGGER_NAME;
    char file[] = "logs/lib/nmrih_objective.log";
    const int maxFileSize = 1024 * 1024 * 8; // MB
    const int maxFiles    = 2;

    char filename[PLATFORM_MAX_PATH];
    BuildPath(Path_SM, filename, sizeof(filename), file);
    RotatingFileSink rotatingFileSink = new RotatingFileSink(filename, maxFileSize, maxFiles);
    ServerConsoleSink serverConsoleSink = new ServerConsoleSink();

    Logger logger = new Logger(name);

#if defined DEBUG || defined _DEBUG
    // 调试模式不考虑性能
    // 记录所有日志，并立即刷写
    logger.SetLevel(LogLevel_Trace);
    logger.SetFlushLevel(LogLevel_Trace);
#else
    // 非调试模式需要保证性能，同时避免日志刷屏控制台
    // 记录 Info 级别以上日志，并按需刷写
    // 控制台仅输出 Warn 级别以上的日志
    serverConsoleSink.SetLevel(LogLevel_Warn);
#endif

    logger.AddSinkAndClose(rotatingFileSink);
    logger.AddSinkAndClose(serverConsoleSink);

    // OnPluginStart 阶段, Error/Fatal 日志可以让插件加载失败
    // 后续 Native、Detour 阶段, Error/Fatal 日志可以在参数校验失败时结束回调
    logger.SetThrowLevel(LogLevel_Error);
    return logger;
}
