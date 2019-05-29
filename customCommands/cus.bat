@echo off

rem set commands and related paths

setlocal ENABLEDELAYEDEXPANSION

echo [zq]$ _____________________________________________________________________________________________
echo [zq]$ _  V2.0 designed by zhaoqi at 2016 
echo [zq]$ _
echo [zq]$ _   ############     #####      ###########  ############      #####      ########### 
echo [zq]$ _  ############    #########   ############# #############  ##########   #############
echo [zq]$ _         ####    ###     ###       ###      ###           ####               ###     
echo [zq]$ _        ####    ###       ###      ###      ###           ###                ###     
echo [zq]$ _       ####     ###       ###      ###      ############# ############       ###     
echo [zq]$ _      ####      ###       ###      ###      #############  ############      ###     
echo [zq]$ _     ####       ###    ######      ###      ###                     ###      ###     
echo [zq]$ _    ####         ###    #####      ###      ###                    ####      ###     
echo [zq]$ _   ############   ##########       ###      #############  ###########       ###     
echo [zq]$ _  ############      ##### ###      ###      ############      ######         ###     
echo [zq]$ _____________________________________________________________________________________________

rem read content of the config file
:InitConfigFile
rem set ROOT=%cd%
set MAIN_FILE=%~dp0\cus.bat
rem There are two possible paths for the main config file path. 1 user main path, 2 current path. I will check the user main path firstly.
set CONFIG_FILE=%UserProfile%\cusAppMapping.ini
if not exist %CONFIG_FILE% (
	set CONFIG_FILE=%~dp0\cusAppMapping.ini
) 
echo [zq]$ currently use %CONFIG_FILE%
set all=ls
FOR /F "tokens=1,2 delims==" %%i in (%CONFIG_FILE%) DO (
 set %%i=%%j
 set all=!all!,%%i
)

rem 如果执行时指定了应用参数，则直接打开参数所对应的目录
set str=%1
if defined str (
	set operate=%1
	echo %operate%
	goto OpenAndExit
)

rem 命令列表
:ShowOperations
echo [zq]$ * Currently available operations : 
echo [zq]$ *	-- ls		(shows all commands)
echo [zq]$ *	-- edit		(edit this custom commands script,this operation needs to restart the script)
echo [zq]$ *	-- editCommands	(edit commands map file, and reload the file automatelly)
echo [zq]$ *	-- ***		(custom commands)
echo [zq]$ *	-- exit		(exit system)
goto EnterTip

rem 提示输入命令
:EnterTip
echo [zq]$ Please select and the click the return button:
goto SelectCmdMain

rem 命令选择
:SelectCmdMain
set operate=
set /p operate=
if "%operate%" equ ""			(goto SelectCmdMain)
if "%operate%" equ "?"			(goto ShowOperations)
if "%operate%" equ "ls"			(goto ShowCmds)
if "%operate%" equ "edit"		(goto EditScript)
if "%operate%" equ "editCommands"	(goto EditCommandsMap)
if "%operate%" equ "exit"		(goto ExitCus)
goto OpenApp

rem 显示当前所支持的所有命令
:ShowCmds
echo [zq]$ The command supported at present are:
echo [zq]$ 	-- %all%
goto EnterTip

rem 退出命令界面
:ExitCus
exit

rem 编辑本脚本
:EditScript
echo [zq]$ The main script edit started...
notepad %MAIN_FILE%

echo [zq]$ The main script edited...
goto ShowCmds

rem 编辑本脚本
:EditCommandsMap
echo [zq]$ The %CONFIG_FILE% edit started...
notepad %CONFIG_FILE%
echo [zq]$ The %CONFIG_FILE% edited...
goto InitConfigFile

rem 打开应用后返回到应用选择界面
:OpenApp
echo %all%|findstr "%operate%" >nul
if %errorlevel%==0 (
	set cuscmd=!%operate%!
	if "!cuscmd!" equ "" (
		echo [zq]$ [Error]: This command need a property execute path
	) else (
		echo [zq]$ !cuscmd! starting...
		echo !cuscmd!|findstr ":" >nul
		if %errorlevel% equ 0 (
			start "%operate%" !cuscmd!
		) else (
			!cuscmd!
		)	
		echo [zq]$ !cuscmd! started...
	)
) else (
	cmd /c %operate%
	rem echo [zq]$ [Error]: Could not find the command : %operate%
	rem pause
)
goto ShowCmds


rem 打开应用后退出命令界面
:OpenAndExit
echo %all%|findstr %operate% >nul
if %errorlevel%==0 (
	set cuscmd=!%operate%!
	if "!cuscmd!" equ "" (
		echo [zq]$ [Error]: This command need a proper execute path
		pause
		goto ShowCmds
	) else (
		echo [zq]$ !cuscmd! starting...
		echo !cuscmd!|findstr ":" >nul
		if %errorlevel% equ 0 (
			start "%operate%" !cuscmd!
		) else (
			!cuscmd!
		)	
		echo [zq]$ !cuscmd! started...
	)
	ping -n 1 127.0.0.1 >nul
	goto ExitCus
) else (
	cmd /c %operate%
	rem echo [zq]$ [Error]: Could not find the command : %operate%
	rem pause
	goto ShowCmds
)

  






rem 记录脚本修改历史
rem =============================================================================
goto modifyLog
	20160808--创建本自定义脚本，用于快速启动常用软件
	20190408--命令路径配置文件先从用户目录取，如果没有则从命令执行的当前目录取
	20190409--为特殊应用创建vbs脚本，该类应用启动后运行日志会在控制台输出，通过vbs脚本执行可以防止控制台关闭后程序退出的问题，脚本见下方附录
	20190417--新增启动网络服务的判断，目前判断路径中是否存在":"，如果有则是程序，如果没有则是服务
:modifyLog




rem 附录:
rem ==============================================================================
goto appendix
	附录1:
		配置文件:
			cusAppMapping.ini
		配置文件内容:
			work="C:\Users\zhaoqi1\Desktop\work"
			ie="C:\Program Files\Internet Explorer\iexplore.exe"
			mysql=net start mysql
			postman=C:\Users\zhaoqi1\AppData\Local\Postman\Update.exe --processStart "Postman.exe"
		注意事项:
			路径中有空格时，需要前后加双引号

	附录2:
		特殊文件:
			龙信.vbs
		文件说明:
			由于某些程序启动后控制台会继续输出日志，导致关闭控制台后程序也会退出，使用vbs方式可以解决
		文件内容:
			Dim WinScriptHost 
			Set WinScriptHost = CreateObject("WScript.Shell") 
			WinScriptHost.Run Chr(34) & "D:\Program Files\龙信\龙信.exe" & Chr(34), 0 
			Set WinScriptHost = Nothing
:appendix

