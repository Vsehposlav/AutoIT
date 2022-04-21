
$ini = @ScriptDir & "\autologin.ini"
$fileExists = FileExists($ini)
;MsgBox(64,"",$ini & " + " & $fileExists)
$data = FileRead($ini)
;MsgBox(64,"data", $data)
If Not $fileExists Then CreateINI()

ScanWindow()

Func ScanWindow()
   $username = IniRead($ini,"AUTOLOGIN","username", "1")
   $password = IniRead($ini,"AUTOLOGIN","password", "1")
   $persistent = IniRead($ini,"AUTOLOGIN","persistent", "1")

While True

$authhandle = WinWaitActive("[CLASS:TConnectForm]", "")
Sleep(100)

ControlSetText($authhandle, "", "[CLASS:TEdit; INSTANCE:2]", $username)
ControlSetText($authhandle, "", "[CLASS:TEdit; INSTANCE:1]", $password)
ControlClick($authhandle,"", "[CLASS:TBitBtn; INSTANCE:2]")
$authhandle = Null
If $persistent = 0 Then Exit
Sleep(5000)
WEnd
EndFunc

Func CreateINI()
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=C:\Users\biblio-08\Downloads\koda_1.7.3.0\Forms\INICreate.kxf
$INICreate = GUICreate("Учетные данные", 280, 142, 192, 124)
$username = GUICtrlCreateLabel("Имя пользователя", 8, 16, 100, 17)
$usernam = GUICtrlCreateInput("", 112, 16, 121, 21)
$password = GUICtrlCreateLabel("Пароль", 48, 56, 42, 17)
$passwor = GUICtrlCreateInput("", 112, 56, 121, 21)
$CreateINIFile = GUICtrlCreateButton("Сохранить", 192, 88, 75, 25)
$Label1 = GUICtrlCreateLabel("ВНИМАНИЕ! Пароль тут хранить небезопасно", 16, 120, 240, 17)
$Label2 = GUICtrlCreateLabel("Эти данные будут сохранены в", 16, 88, 160, 17)
$Label3 = GUICtrlCreateLabel("INI файле в каталоге скрипта", 16, 104, 155, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		 Case $GUI_EVENT_CLOSE
			Exit
		 Case $CreateINIFile
			$uname = GUICtrlRead($usernam)
			$pass = GUICtrlRead($passwor)
			;MsgBox(64,"ok!", $uname & " - " & $pass)
			Local $aSection[4][2] = [[2,""],["username", $uname],["password", $pass],["persistent", 1]]
			IniWriteSection($ini,"AUTOLOGIN", $aSection)
			GUIDelete($INICreate)
			Return

	EndSwitch
WEnd

EndFunc