#include <sourcemod>
#include <sdktools>


int lastground[33];

public void OnGameFrame()
{
	for (int i=1; i<=MaxClients; i++)
	{
		if (IsValidEdict(i))
		{
			int newground = GetEntPropEnt(i, Prop_Data, "m_hGroundEntity");
			if ((newground == -1 && newground != lastground[i] && (GetClientButtons(i) & IN_JUMP)) || (newground == 0 && (GetClientButtons(i) & IN_JUMP)))
			{
				float vel[3];
				GetEntPropVector(i, Prop_Data, "m_vecVelocity", vel);

				vel[0] *= 1.25;
				vel[1] *= 1.25;
				vel[2] = 200.0;
				
				SetEntPropEnt(i, Prop_Data, "m_hGroundEntity", -1);
				
				TeleportEntity(i, NULL_VECTOR, NULL_VECTOR, vel);
			}
			
			lastground[i] = newground;
		}
	}
}