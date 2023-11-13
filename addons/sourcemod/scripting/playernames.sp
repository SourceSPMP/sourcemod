#include <sourcemod>
#include <sdktools>


stock void SendMsg_HudMsg(int client, char[] format, int channel, 
        float x = -1.0, float y = -1.0, float holdtime = 0.1,
		int colorA = 0xffffffff, int colorB = 0xffffffff,
        int effect = 0, 
        float fadein = 0.0, float fadeout = 0.0, float fxtime = 0.1, any ...)
{
    Handle hudmsg = INVALID_HANDLE;
    
    if(!client)
	{
        hudmsg = StartMessageAll("HudMsg");
    }
	else
	{
        hudmsg = StartMessageOne("HudMsg", client);
    }
    
    if(hudmsg != INVALID_HANDLE)
	{
		BfWriteByte(hudmsg, channel);//channel
		BfWriteFloat(hudmsg, x);//x ( -1 = center )
		BfWriteFloat(hudmsg, y);//y ( -1 = center )
		
		BfWriteNum(hudmsg, colorA);
		BfWriteNum(hudmsg, colorB);
		
		BfWriteByte(hudmsg, effect);//effect (0 is fade in/fade out; 1 is flickery credits; 2 is write out)
		BfWriteFloat(hudmsg, fadein);//fadeinTime (message fade in time - per character in effect 2)
		BfWriteFloat(hudmsg, fadeout);//fadeoutTime
		BfWriteFloat(hudmsg, holdtime);//holdtime
		BfWriteFloat(hudmsg, fxtime);//fxtime (effect type(2) used)
		
		char str[256];
		VFormat(str, 256, format, 13);
		BfWriteString(hudmsg, str);//Message
		
		EndMessage();
    }
}

public bool TraceExcept(int entity, int contentsMask, int data)
{
	return data != entity;
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon, int &subtype, int &cmdnum, int &tickcount, int &seed, int mouse[2])
{
	float pos[3];
	GetClientEyePosition(client,pos);
	TR_TraceRayFilter(pos,angles,MASK_PLAYERSOLID,RayType_Infinite,TraceExcept,client);
	int hitent = TR_GetEntityIndex(INVALID_HANDLE);
	if(IsValidEdict(hitent) && hitent > 0 && hitent <= MaxClients)
	{
		char name[64];
		GetClientName(hitent,name,64);
		SendMsg_HudMsg(client,name,1,-1.0,-1.0,0.06,0xff0080ff,0xff0080ff);
	}
}