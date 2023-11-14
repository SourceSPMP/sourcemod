#include <sourcemod>
#include <sdktools>

stock void SendMsg_HintMsg(int client, char[] format, any ...)
{
	Handle hint = INVALID_HANDLE;
	
	if(!client)
	{
		hint = StartMessageAll("HintText");
	}
	else
	{
		hint = StartMessageOne("HintText", client);
	}
	
	if (hint != INVALID_HANDLE)
	{
		char str[253];
		VFormat(str, 253, format, 3);
		BfWriteByte(hint,1);
		BfWriteString(hint, str);//Message
		EndMessage();
	}
}

public OnClientDisconnect(int client)
{
	char name[64];
	GetClientName(client,name,64);
	SendMsg_HintMsg(0,"%s left the server",name);
}


public OnClientConnected(int client)
{
	char name[64];
	GetClientName(client,name,64);
	SendMsg_HintMsg(0,"%s joined the server",name);
}