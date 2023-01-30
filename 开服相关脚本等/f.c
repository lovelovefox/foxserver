//	本程序为批量开(可选隐藏)服程序，使用gcc编译后即可运行
//	参数请自行修改，不会的可以加 好友/群 询问
//											-by Fox.Mori
//	steam:最爱小狐狸	QQ:2503904285	QQ群:693942837
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char const *argv[])
{
	int a,b;
	pid_t pid,pid_1;
	pid = getpid();
//	printf("1.正常开服\n2.nomaster开服\n");
//	scanf("%d",&a);
//	if (a == 1)
	{
//		printf("开哪些服(二进制累加)：\n1.ast_27015\n2.ast_27016\n4.ast_27017\n8.ast_27018\n8.ast_27019\n8.ast_27020");
//		scanf("%d",&b);
//		if (b & 0x01)
		{
			printf("27015\n");
			pid_1 = getpid();
			if(pid_1 == pid)
			{
				fork();
				pid_1 = getpid();
				if(pid_1 != pid)
					system("screen -S ast_27015 ./27015");
			}
		}
//		if (b & 0x02)
		{
			printf("27016\n");
			pid_1 = getpid();
			if(pid_1 == pid)
			{
				fork();
				pid_1 = getpid();
				if(pid_1 != pid)
					system("screen -S ast_27016 ./27016");
			}
		}
//		if (b & 0x04)
		{
			printf("27017\n");
			pid_1 = getpid();
			if(pid_1 == pid)
			{
				fork();
				pid_1 = getpid();
				if(pid_1 != pid)
					system("screen -S ast_27017 ./27017");
			}
		}
//		if (b & 0x08)
		{
			printf("27018\n");
			pid_1 = getpid();
			if(pid_1 == pid)
			{
				fork();
				pid_1 = getpid();
				if(pid_1 != pid)
					system("screen -S ast_27018 ./27018");
			}
		}
//		if (b & 0x08)
		{
			printf("27019\n");
			pid_1 = getpid();
			if(pid_1 == pid)
			{
				fork();
				pid_1 = getpid();
				if(pid_1 != pid)
					system("screen -S ast_27019 ./27019");
			}
		}
//		if (b & 0x08)
		{
			printf("27020\n");
			pid_1 = getpid();
			if(pid_1 == pid)
			{
				fork();
				pid_1 = getpid();
				if(pid_1 != pid)
					system("screen -S ast_27020 ./27020");
			}
		}
//		printf("\n");
	}
#if 0
	else if (a == 2)
	{
		printf("开哪些服(二进制累加)：\n1.ast_27015\n2.ast_27016\n4.ast_27017\n8.ast_27018\n");
		scanf("%d",&b);
		if (b & 0x01)
		{
			printf("1");
			pid_1 = getpid();
			if(pid_1 == pid)
			{
				fork();
				pid_1 = getpid();
				if(pid_1 != pid)
					system("screen -S ast_27015 ./ast_27015_n");
			}
		}
		if (b & 0x02)
		{
			printf("2");
			pid_1 = getpid();
			if(pid_1 == pid)
			{
				fork();
				pid_1 = getpid();
				if(pid_1 != pid)
					system("screen -S ast_27016 ./ast_27016_n");
			}
		}
		if (b & 0x04)
		{
			printf("4");
			pid_1 = getpid();
			if(pid_1 == pid)
			{
				fork();
				pid_1 = getpid();
				if(pid_1 != pid)
					system("screen -S ast_27017 ./ast_27017_n");
			}
		}
		if (b & 0x08)
		{
			printf("8");
			pid_1 = getpid();
			if(pid_1 == pid)
			{
				fork();
				pid_1 = getpid();
				if(pid_1 != pid)
					system("screen -S ast_27018 ./ast_27018_n");
			}
		}
		printf("\n");
	}
	else
		printf("输入有误\n");
	return 0;
}
#endif