#include <MsgBoxConstants.au3>
#include <StringConstants.au3>
#include <Array.au3>
#include <Encoding.au3>
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>

Dim $aHelp[4] = [ "Использование: irbislogparse.exe /File:<путь_к_файлу_логов_без пробелов> /Out:<путь_к_файлу_вывода_csv_без_пробелов> [/overwrite|append(Default)]" & @LF , "/overwrite|append(Default) : overwrite -перезапись файла логов, append - дозапись в конец файла (по умолчанию)" & @LF, "если очень хочется указть путь с пробелами, тогда надо заключить его в кавычки. Пример:" & @LF , "/File:""C:\document and settings\local settings\text.log"""]



CmdHelp()
Func CmdHelp()
   if $cmdline[0]=0 Then
	  for $val In $aHelp
		 ConsoleWrite(_Encoding_ANSItoOEM($val) & @LF)
	  Next
	  Exit 1
   EndIf

EndFunc
Func FindKey($key, $type)
$sKeyFile = _ArraySearch( $cmdline, $key,0,0,0,1)
;ConsoleWrite("key= " & $sKeyFile & @LF)
Switch $type
   Case "source"
	  if ($sKeyFile>0) Then
		 $sPathFrom = StringRegExp($cmdline[$sKeyFile], """*(.+\.\w+)", 1)
	   ;  $sPathFrom = StringTrimLeft($sPathFrom[0], 6)
		 if IsArray($sPathFrom) = 1 Then

			Return StringTrimLeft($sPathFrom[0], 6)
			;ConsoleWrite("path=" & _Encoding_ANSItoOEM($SourcePath))
		 Else
			$SourcePath = "undefined"
			ConsoleWrite("Error!!! SourcePath undefined!!!")
			Return -1
		 EndIf
	  Else
		 ConsoleWrite("Error!!! key /File:<path> not found")
		 Return -1
	  EndIf
   Case "out"
	  if ($sKeyFile>0) Then
		 $sPathFrom = StringRegExp($cmdline[$sKeyFile], """*(.+\.\w+)", 1)
	   ;  $sPathFrom = StringTrimLeft($sPathFrom[0], 6)
		 if IsArray($sPathFrom) = 1 Then

			Return StringTrimLeft($sPathFrom[0], 5)
			;ConsoleWrite("path=" & _Encoding_ANSItoOEM($SourcePath))
		 Else
			$SourcePath = "undefined"
			ConsoleWrite("Error!!! OutPath undefined!!!")
			Return -1
		 EndIf
	  Else
		 ConsoleWrite("Error!!! key /Out:<path> not found")
		 Return -1
	  EndIf
EndSwitch
EndFunc

$SourcePath = FindKey("/File:", "source")
If $SourcePath = -1 Then Exit 1
$OutPath = FindKey("/Out:", "out")
If $OutPath = -1 Then Exit 1
ConsoleWrite("SourcePath=" & _Encoding_ANSItoOEM($SourcePath) & @LF & "OutPath=" & _Encoding_ANSItoOEM($OutPath))
;MsgBox(0,0,$sMassive)
;~ if $cmdline[0]>0 then
;~    ConsoleWrite(_Encoding_ANSItoOEM("всего аргументов: ") & $cmdline[0] & @LF)
;~    for $i=1 to Ubound($cmdline)-1

;~ 	  ConsoleWrite($cmdline[$i] & @LF)
;~    Next
;~ EndIf
$hFile = FileOpen($SourcePath, 0)
if $hFile = -1 Then
   ConsoleWrite(_Encoding_ANSItoOEM("не удалось открыть файл лога. :( ") & @LF )
Else
   $sMassive = FileRead( $hFile)
EndIf

$aArray = StringRegExp($sMassive,'(?<data>[A-Z]{3,5}|(?<=\()\d+(?=\)))', 3)
;MsgBox(0,0,@error)
;_ArrayDelete($aArray,1)
;MsgBox(0,0, "length is " & Ubound($aArray))

if Not(IsInt(Ubound($aArray)/2)) Then
   ConsoleWrite(_Encoding_ANSItoOEM("неверно распарсен лог: в массиве данных нечетное количество значений - (") & Ubound($aArray) & ")" )
   Exit 1
EndIf


Dim $k=0
dim $j=0
Dim $aDBNames[(Ubound($aArray)/2)];
Dim $aDBData[(Ubound($aArray)/2)];
For $i = 0 To UBound($aArray)-1

   if (Mod($i,2)=0) then

	  $aDBNames[$k]= $aArray[$i]
	  $k+=1

   Else
	  $aDBData[$j]=$aArray[$i]
	  $j+=1

   EndIf

   Next


$hLog = FileOpen( $outPath, $FO_READ + $FO_APPEND)
$LogoHeader = FileReadLine( $hLog, 1)

$sRow1 = _ArrayToString( $aDBNames, ";")
$sRow2 = _ArrayToString( $aDBData, ";")
;$FileDate = FileGetTime($SourceFile)
$FileDate = FileGetTime($SourcePath)
;$sDate =  @MDAY & '.' & @MON & '.' & @YEAR & ' ' & @HOUR & ':' & @MIN & ':' & @SEC
$sDate = $FileDate[2] & '.' & $FileDate[1] & '.' & $FileDate[0] & ' ' & $FileDate[3] & ':' & $FileDate[4] & ':' & $FileDate[5]
;ConsoleWrite($sDate)
FileWriteLine($hLog, ";"&$sRow1)
FileWriteLine($hLog, $sDate & ";"&$sRow2)
ConsoleWrite(@LF & _Encoding_ANSItoOEM("В файл ") & $outPath & _Encoding_ANSItoOEM(" было записано: ") & @LF & $sRow1 & @LF & $sRow2);