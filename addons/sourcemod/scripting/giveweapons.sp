#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

public void OnPluginStart()
{
	HookEvent("player_spawn",PlayerSpawned);
}

public Action PlayerSpawned(Event event, const char[] name, bool dontbroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));

	for(int i=1;i<40;i++){
		GivePlayerAmmo(client,6000,i,true);
	}
	
	GivePlayerItem(client,"weapon_smg1");
	GivePlayerItem(client,"weapon_crowbar");
	GivePlayerItem(client,"weapon_stunstick");
	GivePlayerItem(client,"weapon_physcannon");
	GivePlayerItem(client,"weapon_pistol");
	GivePlayerItem(client,"weapon_357");
	GivePlayerItem(client,"weapon_ar2");
	GivePlayerItem(client,"weapon_shotgun");
	GivePlayerItem(client,"weapon_frag");
	GivePlayerItem(client,"weapon_crossbow");
	GivePlayerItem(client,"weapon_rpg");
	GivePlayerItem(client,"item_suit");
	
	return Plugin_Continue;
}