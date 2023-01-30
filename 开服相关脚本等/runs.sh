########################################################################
#	求生之路2 Linux服务器一键开服脚本 -CentOS(7.6) -by 狐狸Mori
#	使用说明:见	狐狸@linux求生服务器搭建及说明.txt
#	有任何问题可通过以下途径询问：
#	steam:最爱小狐狸	QQ:2503904285	QQ群:693942837
#	警告：修改本脚本或其他插件问题导致的服务器问题，本人不负责解决
########################################################################
#	以下为正式程序，由于自行修改导致的问题恕不解决

#!/bin/bash
l4d2_path="l4d2"	#服务器路径
version="v5.7S" #脚本版本，方便查错

function ready_server(){
	echo "安装服务器配套环境文件中..."
	source /etc/os-release
	echo $ID
	case $ID in
	debian|ubuntu|devuan)	#Ubuntu等系统仅做此适配，其他问题请自行解决
		sudo dpkg --add-architecture i386
		sudo apt-get update
		yes | sudo apt-get install lib32gcc1 lib32stdc++6 libc6-i386 libcurl4-gnutls-dev:i386 screen zip unzip libc6-dev wget curl gcc psmisc
	;;
	
	centos|fedora|rhel)		#仅CentOS 7.6测试无问题，其他系统暂未测试
#		yum -y update	#CentOS 7.6 update后会变为CentOS 7.9,部分服务器会开服失败,如需要请取消注释(删掉最前面的#号)
		sudo yum -y install xulrunner.i686 screen zip unzip wget curl gcc psmisc
	;;

	*)
		echo "ERROR"
		return 2
	;;
	esac
	echo "服务器配套环境已安装完成！"
	return 0
}

# 返回值：0.正常	2.服务端下载失败
function ready_steamcmd(){
	cd ~
	if [ -d ~/steam ];then
		echo "已经存在一个steam文件夹"
	else
		mkdir ~/steam
	fi
	if [ -e ~/steam/steamcmd.sh ];then
		echo "已存在steamcmd"
	else
		if [ -e steamcmd_linux.tar.gz ];then
			echo "解压steamcmd..."
		else
			wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
		fi
		tar -xvzf steamcmd_linux.tar.gz -C ~/steam/
	fi
	rm -f steamcmd_linux.tar.gz
	getsteamfile=1
	for((;;)){
		~/steam/steamcmd.sh +login anonymous +force_install_dir ./$l4d2_path +app_update 222860 validate +quit
		if [ -d ~/steam/$l4d2_path/left4dead2/cfg ];then
			break
		else
			echo "下载服务端失败，正在重试..."
			getsteamfile=`expr $getsteamfile + 1`
			if [ $getsteamfile -gt 10 ];then
				echo "下载重试十次失败，请检测系统及网络问题后重试！"
				return 2
			fi
		fi
	}
	return 0
}

function write_c_file(){
	echo "//此文件为中间文件，由脚本自动生成及删除，请不要试图修改
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc, char const *argv[])
{
	char run[512] = \"\";
	char *srcds = \"$@\";
	strncat(run,srcds,strlen(srcds));
	while(1) system(run);
	return 0;
}" > write_c_file.c
}

# 返回值：1.其他错误	2.未检测到server.cfg
function server_run(){
	sv_run_path="~/steam/$l4d2_path/srcds_run -port 27015 +ip 0.0.0.0 +map c2m1_highway +exec server.cfg -tickrate 100"
	server_param=$sv_run_path
	echo "当前开服参数:$server_param"
	if [ -e ~/steam/$l4d2_path/left4dead2/cfg/server.cfg ] ;then
		timeout=10
		while test $timeout -gt 0; do
			echo "服务器将在$timeout秒后开启"
			timeout=`expr $timeout - 1`
			sleep 1
		done
		write_c_file $server_param
		gcc write_c_file.c -o $l4d2_path
		rm -f write_c_file.c
		screen -S $l4d2_path ./$l4d2_path
	else
		echo "未检测到~/steam/$l4d2_path/left4dead2/cfg/文件夹内的server.cfg文件，请确认是否放入插件"
		return 2
	fi
	return 1
}

function zipfile_copy(){
	zip1list=$(ls | grep 'addons')
	for addfile in $zip1list
	do
		if [ -d "$addfile" ];then
			cp -r addons/ ~/steam/$l4d2_path/left4dead2/
		fi
		if [ -d "cfg" ];then
			cp -r cfg/ ~/steam/$l4d2_path/left4dead2/
		fi
		if [ -d "scripts" ];then
			cp -r scripts/ ~/steam/$l4d2_path/left4dead2/
		fi
	done
	zip1dirlist=$(ls)
	for zip1dirname in $zip1dirlist
	do
		if [ -d "$zip1dirname" ];then
			cd $zip1dirname
			zipfile_copy
			cd ..
		fi
	done
}

# 返回值：0.正常	1.没有插件包
function zip_install(){
	mkdir temporary_file
	zip_list=$(ls | grep '.zip')
	if [ "$zip_list" != "" ];then
		echo "$zip_list"
		unzip -d ~/temporary_file "$zip_list"
	else
		echo "无zip插件包,请检查文件..."
		rm -rf temporary_file
		return 1
	fi
	cd ~/temporary_file
	zipfile_copy
	cd ~
	rm -rf temporary_file
	return 0
}

# 返回值：0.正常	1.运行环境安装失败	2.服务端安装失败	3.插件安装失败
function OneStepOpenServer(){
	res=$(ready_server)
	res0=`echo $?`
	if [ "$res0" == "0" ];then
		res=$(ready_steamcmd)
		res1=`echo $?`
		if [ "$res1" == "0" ];then
			echo "注意：此脚本只会读取addons、cfg、scripts三个文件夹，如有需要，请自行修改脚本"
			echo "此脚本只支持zip形式的压缩包，确认请回车"
			read nan
			res=$(zip_install)
			res2=`echo $?`
			if [ "$res2" == "0" ];then
				server_run
			else
				echo "插件安装失败,请检查压缩包格式是否正确!"
				return 3
			fi
		else
			echo "服务端下载失败..."
			return 2
		fi
	else 
		echo "服务器运行环境安装失败..."
		return 1
	fi
	echo "本脚本运行完成，自动退出..."
	return 0
}

echo "请选择需要进行的操作："
echo "1.一键开服"
echo "2.关闭服务器"
read step1
case $step1 in
1)	OneStepOpenServer	;;
2)	screen kill `screen -ls |grep $l4d2_path |awk -F . '{print $1}'|awk '{print $1}'`	;;
*)	
	echo "输入错误，脚本退出..."
	exit 1
;;
esac
exit 1