#include <file.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Array.au3>

#Region ### START Koda GUI section ### Form=C:\Users\biblio-08\Downloads\koda_1.7.3.0\Forms\Form1.kxf
$Form1 = GUICreate("проверка наличия файлов", 535, 126, 192, 124)
$sel_file = GUICtrlCreateButton("выберите файл", 8, 8, 97, 25)
$input_label = GUICtrlCreateLabel("с дампом нужной базы данных в TXT", 112, 16, 195, 17)
$save_file = GUICtrlCreateButton("выберите файл", 5, 48, 97, 25)
$output_label = GUICtrlCreateLabel("куда сохранить список отсутствующих файлов", 110, 53, 242, 17)
$Start = GUICtrlCreateButton("START", 8, 80, 203, 41)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Dim $sArray
$s = 0
$out = @ScriptDir & "\out.txt"

While 1
   Switch GUIGetMsg()
	  Case $sel_file
		 $input_file = FileOpenDialog( "выберите дамп базы в TXT", "c:\", "Текстовые файлы (*.txt)", 1)
		 GUICtrlSetData($input_label, $input_file)
		 ;MsgBox(0,"selected is", $input_file)
	  Case $save_file
		 global $output_file = FileSaveDialog( "выберите куда сохранить файл", "c:\", "Текстовые файлы (*.txt)")
		 Local $sFileName = StringTrimLeft($output_file, StringInStr($output_file, "\", $STR_NOCASESENSE, -1))

        ; Check if the extension .au3 is appended to the end of the filename.
        Local $iExtension = StringInStr($sFileName, ".", $STR_NOCASESENSE)

        ; If a period (dot) is found then check whether or not the extension is equal to .au3.
        If $iExtension Then
            ; If the extension isn't equal to .au3 then append to the end of the filepath.
            If Not (StringTrimLeft($sFileName, $iExtension - 1) = ".txt") Then $output_file &= ".txt"
        Else
            ; If no period (dot) was found then append to the end of the file.
            $output_file &= ".txt"
        EndIf


		 GUICtrlSetData($output_label, $output_file)
	  Case $Start
		 getFileNames()
	  Case $GUI_EVENT_CLOSE
		 ExitLoop
   EndSwitch
WEnd
Func getFileNames()
_FileReadToArray($input_file,$sArray)
;dim $arr_elt[UBound($sArray)]
Global $arr_elt[0]
Local $i
   For $i = 0 To UBound($sArray) - 1
	  $mark951 = StringInStr( $sArray[$i], "#951: ^A", 0, 1, 1, 10)


		 if $mark951 <> 0 Then

			$s = $s + 1
			$file_name = StringReplace( StringMid($sArray[$i], 9), "/", "\")
			;$arr_elt[$s] = $file_name
			_ArrayAdd( $arr_elt, $file_name)
		 EndIf
   Next
;MsgBox(0,"123", UBound($arr_elt))
;_FileWriteFromArray($output_file, $arr_elt, 1)
;MsgBox(0,"!!!","готово")
IfFileExists()
EndFunc

Func IfFileExists()
   Local $i, $schet=0
   dim $ifexist[0]
   $folder = FileSelectFolder("выберите каталог нужной базы", "")
   ;MsgBox(0,"123", $folder)
   For $i = 0 To UBound($arr_elt) - 1
	  $fullpath = StringReplace( $folder & "\" & $arr_elt[$i], "\\", "\")
	  $its_here = FileExists( $fullpath)
		 If $its_here = 0 Then
			_ArrayAdd($ifexist, $fullpath & " - не найден!!")
			$schet = $schet + 1
		 EndIf

   Next
   MsgBox(0,"!!!", "ГОТОВО!!! отсутствует " & $schet & " файлов")
   _FileWriteFromArray($output_file, $ifexist, 0)
	;MsgBox(0,"!!!","готово")
EndFunc