#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <forum_api>
#include <vip_core>

KeyValues KV;

public Plugin myinfo =
{
    name        = 	"Forum - VIP By R1KO",
    author      = 	"GARAYEV",
	version     =   "1.0",
	url         = 	"www.garayev-sp.ru | Discord: GARAYEV#9999 | www.progaming.ba"
};

public void OnPluginStart()
{
    char szPath[PLATFORM_MAX_PATH];
    KV = new KeyValues("forum_vip");
    BuildPath(Path_SM, szPath, sizeof(szPath), "configs/forum_vip.ini");

    if(!KV.ImportFromFile(szPath))
        SetFailState("[Forum VIP] - Файл конфигураций не найден");
}

public void Forum_OnInfoProcessed(int client, const char[] name, int primarygroup, ArrayList secondarygroups)
{
    ArrayList aSecondary = secondarygroups;
    
    char sForumGroup[32];
    
    if (aSecondary == null)
    {
        aSecondary = Forum_GetClientSecondaryGroups(client);
    }
    
    KV.Rewind();

    if(KV.GotoFirstSubKey(true))
    {
        do
        {
            char sId[32];

            KV.GetSectionName(sId,sizeof(sId));

            for (int i = 0; i < aSecondary.Length; i++)
	        {
                int iForumGroup = aSecondary.Get(i);
                IntToString(iForumGroup, sForumGroup, sizeof(sForumGroup));
                
                if(!strcmp(sForumGroup, sId))
                {
                    char sVGroup[32];
                    KV.GetString("group", sVGroup, sizeof(sVGroup));
                    VIP_GiveClientVIP(0, client, 0, sVGroup, false);
                    return;
                }
            }
        }
        while(KV.GotoNextKey(true));
    }
}