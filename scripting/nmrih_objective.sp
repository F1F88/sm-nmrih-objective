#include <sourcemod>
#include <sdktools>

#include <stringt>
#include <nmrih_objective>

#pragma newdecls required
#pragma semicolon 1

/**
 * Reference    https://github.com/dysphie/nmo-guard
 *              https://github.com/dysphie/dystopia-servers/blob/2b7f30024efa3315bd16028be47fb8b0c87648ec/addons/sourcemod/scripting/include/nmr_objectives.inc
 */
#define PLUGIN_NAME        "Library NMRiH Objective"
#define PLUGIN_DESCRIPTION "Library NMRiH Objective"
#define PLUGIN_VERSION     "2.2.0"

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
    /* ------- Load GameData ------- */
    GameData gamedata  = new GameData("nmrih_objective.games");
    if (!gamedata)
        SetFailState("Couldn't find nmrih_objective.games gamedata");

    g_eOS = view_as<OperatingSystem>(gamedata.GetOffset("OS"));
    if (g_eOS == OS_Unknown)
        SetFailState("Failed to load offset \"OS\".");
    else if (g_eOS == OS_Mac32 || g_eOS == OS_Mac64)
        SetFailState("This plugin does not support Mac OS.");
    else
        PrintToServer("Read gamedata \"OS\" offset %d.", g_eOS);

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

    PrintToServer("[SM] " ... PLUGIN_NAME ... " (" ... PLUGIN_VERSION ... ") initialize complete!");
}
