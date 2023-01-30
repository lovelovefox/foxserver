########################################################################
#	求生之路2 Linux服务器一键开服脚本 -CentOS(7.6) -by 狐狸Mori
#	使用说明:见	狐狸@linux求生服务器搭建及说明.txt
#	如果服务器异常关机或其他情况，请参考说明解决
#	有任何问题可通过以下途径询问：
#	steam:最爱小狐狸	QQ:2503904285	QQ群:693942837
#	警告：修改本脚本或其他插件问题导致的服务器问题，本人不负责解决
########################################################################
#	以下为正式程序，由于自行修改导致的问题恕不解决

#!/bin/bash
l4d2_path="l4d2"	#服务器路径，且screen以该路径命名
version="v5.7B" #脚本版本，方便查错

# 返回值：2.运行环境安装失败
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
}

# 返回值：2.下载服务端失败
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

# 返回值：2.参数选择错误
function server_update(){
	srcdslist=$(ls | grep 'srcds_run')
	for srcdsfile in $srcdslist
	do
		echo "$srcdsfile"
		uppath=$(pwd)
		case $update_step3 in
		1)
			"$path"/steamcmd.sh +login anonymous +force_install_dir "$uppath" +app_update 222860 validate +quit
		;;

		2)
			"$path"/steamcmd.sh +login anonymous +force_install_dir "$uppath" +app_update 222860 +quit
		;;
		
		*)
			echo "ERROR"
			return 2
		;;
		esac
	done
	dirlist=$(ls)
	for dirname in $dirlist
	do
		if [ -d "$dirname" ];then
			cd $dirname
			server_update
			cd ..
		fi
	done
	return 0
}

function find_steamcmd(){
	slist=$(ls | grep 'steamcmd.sh')
	for sfile in $slist
	do
		echo "$sfile"
		path=$(pwd)
		echo "$path"
		cd $path
		server_update
	done
	sdirlist=$(ls)
	for sdirname in $sdirlist
	do
		if [ -d "$sdirname" ];then
			cd $sdirname
			find_steamcmd
			cd ..
		fi
	done
}

function copyfile(){
	copylist=$(ls | grep "$copyfilename")
	for copyfiles in $copylist
	do
		echo "文件:$copyfiles"
		cd ..
		path=$(pwd)
		echo "文件位置:"
		cd -
		if [ $path != "~/steam" ] && [ $path != "/" ]; then
			cp ~/"$copyfilename" ./
			echo "$path 已复制"
		fi
	done
	copydirlist=$(ls)
	for copydirname in $copydirlist
	do
		if [ -d "$copydirname" ];then
			cd $copydirname
			copyfile
			cd ..
		fi
	done
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

# 返回值：2.server.cfg未找到	9.开服功能输入错误
function server_run(){
	sv_run_path="~/steam/$l4d2_path/srcds_run -port 27015 +ip 0.0.0.0 +map c2m1_highway +exec server.cfg -tickrate 100"
	echo "请输入开服路径及参数,如不给定将使用默认值."
	echo "默认值:$sv_run_path"
	read server_param
	if [ "$server_param" == "" ];then
		server_param=$sv_run_path
	fi
	echo "当前开服参数:$server_param"
	echo "请确认启动参数！如发现参数有误，请使用“Ctrl C”结束脚本，若无问题请回车确认"
	read nan
	if [ -e ~/steam/$l4d2_path/left4dead2/cfg/server.cfg ] ;then
		server_file_confirm="y"
	else
		echo "未检测到~/steam/$l4d2_path/left4dead2/cfg/文件夹内的server.cfg文件，请确认是否放入插件"
		echo "输入y跳过检测，输入其他将结束脚本"
		read server_file_confirm
	fi
	if [ "$server_file_confirm" != "y" -a "$server_file_confirm" != "Y" ] ;then
		return 2
	fi
	
	echo "是否需要本脚本自带的崩溃重启功能："
	echo "1.需要"
	echo "2.不需要"
	read bkcq
	timeout=10
	while test $timeout -gt 0; do
		echo "服务器将在$timeout秒后开启"
		timeout=`expr $timeout - 1`
		sleep 1
	done
	case $bkcq in
	1) 
		write_c_file $server_param
		gcc write_c_file.c -o $l4d2_path
		rm -f write_c_file.c
		screen -S $l4d2_path ./$l4d2_path
	;;

	2)	screen -S $l4d2_path $server_param	;;

	*)	return 9	;;
	esac
	return 0
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

# 返回值：1.zip未找到	2.tar.gz未找到
function zip_install(){
	return_num=0
	mkdir temporary_file
	zip_list=$(ls | grep '.zip')
	if [ "$zip_list" != "" ];then
		echo "$zip_list"
		unzip -d ~/temporary_file "$zip_list"
	else
		echo "无zip插件包，即将检测tar插件包..."
		return_num=1
		tar_list=$(ls | grep 'tar.gz')
		if [ "$tar_list" != "" -a "$tar_list" != "steamcmd.tar.gz" ];then
			echo "$tar_list"
			tar -xvzf "$tar_list" -C ~/temporary_file
		else
			echo "tar插件包未找到..."
			return_num=2
		fi
	fi
	cd ~/temporary_file
	zipfile_copy
	cd ~
	rm -rf temporary_file
	return return_num
}

function pack_backup(){
	packlist=$(ls | grep 'srcds_run')
	for packfile in $packlist
	do
		echo "$packfile"
		packpath=$(pwd)
		cd left4dead2
		if [ $pack_backup_step != "y" -a $pack_backup_step != "Y" ];then
			zip -r $packpath.zip addons/ cfg/ scripts/
		else
			zip -r $packpath.zip addons/ cfg/ scripts/ -x='*.vpk'
		fi
		mv $packpath.zip ~
		cd -
	done
	pack_back_list=$(ls)
	for pack_back_name in $pack_back_list
	do
		if [ -d "$pack_back_name" ];then
			cd $pack_back_name
			pack_backup
			cd ..
		fi
	done
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

if [ "$1" == "" ];then
	echo "请选择需要进行的操作："
	echo "1.安装求生之路服务器配套环境(已适配各类Linux系统但不保证完全能用)"
	echo "2.一键开服(Ast/Hunters/Zone/普通服务器一键开服 -by Mori)"
	echo "3.更新现有服务器下面所有求生之路服务端文件"
	echo "4.复制某一文件到所有服务端(查找所有同名文件并替换)"
	echo "5.\"仅安装服务端\" 或 \"仅安装插件\" 或 \"仅开服\""
	echo "6.备份服务器插件(默认以服务器文件最后一级路径命名)"
	echo "7.关闭服务器"
	read step1
else
	step1=$1
fi
case $step1 in
1)
	res=$(ready_server)
	res0=`echo $?`
	if [ "$res0" == "2" ];then
		echo "服务器运行环境安装失败..."
	fi
;;

2)
	echo "请选择需要进行的开服操作："
	echo "1.已有插件包并已上传文件，一键开服"
	echo "2.无插件搭建 AstMod 一键开服(网站有时候会失效，自己进脚本修改一下)"
	echo "3.无插件搭建 HuntersMod 一键开服(网站有时候会失效，自己进脚本修改一下)"
	echo "4.无插件搭建 ZoneMod 一键开服(最新版，可能不稳定)"
	echo "5.自选网站下载插件包一键开服(可能由于文件原因无法正常安装插件)"
	if [ "$2" == "" ];then
		read step2
	else
		step2=$2
	fi
	case $step2 in
	1)
		OneStepOpenServer
	;;
	
	2)
		echo "AstMod 插件准备中..."
		wget https://dl.hykq.cc/L4D2/AstMod/AstMod%20v2.6.3.tar.gz
		OneStepOpenServer
	;;

	3)
		echo "HuntersMod 插件准备中..."
		wget https://dl.hykq.cc/L4D2/Hunter/%20Hunter%E3%81%AE%E8%A8%93%E7%B7%B4%20v1.1.1%20For%20Linux%20%2822.09.03%29.tar.gz
		OneStepOpenServer
	;;

	4)
		echo "ZoneMod 插件准备中..."
		wget https://github.com/SirPlease/L4D2-Competitive-Rework/archive/refs/heads/master.zip
		OneStepOpenServer
	;;

	5)
		if [ "$3" == "" ];then
			echo "请输入网址：(注意是插件下载网址不是查看网址，目前只支持zip和tar.gz的压缩包)"
			read web_url
		else
			web_url=$3
		fi
		wget $web_url
		OneStepOpenServer
	;;

	*)
		echo "输入错误，脚本退出..."
		exit 2
	;;
	esac
;;

3)
	if [ "$2" == "" ];then
		echo "请选择升级方式："
		echo "1.覆盖更新"
		echo "2.仅升级"
		read update_step3
	else
		update_step3=$2
	fi
	find_steamcmd
	if [ "$3" == "" ];then
		echo "所有服务端已升级完成，是否重启"
		echo "需要重启请直接回车，若不需要，请输入任意字符"
		read update_read_cq
	else
		update_read_cq=$3
	fi
	if [ "$update_read_cq" == "" ];then
		killall srcds_linux
		echo "服务器已重启，请耐心等待"
	else
		echo "请手动重启服务器完成更新"
	fi
;;

4)
	if [ "$2" == "" ];then
		echo "请输入需要复制的文件名..."
		read copyfilename
	else
		copyfilename=$2
	fi
	copyfile
	echo "文件复制完成"
;;

5)
	if [ "$2" == "" ];then
		echo "1.安装服务端"
		echo "2.解压、安装插件"
		echo "3.开服"
		read step5
	else
		step5=$2
	fi
	case $step5 in 
	1)
		res=$(ready_steamcmd)
		res1=`echo $?`
		if [ "$res1" == "2" ];then
			echo "服务端下载失败..."
		fi
	;;
	
	2)
		echo "注意：此脚本只会读取addons、cfg、scripts三个文件夹，如有需要，请自行修改脚本"
		echo "此脚本只支持zip与tar.gz形式的压缩包，鉴于tar问题较多，建议使用zip，确认请回车"
		read nan
		res=$(zip_install)
		res2=`echo $?`
		if [ "$res2" == "2" ];then
			echo "插件安装失败,请检查压缩包格式是否正确!"
		fi
	;;
	
	3)
		server_run
	;;
	
	*)
		echo "输入错误，脚本退出..."
		exit 2
	;;
	esac
;;

6)
	if [ "$2" == "" ];then
		echo "是否忽略vpk文件，忽略请输入y，默认不忽略"
		read pack_backup_step
	else
		pack_backup_step=$2
	fi
	pack_backup
;;

7)
	screen kill `screen -ls |grep $l4d2_path |awk -F . '{print $1}'|awk '{print $1}'`
;;

*)
	echo "输入错误，脚本退出..."
	exit 2
;;
esac

exit 0