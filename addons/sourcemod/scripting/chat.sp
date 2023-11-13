ArrayList chathistory;

public void OnPluginStart()
{
	chathistory = CreateArray(512);
	AddCommandListener(OnSayCmd,"say");
	RegConsoleCmd("showchat",ShowChat);
}

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

stock void SendMsg_KeyHintMsg(int client, char[] format, any ...)
{
	Handle keyhint = INVALID_HANDLE;
	
	if(!client)
	{
		keyhint = StartMessageAll("KeyHintText");
	}
	else
	{
		keyhint = StartMessageOne("KeyHintText", client);
	}
	
	if (keyhint != INVALID_HANDLE)
	{
		char str[256];
		VFormat(str, 256, format, 3);
		BfWriteByte(keyhint,1);
		BfWriteString(keyhint, str);//Message
		EndMessage();
	}
}

public void DisplayChatHistory(int client)
{
	char history[256];
	char gotten[64];
	for(int i = 0; i < chathistory.Length; i++)
	{
		GetArrayString(chathistory,i,gotten,512);
		StrCat(history,256,gotten);
		StrCat(history,256,"\n");
	}
	SendMsg_KeyHintMsg(client,history);
}

public Action ShowChat(int client, int args)
{
	DisplayChatHistory(client);
	return Plugin_Handled;
}

public Action OnSayCmd(int client, const char[] command, int args)
{
	char name[64];
	GetClientName(client,name,64);
	char text[64];
	GetCmdArgString(text,64);
	char message[64];
	FormatEx(message,64,"%s: %s",name,text);
	PushArrayString(chathistory,message);
	if(chathistory.Length > 8)
	{
		RemoveFromArray(chathistory,0);
	}
	DisplayChatHistory(0);
	return Plugin_Handled;
}