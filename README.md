# windows-utils
designed by Spencer Zhao

# 功能说明
在命令行输入cus+软件标识，可直接启动对应程序或服务。无需鼠标各种点击或者查找

# 使用方法
## 1. 下载文件
将cus.bat和cusAppMapping.ini文件拷贝到windows用户目录下（例如："C:\Users\user"）
## 2. 配置文件修改
修改cusAppMapping.ini文件，将需要映射的程序启动地址写入
## 3. 启动（Win+R中输入）
- 在输入框输入cus，直接回车，可按提示一个一个启动应用程序
- 在输入框输入cus [软件关键字]，可直接启动该软件，并自动关掉命令提示窗口
- 在输入框输入cus [软件关键字] [启动数量]，可以启动该软件多个实力，用来软件多开

# 配置说明
## 配置文件:
cusAppMapping.ini
## 配置文件内容示例:
#### 1.路径无空格，例如打开一个文件夹
```
work=="C:\Users\user\Desktop\work" 或 work==C:\Users\user\Desktop\work
```
#### 2.路径有空格，需要加双引号，例如打开微信：
```
wx=="D:\Program Files\Tencent\WeChat\WeChat.exe"
```
#### 3.程序启动项需要跟参数的情况，直接跟参数即可，例如打开postman或chrome浏览器
```
postman==C:\Users\user\AppData\Local\Postman\Update.exe --processStart "Postman.exe"
chrome=="C:\Program Files\Google\Chrome\Application\chrome.exe" -ignore-certificate-errors
```
#### 4.程序启动时需要指定运行目录的情况，可以加/d [启动路径]，例如启动sd
```
sd==/d "G:\Program Files\SD启动器安装\sd-webui-aki\sd-webui-aki-v4.1" "A启动器.exe"
```
#### 5.运行一个服务，例如启动mysql：
```
mysql==net start mysql
```
#### 6.启动某个网页，需要使用双叹号来引用浏览器的启动项，例如启动jira：
```
chrome=="C:\Program Files\Google\Chrome\Application\chrome.exe"
jira==!chrome! "https://jira.xxxxxxx.net/secure/Tempo.jspa#/my-work/week?type=LIST"
```
  
## 注意事项:
  路径中有空格时，需要前后加双引号
  路径中如果用到其他路径，则可以使用"!其他路径!"的方式进行引用

## 特殊情况：
由于某些程序启动后控制台会继续输出日志，导致关闭控制台后程序也会退出，使用vbs方式可以解决：
例如AAA.exe文件有这个问题，可以编写AAA.vbs脚本，通过启动vbs脚本来启动程序。文件内容:
```
Dim WinScriptHost 
Set WinScriptHost = CreateObject("WScript.Shell") 
WinScriptHost.Run Chr(34) & "D:\Program Files\AAA\AAA.exe" & Chr(34), 0 
Set WinScriptHost = Nothing
```
