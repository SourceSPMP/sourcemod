#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

#define loop(%0,%1) for(int %0 = 0; %0 < %1; %0++)

public void OnPluginStart()
{
	HookEvent("player_spawn",PlayerSpawned);
}

bool isspawned[33] = {false};

public void OnMapStart()
{
	loop(i,33)
	{
		isspawned[i] = false;
	}
}

public OnClientDisconnect(int client)
{
	isspawned[client] = false;
}

public Action PlayerSpawned(Event event, const char[] name, bool dontbroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));
	if(!isspawned[client])
	{
		SDKHook(client,SDKHook_OnTakeDamage,OnDamage);
		isspawned[client] = true;
	}
	return Plugin_Continue;
}

public Action grenadeboost(Handle timer,int entity)
{
	if(entity > 0 && IsValidEdict(entity))
	{
		float min = 20000000000.0;
		int best = -1;
		float pos[3];
		float eyes[3];
		GetEntPropVector(entity,Prop_Send,"m_vecOrigin",pos);
		for(int i=1;i<=MaxClients;i++)
		{
			if(IsValidEdict(i) && IsClientInGame(i))
			{
				GetClientEyePosition(i,eyes);
				float dist = GetVectorDistance(eyes,pos,true);
				if(min>dist)
				{
					min = dist;
					best = i;
				}
			}
		}
		float vel[3];
		GetEntPropVector(best,Prop_Data,"m_vecVelocity",vel);
		float vel2[3];
		GetEntPropVector(entity,Prop_Data,"m_vecVelocity",vel2);
		vel2[0] += vel[0];
		vel2[1] += vel[1];
		vel2[2] += vel[2];
		TeleportEntity(entity,NULL_VECTOR,NULL_VECTOR,vel2);
	}
	return Plugin_Continue;
}


public void OnEntityCreated(int entity, const char[] classname)
{
	if(StrEqual(classname,"grenade_ar2"))
	{
		CreateTimer(0.0,grenadeboost,entity);
	}
}

public Action OnDamage(int victim, int& attacker, int& inflictor, float& damage, int& damageType,int& weapon,float damageForce[3],float damagePosition[3])
{
	if(victim<=MaxClients)
	{		
		if(attacker == victim || damageType&32 == 32)
		{
			float vel[3];
			GetEntPropVector(victim, Prop_Data, "m_vecVelocity", vel);
			vel[0] += damageForce[0]/20.0;
			vel[1] += damageForce[1]/20.0;
			vel[2] += damageForce[2]/20.0;
			TeleportEntity(victim,NULL_VECTOR,NULL_VECTOR,vel);
			return Plugin_Handled;
		}
	}
	return Plugin_Continue;
}