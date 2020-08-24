@echo off

rem ���������ʶ��·��

setlocal ENABLEDELAYEDEXPANSION

cd /d "%~dp0"

echo [zq]$ ______________________________________________________________________________________________________
echo [zq]$ _  V2.0 designed by zhaoqi at 2016 
echo [zq]$ _
echo [zq]$ _      #####     ##########    ############  ####      ###     #######   ############  ##########   
echo [zq]$ _   ##########   ############  ############# #####     ###   ######  ### ############# ############ 
echo [zq]$ _  ####          ###       ### ###           ######    ###  ####         ###           ###       ###
echo [zq]$ _  ###           ###       ### ###           ### ###   ### ####          ###           ###       ###
echo [zq]$ _  ############  ############  ############  ###  ###  ### ###           ############  ############ 
echo [zq]$ _   ############ ##########    ############  ###   ####### ###           ############  ##########   
echo [zq]$ _            ### ###           ###           ###    ###### ####          ###           ######        
echo [zq]$ _           #### ###           ###           ###     #####  ####         ###           ###  ###     
echo [zq]$ _   ###########  ###           ############# ###      ####   ######  ### ############# ###    ####   
echo [zq]$ _      ######    ###           ############  ###       ###     #######   ############  ###      #### 
echo [zq]$ _______________________________________________________________________________________________________



rem --------------------------------------------------------------------------------------------------------------
rem �������ļ��ж�ȡ����
:InitConfigFile
rem set ROOT=%cd%
set MAIN_FILE=%~dp0\cus.bat
rem ����·�������ļ��ȴ��û�Ŀ¼ȡ�����û���������ִ�еĵ�ǰĿ¼ȡ
set CONFIG_FILE=%UserProfile%\cusAppMapping.ini
if not exist %CONFIG_FILE% (
	set CONFIG_FILE=%~dp0\cusAppMapping.ini
) 
echo [zq]$ currently use %CONFIG_FILE%
rem ���ù�������
set inherent=ls,edit,editCommands,admin,exit
set commands=ls
FOR /F "tokens=1,2 delims==" %%i in (%CONFIG_FILE%) DO (
 set %%i=%%j
 set commands=!commands!,%%i
)
set all=!inherent!,!commands!


rem --------------------------------------------------------------------------------------------------------------
rem ����Ӧ�ó���ִ�д�����Ĭ��Ϊ1
set runTimes=1

rem ���ִ��ʱָ����Ӧ�ò�������ֱ�Ӵ򿪲�������Ӧ��Ŀ¼
set opr=%1
set num=%2

if defined opr (
	set operate=%1
	rem ���Ϊ����������������ѡ��������Ϊ������������Ӧ�ô򿪹رճ���
	echo %inherent%|findstr "%1" >nul && (
		goto SelectCmdExecute
	) || (
		rem ָ��Ҫ���г�����ٴ�(��Ӧ�ڶ���������Ĭ��Ϊ1)
		if defined num (
			set runTimes=%2
		)
		goto OpenAndExit
	)
	
)


rem --------------------------------------------------------------------------------------------------------------
rem �����б�
:ShowOperations
echo [zq]$ * Currently available operations : 
echo [zq]$ *	-- ls		(shows all commands)
echo [zq]$ *	-- edit		(edit this custom commands script,this operation needs to restart the script)
echo [zq]$ *	-- editCommands	(edit commands map file, and reload the file automatelly)
echo [zq]$ *	-- admin	(run as administrator)
echo [zq]$ *	-- ***		(custom commands)
echo [zq]$ *	-- exit		(exit system)
goto EnterTip


rem --------------------------------------------------------------------------------------------------------------
rem ��ʾ��������
:EnterTip
echo [zq]$ Please select and the click the return button��
goto SelectCmdMain


rem --------------------------------------------------------------------------------------------------------------
rem ����ѡ��
:SelectCmdMain
set operate=
set /p operate=
goto SelectCmdExecute

:SelectCmdExecute
if "%operate%" equ ""			(goto SelectCmdMain)
if "%operate%" equ "?"			(goto ShowOperations)
if "%operate%" equ "help"		(goto ShowOperations)
if "%operate%" equ "ls"			(goto ShowCmds)
if "%operate%" equ "edit"		(goto EditScript)
if "%operate%" equ "editCommands"	(goto EditCommandsMap)
if "%operate%" equ "admin"		(goto admin)
if "%operate%" equ "exit"		(goto ExitCus)
goto OpenApp


rem --------------------------------------------------------------------------------------------------------------
rem ��ʾ��ǰ��֧�ֵ���������
:ShowCmds
echo [zq]$ The command supported at present are:
echo [zq]$ 	-- %all%
goto EnterTip


rem --------------------------------------------------------------------------------------------------------------
rem �˳��������
:ExitCus
exit


rem --------------------------------------------------------------------------------------------------------------
rem �༭���ű�
:EditScript
echo [zq]$ The main script edit started...
notepad %MAIN_FILE%
echo [zq]$ The main script edited...
goto ShowCmds


rem --------------------------------------------------------------------------------------------------------------
rem �༭���ű�
:EditCommandsMap
echo [zq]$ The %CONFIG_FILE% edit started...
notepad %CONFIG_FILE%
echo [zq]$ The %CONFIG_FILE% edited...
goto InitConfigFile


rem --------------------------------------------------------------------------------------------------------------
rem ʹ�ù���Ա����
:admin
if exist "%SystemRoot%\SysWOW64" path %path%;%windir%\SysNative;%SystemRoot%\SysWOW64;%~dp0
bcdedit >nul
if '%errorlevel%' NEQ '0' (
	goto adminExecute
) else (
	echo [zq]$ This window has already run as administrator
	rem ���ؽű�Ŀ¼
	cd /d "%~dp0"
)
goto ShowCmds

rem �л�����Ա����
:adminExecute
rem %1 start "" mshta vbscript:createobject("shell.application").shellexecute("""%~0""","::",,"runas",1)(window.close)&exit
start "" mshta vbscript:createobject("shell.application").shellexecute("""%~0""","::",,"runas",1)(window.close)&exit


rem --------------------------------------------------------------------------------------------------------------
rem ��Ӧ�ú󷵻ص�Ӧ��ѡ�����
:OpenApp
echo %all%|findstr /c:"%operate%" >nul && (
	set cuscmd=!%operate%!
	if "!cuscmd!" equ "" (
		echo [zq]$ [Error]: This command [%operate%] need a property execute path
	) else (
		echo [zq]$ !cuscmd! starting...
		rem �����Ӧ�ó���·������ʹ��startֱ��ִ�ж�Ӧ·��������ֱ��ִ�ж�Ӧ����
		echo !cuscmd!|findstr ":" >nul && (
			for /l %%a in (1,1,%runTimes%) do (
				start "%operate%" !cuscmd!
			)
		) || (
			!cuscmd!
		)	
		echo [zq]$ !cuscmd! started...
	)
) || (
	cmd /c %operate%
	rem echo [zq]$ [Error]: Could not find the command : %operate%
	rem pause
)
goto ShowCmds


rem --------------------------------------------------------------------------------------------------------------
rem ��Ӧ�ú��˳��������
:OpenAndExit
echo %operate%
echo %all%|findstr %operate% >nul && (
	set cuscmd=!%operate%!
	if "!cuscmd!" equ "" (
		echo [zq]$ [Error]: This command [%operate%] need a proper execute path
		pause
		goto ShowCmds
	) else (
		echo [zq]$ !cuscmd! starting...
		rem �����Ӧ�ó���·������ʹ��startֱ��ִ�ж�Ӧ·��������ֱ��ִ�ж�Ӧ����
		echo !cuscmd!| findstr /c:":" >nul && (
			for /l %%a in (1,1,%runTimes%) do (
				start "%operate%" !cuscmd!
			)
		) || (
			!cuscmd!
		)	
		echo [zq]$ !cuscmd! started...
	)
	ping -n 1 127.0.0.1 >nul
	goto ExitCus
) || (
	cmd /c %operate%
	rem echo [zq]$ [Error]: Could not find the command : %operate%
	rem pause
	goto ShowCmds
)

  






rem ��¼�ű��޸���ʷ
rem =============================================================================
goto modifyLog
	20160808--�������Զ���ű������ڿ��������������
	20190408--����·�������ļ��ȴ��û�Ŀ¼ȡ�����û���������ִ�еĵ�ǰĿ¼ȡ
	20190409--Ϊ����Ӧ�ô���vbs�ű�������Ӧ��������������־���ڿ���̨�����ͨ��vbs�ű�ִ�п��Է�ֹ����̨�رպ�����˳������⣬�ű����·���¼
	20190417--�����������������жϣ�Ŀǰ�ж�·�����Ƿ����":"����������ǳ������û�����Ƿ���
	20200411--��������ͬʱ�������Ӧ�ý��̣���Ӧ����ΪrunTimes��Ŀǰ��֧��OpenAndExit����
:modifyLog




rem ��¼��
rem ==============================================================================
goto appendix
	��¼1:
		�����ļ�:
			cusAppMapping.ini
		�����ļ�����:
			work="C:\Users\zhaoqi1\Desktop\work"
			ie="C:\Program Files\Internet Explorer\iexplore.exe"
			mysql=net start mysql
			postman=C:\Users\zhaoqi1\AppData\Local\Postman\Update.exe --processStart "Postman.exe"
		ע������:
			·�����пո�ʱ����Ҫǰ���˫����

	��¼2:
		�����ļ�:
			����.vbs
		�ļ�˵��:
			����ĳЩ�������������̨����������־�����¹رտ���̨�����Ҳ���˳���ʹ��vbs��ʽ���Խ��
		�ļ�����:
			Dim WinScriptHost 
			Set WinScriptHost = CreateObject("WScript.Shell") 
			WinScriptHost.Run Chr(34) & "D:\Program Files\����\����.exe" & Chr(34), 0 
			Set WinScriptHost = Nothing
:appendix

