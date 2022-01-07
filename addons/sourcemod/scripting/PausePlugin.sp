#pragma semicolon 1
#include <cstrike>
#include <sourcemod>
#include <sdktools>
#include <colors>

/** Global Variables **/
/**int g_vcount[4]; 
Handle g_vtrack_timer;
**/

public Plugin:myinfo = {
    name = "CS:GO Pause Commands",
    author = "splewis & ^kS",
    description = "Adds simple pause/unpause commands for players",
    version = "1.0.4",
    url = "https://github.com/ksgoescoding/PausePlugin"
};

public void OnPluginStart() {
    /** Load Translations **/
    LoadTranslations("pauseplugin.phrases");
    
    /** Admin Commands **/
    RegAdminCmd("sm_forcetechpause", Command_ForceTechPause, ADMFLAG_GENERIC, "Forces a technical pause");
    RegAdminCmd("sm_forcetechnical", Command_ForceTechPause, ADMFLAG_GENERIC, "Forces a technical pause");
    RegAdminCmd("sm_ftech", Command_ForceTechPause, ADMFLAG_GENERIC, "Forces a technical pause");
    RegAdminCmd("sm_ftec", Command_ForceTechPause, ADMFLAG_GENERIC, "Forces a technical pause");
    RegAdminCmd("sm_ft", Command_ForceTechPause, ADMFLAG_GENERIC, "Forces a technical pause");
    RegAdminCmd("sm_forcepause", Command_ForcePause, ADMFLAG_GENERIC, "Forces a pause");
    RegAdminCmd("sm_fp", Command_ForcePause, ADMFLAG_GENERIC, "Forces a pause");
    RegAdminCmd("sm_forceunpause", Command_ForceUnpause, ADMFLAG_GENERIC, "Forces an unpause");
    RegAdminCmd("sm_fup", Command_ForceUnpause, ADMFLAG_GENERIC, "Forces an unpause");
   
    /** Pause Commands **/
    RegConsoleCmd("sm_pause", Command_Pause, "Requests a pause");
    RegConsoleCmd("sm_p", Command_Pause, "Requests a pause");
    RegConsoleCmd("sm_tac", Command_Pause, "Requests a pause");
    RegConsoleCmd("sm_tactical", Command_Pause, "Requests a pause");

    /** Technical Pause Commands **/
    RegConsoleCmd("sm_tech", Command_TechPause, "Calls for a tech pause");
    RegConsoleCmd("sm_t", Command_TechPause, "Requests a pause");

    /** Unpause Commands **/
    RegConsoleCmd("sm_unpause", Command_TechUnpause, "Requests an unpause");
    RegConsoleCmd("sm_up", Command_TechUnpause, "Requests an unpause");
}

/** Force Tech Pause **/
public Action Command_ForceTechPause(int client, int args){
    if (IsPaused())
        return Plugin_Handled;

    ServerCommand("mp_pause_match");
    PrintToChatAll("%t", "ForceTechPauseMessage", client);
    return Plugin_Handled;
}

/** Force Pause **/
public Action Command_ForcePause(int client, int args) {
    if (IsPaused())
        return Plugin_Handled;

    ServerCommand("mp_pause_match");
    PrintToChatAll("%t", "ForcePause", client);
    return Plugin_Handled;
}

/** Force Unpause **/
public Action Command_ForceUnpause(int client, int args) {
    if (!IsPaused())
        return Plugin_Handled;
    
    ServerCommand("mp_unpause_match");
    PrintToChatAll("%t", "ForceUnpause", client);
    return Plugin_Handled;
}

/** Technical Pause **/
public Action Command_TechPause(int client, int args){
    if (IsPaused())
        return Plugin_Handled;

    ServerCommand("mp_pause_match");
    PrintToChatAll("%t", "TechPauseMessage", client, client);
    return Plugin_Handled;
}

/** Technical Unpause **/
public Action Command_TechUnpause(int client, int args){
    if (IsPaused())
        return Plugin_Handled;

    ServerCommand("mp_unpause_match");
    PrintToChatAll("%t", "TechUnpauseMessage", client, client);
    return Plugin_Handled;
}

/** Pause Command **/
public Action Command_Pause(int client, int args)
{
    if (IsPaused() || !IsValidClient(client))
    {
        // Is the game paused or is the client invalid? Terminate process.
        return Plugin_Handled;
    }

    if(GetClientTeam(client) == CS_TEAM_T)
    {
        ServerCommand("timeout_terrorist_start");
        PrintToChatAll("%t", "Pause", client);
        
        return Plugin_Handled;
    }
    
    else if(GetClientTeam(client) == CS_TEAM_CT)
    {
        ServerCommand("timeout_ct_start");
        PrintToChatAll("%t", "Pause", client);
        
        return Plugin_Handled;
    }

    return Plugin_Continue;
}	    

/** Valid client state **/
stock bool:IsValidClient(client) 
{
    if (client > 0 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client))
        return true;
    return false;
}