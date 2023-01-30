//这不是个可执行文件，需要编译成可执行文件才能使用
//这个文件内仅用来保存服务端路径及开服参数
//除开服参数及开服路径外请勿修改其他内容
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc, char const *argv[])
{
	//服务端路径
	char *l4d2path = "/root/steam/l4d2/";
	//开服参数
	char *srcds = "srcds_run -port 27015 +ip 0.0.0.0 +map c2m1_highway +exec server.cfg -tickrate 100";
	char run[512] = "";
	strncpy(run,l4d2path,strlen(l4d2path));
	strncat(run,srcds,strlen(srcds));
	while(1)
		system(run);
	return 0;
}