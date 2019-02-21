#NoTrayIcon
#RequireAdmin
;#Include-Once

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Outfile=UniGame_Launcher.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UPX_Parameters=-9 --strip-relocs=0 --compress-exports=0 --compress-icons=0
#AutoIt3Wrapper_Res_Description=UniGame Launcher
#AutoIt3Wrapper_Res_Fileversion=1.0.0.47
#AutoIt3Wrapper_Res_ProductVersion=1.0.0.47
#AutoIt3Wrapper_Res_LegalCopyright=2016, SalFisher47
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Region ;**** Pragma Compile ****
#pragma compile(AutoItExecuteAllowed, true)
#pragma compile(Compression, 9)
#pragma compile(InputBoxRes, true)
#pragma compile(CompanyName, 'SalFisher47')
#pragma compile(FileDescription, 'UniGame Launcher')
#pragma compile(FileVersion, 1.0.0.47)
#pragma compile(InternalName, 'UniGame Launcher')
#pragma compile(LegalCopyright, '2016, SalFisher47')
#pragma compile(OriginalFilename, UniGame_Launcher.exe)
#pragma compile(ProductName, 'UniGame Launcher')
#pragma compile(ProductVersion, 1.0.0.47)
#EndRegion ;**** Pragma Compile ****

; === UniGame Launcher.au3 =========================================================================================================
; Title .........: UniGame Launcher
; Version .......: 1.0.0.47
; AutoIt Version : 3.3.14.5
; Language ......: English
; Description ...: UniGame Launcher
; Author(s) .....: SalFisher47
; Last Modified .: June 4, 2018
; ==================================================================================================================================

Global $Env_RoamingAppData = @AppDataDir, _
		$Env_LocalAppData = @LocalAppDataDir, _
		$Env_ProgramData = @AppDataCommonDir, _
		$Env_UserProfile = @UserProfileDir, _
		$Env_SavedGames = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "{4C5C32FF-BB9D-43B0-B5B4-2D72E54EAAA4}")
		If @error Then $Env_SavedGames = $Env_UserProfile & "\Saved Games"

$Ini = @ScriptDir & "\" & StringTrimRight(@ScriptName, 4) & ".ini"

$exe_run = IniRead($Ini, "Exe", "exe_run", "")
$exe_path_full = @ScriptDir & "\" & $exe_run
$exe_only = StringTrimLeft($exe_path_full, StringInStr($exe_path_full, "\", 0, -1))
$exe_path_only = StringTrimRight($exe_path_full, StringLen($exe_only)+1)
$exe_cmd = IniRead($Ini, "Exe", "exe_cmd", "")
$exe_compat = IniRead($Ini, "Exe", "exe_compat", "")

$Ini2 = @ScriptDir & "\h3.ini"

$desktop_width = IniRead($Ini, "Exe", "desktop_width", 0)
$desktop_height = IniRead($Ini, "Exe", "desktop_height", 0)
$desktopRatio = Round($desktop_width/$desktop_height, 2)
If ($desktop_width == 0) And ($desktop_height == 0) Then
	$desktop_width = @DesktopWidth
	$desktop_height = @DesktopHeight
	$desktopRatio = Round($desktop_width/$desktop_height, 2)
	IniWrite($Ini2, "MAIN", "Width", " " & $desktop_width)
	IniWrite($Ini2, "MAIN", "Height", " " & $desktop_height)
ElseIf ($desktop_width == 0) Or ($desktop_height == 0) Then
	$desktop_width = @DesktopWidth
	$desktop_height = @DesktopHeight
	$desktopRatio = Round($desktop_width/$desktop_height, 2)
	IniWrite($Ini2, "MAIN", "Width", " " & $desktop_width)
	IniWrite($Ini2, "MAIN", "Height", " " & $desktop_height)
Else
	$desktopRatio = Round($desktop_width/$desktop_height, 2)
	If $desktopRatio > 1 Then
		IniWrite($Ini2, "MAIN", "Width", " " & $desktop_width)
		IniWrite($Ini2, "MAIN", "Height", " " & $desktop_height)
	Else
		IniWrite($Ini2, "MAIN", "Width", " " & @DesktopWidth)
		IniWrite($Ini2, "MAIN", "Height", " " & @DesktopHeight)
	EndIf
EndIf

$run_first = IniRead($Ini, "Exe", "run_first", 0)
If Not FileExists(@AppDataCommonDir & "\SalFisher47\RunFirst") Then DirCreate(@AppDataCommonDir & "\SalFisher47\RunFirst")
FileInstall("RunFirst\RunFirst.exe", @AppDataCommonDir & "\SalFisher47\RunFirst\RunFirst.exe", 0)
FileInstall("RunFirst\RunFirst.txt", @AppDataCommonDir & "\SalFisher47\RunFirst\RunFirst.txt", 0)

If RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", $exe_path_full) <> $exe_compat Then
	RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", $exe_path_full, "REG_SZ", $exe_compat)
EndIf
If $run_first == 1 Then
	ShellExecute(@AppDataCommonDir & "\SalFisher47\RunFirst\RunFirst.exe", '"' & $exe_path_full & '"' & " " & $exe_cmd & " " & $CmdLineRaw, $exe_path_only, "", @SW_HIDE)
Else
	ShellExecute($exe_only, " " & $exe_cmd & " " & $CmdLineRaw, $exe_path_only)
EndIf