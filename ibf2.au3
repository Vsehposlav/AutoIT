#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <Array.au3>
#include <StaticConstants.au3>
dim $sArray, $DBNArray[0], $liststring

#Region ### START Koda GUI section ### Form=C:\Users\biblio-08\Downloads\koda_1.7.3.0\Forms\IBF.kxf
$IBFEd = GUICreate("IBF editor", 615, 438, 192, 124)
$OpenIBF = GUICtrlCreateButton("OpenIBF", 8, 8, 107, 25)
GUICtrlSetTip(-1, "Открыть IBF файл")
$SaveIBF = GUICtrlCreateButton("SaveIBF", 117, 8, 107, 25)
GUICtrlSetTip(-1, "Сохранить IBF файл")
$CommandsList = GUICtrlCreateList("", 8, 40, 217, 383, BitOR($LBS_NOTIFY,$WS_VSCROLL,$WS_BORDER))
GUICtrlSetData(-1, "ClearDB - Опустошить базу данных|NewDB - Создать новую БД|OpenDB - Открыть базу данных|DeleteDB - удалить базу данных|CloseDB - закрыть текущю базу данных")
$AddStr = GUICtrlCreateButton("Добавить", 240, 144, 67, 25)
$ListQueue = GUICtrlCreateList("", 320, 16, 281, 409, BitOR($LBS_NOTIFY,$WS_VSCROLL,$WS_BORDER))
$DelStr = GUICtrlCreateButton("Удалить", 240, 176, 67, 25)
$SetINI = GUICtrlCreateButton("Set irbis_server.ini", 232, 8, 83, 41, $BS_MULTILINE)
$LabelCurrent = GUICtrlCreateLabel("Текущая БД", 240, 80, 68, 17)
$LabelCurrentDB = GUICtrlCreateLabel("UNDEFINED", 240, 104, 67, 17, $SS_CENTER)
$Expert = GUICtrlCreateCheckbox("Эксперт", 240, 216, 73, 17)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $IBFEd
		Case $IBFEd
		Case $IBFEd
		Case $IBFEd
		Case $OpenIBF
		Case $SaveIBF
		Case $CommandsList
		Case $AddStr
		   $nCommand = GUICtrlRead($CommandsList,1)
			Select
				  Case $nCommand = "NewDB - Создать новую БД"
					 CreateDB()

				  Case $nCommand = "OpenDB - Открыть базу данных"
					 OpenDB()

				  Case $nCommand = "ClearDB - Опустошить базу данных"
					 If IsDeclared("$selected") = 0 Then ;Or (BitAND(GUICtrlRead($Expert),$GUI_CHECKED))
						MsgBox(0,0,"не выбрана база для работы команды")
						OpenDB()
					 EndIf
					 $serialize_line = "ClearDB"
					 _GUICtrlListBox_AddString ( $ListQueue, $serialize_line )



				  Case $nCommand = "DeleteDB - удалить базу данных"

				  Case $nCommand = "CloseDB - закрыть текущю базу данных"
					 $serialize_line = "CloseDB"
					 _GUICtrlListBox_AddString ( $ListQueue, $serialize_line )

				  Case Else
				  MsgBox(0,0,"ничего не выбрано же О_о")
			EndSelect

		Case $DelStr
		Case $SetINI
			SetIniFile()

	EndSwitch
WEnd

Func CreateDB()
   #Region ### START Koda GUI section ### Form=C:\Users\biblio-08\Downloads\koda_1.7.3.0\Forms\createDB.kxf
   $CreateDB = GUICreate("CreateDB", 346, 171, 192, 124)
   $DBNameInput = GUICtrlCreateInput("", 104, 24, 121, 21)
   $DBName = GUICtrlCreateLabel("Имя БД", 24, 24, 79, 17)
   $DBDesc = GUICtrlCreateInput("", 104, 64, 209, 21)
   GUICtrlSetTip(-1, "Description")
   $Ok = GUICtrlCreateButton("Ok", 256, 120, 75, 25)
   $Checkbox1 = GUICtrlCreateCheckbox("Доступна читателю", 8, 120, 121, 17)
   $RadioEK = GUICtrlCreateRadio("БД ЭК", 144, 112, 113, 17)
   GUICtrlSetState(-1, $GUI_CHECKED)
   $RadioNonEK = GUICtrlCreateRadio("Произвольная", 144, 136, 113, 17)
   $Label1 = GUICtrlCreateLabel("Описание", 24, 72, 54, 17)
   $GroupRadioType = GUICtrlCreateGroup("тип БД", 136, 96, 113, 65)
   GUICtrlCreateGroup("", -99, -99, 1, 1)
   GUISetState(@SW_SHOW)
   #EndRegion ### END Koda GUI section ###



   While 1
	   $nMsg = GUIGetMsg()
	   Switch $nMsg
		   Case $GUI_EVENT_CLOSE
			   GUISetState(@SW_HIDE, $CreateDB)
			   ExitLoop

		   Case $DBNameInput
		   Case $DBName
		   Case $DBDesc
		   Case $Ok

			   $newDbname = StringUpper(GUICtrlRead( $DBNameInput, 1))
			   $newDBdesc = GUICtrlRead( $DBDesc, 1)
				  if not $newDbname or not $newDBdesc Then
					 MsgBox(0,0,"пустые поля")
					 ContinueCase
				  EndIf
			   $rdr =  BitAND(GUICtrlRead($Checkbox1),$GUI_CHECKED)
			   $nonek = BitAND(GUICtrlRead($RadioNonEK),$GUI_CHECKED)
			   $serialize_line ="NewDB" & "," & $newDBname & "," & $newDBdesc & "," & $rdr & "," & $nonek
			   MsgBox(0,0,$serialize_line)
			   _GUICtrlListBox_AddString ( $ListQueue, $serialize_line )
			   GUISetState(@SW_HIDE, $CreateDB)
			   ExitLoop
	   EndSwitch
   WEnd

EndFunc

Func SelectDB()
   $SelectDB = GUICreate("SelectDB", 243, 357, 192, 124)
   $ListDB = GUICtrlCreateList("", 16, 16, 201, 292)
   GUICtrlSetData(-1, $liststring)
   $DoSelect = GUICtrlCreateButton("Выбрать", 144, 320, 75, 25)
   GUISetState(@SW_SHOW)


   While 1
	   $nMsg = GUIGetMsg()
	   Switch $nMsg
		   Case $GUI_EVENT_CLOSE
			  GUISetState(@SW_HIDE, $SelectDB)
			  Return False
			  ExitLoop
		   Case $DoSelect
			  GUISetState(@SW_HIDE, $SelectDB)
			  Return GUICtrlRead($ListDB,1)
			  ExitLoop
	   EndSwitch
   WEnd
EndFunc

Func SetINIFile()
    $ini_file = FileOpenDialog( "выберите irbis_server.ini", "c:\", "укажите (irbis_server.ini)", 1)
			if Not $ini_file Then
			  MsgBox(0,0,"не выбран файл!")
			  ContinueCase
			EndIf
		   $DBNameCat = IniRead($ini_file, "main", "DBNNAMECAT", "NOT_FOUND!!!")
		   $DATAIpath = IniRead($ini_file, "main", "DataPath", "NOT_FOUND!!!")
		   ;MsgBox(0,0,$DATAIpath & $DBNameCat)
		   $DBNameMNU = $DATAIpath & $DBNameCat
		   _FileReadToArray($DBNameMNU, $sArray)
		   ;MsgBox(0,0,$sArray[1])
			   For $i = 0 To $sArray[0]
				  If $sArray[$i] = "*****" then
					 ExitLoop
				  EndIf
				  If Mod($i, 2) <> 0 Then
					 	_ArrayAdd( $DBNArray, $sArray[$i])
						;MsgBox(0,0, $sArray[$i])
				  EndIf
			   Next
				  ;MsgBox (0,0,$DBNArray[0])
				  $liststring = _ArrayToString( $DBNArray, "|", 0, UBound($DBNArray)-1)
				  ;MsgBox (0,0,$liststring)
				  ;MsgBox (0,0,@error)

EndFunc

Func OpenDB()
   if Not $liststring Then
	  MsgBox(0,0,"пустой список БД. выберите ini файл ИРБИС.")
	  SetIniFile()
   EndIf
   $selected = SelectDB()
   if not $selected then Return
   ;MsgBox(0,0, $selected)
   $serialize_line = "OpenDB" & " " & $selected
   _GUICtrlListBox_AddString ( $ListQueue, $serialize_line )
   ;_GUICtrlListBox_DeleteString( $CommandsList, _GUICtrlListBox_FindString($CommandsList, "Open"))
   GUICtrlSetData($LabelCurrentDB, $selected)
EndFunc