#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <colors>

Handle hSITimer = INVALID_HANDLE;
ConVar g_hHostName;
ConVar HostIP;

public Plugin myinfo = 
{
	name 			= "si_info",
	author 			= "Fox.Mori",
	description 	= "服务器刷新提示",
	version 		= "1.2",
	url 			= "https://steamcommunity.com/id/2503904285/"
}

public void OnPluginStart()
{
	RegConsoleCmd("sm_info",STime_Display,"特感刷新提示");
	hSITimer = CreateConVar("ast_sitimer","0","特感刷新速率");
	HostIP = CreateConVar("ast_hostip","","服务器IP");
}

public Action STime_Display(int client,int args)
{
	char H_name[128];
	g_hHostName = FindConVar("hostname");
	g_hHostName.GetString(H_name,sizeof(H_name));
	PrintToChatAll("\x01\x04[狐狸狸Ast]\x05狐狸狸提醒您:");
	PrintToChatAll("\x01\x04[狐狸狸Ast]\x05当前服务器:\x03%s",H_name);

	char IP[32];//GetConVarString(HostIP);
	HostIP.GetString(IP,sizeof(IP));
	PrintToChatAll("\x01\x04[狐狸狸Ast]\x05服务器IP为:\x03%s",IP);

	int param = GetConVarInt(hSITimer);
	int difficulty = GetConVarInt(FindConVar("das_fakedifficulty"));
	switch(difficulty){
		case 1:
		{
			switch(param){
				case 0:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","4秒3特");}
				case 1:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","4秒3特");}
				case 2:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","3秒3特");}
				case 3:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","3秒3特");}
				case 4:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","3秒4特");}
				case 5:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","3特 特感速递");}
				case 6:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","4特 特感速递");}
			}
		}
		case 2:
		{
			switch(param){
				case 0:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","8秒3特");}
				case 1:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","10秒4特");}
				case 2:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","10秒4特");}
				case 3:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","8秒4特");}
				case 4:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","6秒4特");}
				case 5:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","4特 特感速递");}
				case 6:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","5特 特感速递");}
			}
		}
		case 3:
		{
			switch(param){
				case 0:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","16秒5特");}
				case 1:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","14秒5特");}
				case 2:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","12秒5特");}
				case 3:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","14秒6特");}
				case 4:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","14秒7特");}
				case 5:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","5特 特感速递");}
				case 6:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","6特 特感速递");}
			}
		}
		case 4:
		{
			switch(param){
				case 0:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","18秒6特");}
				case 1:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","14秒6特");}
				case 2:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","12秒6特");}
				case 3:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","12秒7特");}
				case 4:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","12秒8特");}
				case 5:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","6特 特感速递");}
				case 6:{PrintToChatAll("\x04[狐狸狸Ast]\x05当前特感刷新速度为:\x03%s","7特 特感速递");}
			}
		}
	}
}
