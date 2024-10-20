#include <sourcemod>
#include <sdktools>

#include <stringt>
#include <nmrih_objective>

#pragma newdecls required
#pragma semicolon 1

#define PLUGIN_NAME        "NMRIH Objective Utils"
#define PLUGIN_DESCRIPTION "No More Room In Hell objective utils"
#define PLUGIN_VERSION     "1.1.0"

public Plugin myinfo =
{
    name        = PLUGIN_NAME,
    author      = "F1F88",
    description = PLUGIN_DESCRIPTION,
    version     = PLUGIN_VERSION,
    url         = "https://github.com/F1F88/"
};


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

    LoadObjectiveOffset(gamedata);
    LoadObjectiveSignature(gamedata);

    LoadObjectiveBoundarySignature(gamedata);

    LoadObjectiveManagerAddress(gamedata);
    LoadObjectiveManagerOffset(gamedata);
    LoadObjectiveManagerSignature(gamedata);

    delete gamedata;

    CreateConVar("sm_nmrih_objective_version", PLUGIN_VERSION, PLUGIN_DESCRIPTION, FCVAR_SPONLY | FCVAR_DONTRECORD);

    PrintToServer("****************** NMRIH Objective Utils Initialize Complete ******************");
}
