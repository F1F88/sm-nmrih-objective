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
    url         = "https://github.com/F1F88/"
};


enum OS
{
    OS_Windows,
    OS_Linux,
    OS_Mac,
    OS_Total
}

OS  g_OS;


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
    GameData gamedata  = new GameData("nmrih_objective.games");
    if (!gamedata)
        SetFailState("Couldn't find nmrih_objective.games gamedata");

    int offset = gamedata.GetOffset("OS");
    if (offset == -1)
        SetFailState("Failed to load offset \"OS\".");
    else if (offset == 2)
        SetFailState("This plugin does not support Mac OS.");
    else
        g_OS = view_as<OS>(offset);

    LoadObjectiveOffset(gamedata);
    LoadObjectiveSignature(gamedata);

    LoadObjectiveBoundarySignature(gamedata);

    LoadObjectiveManagerAddress(gamedata);
    LoadObjectiveManagerOffset(gamedata);
    LoadObjectiveManagerSignature(gamedata);

    delete gamedata;

    CreateConVar("sm_lib_nmrih_objective_version", PLUGIN_VERSION, PLUGIN_DESCRIPTION, FCVAR_SPONLY | FCVAR_DONTRECORD);

    PrintToServer("****************** NMRIH Objective Utils Initialize Complete ******************");
}
