RecordingCountDown := 0
RecordStopPress := 0
Recording := 0
Playing := 0
Tripped := 0

SetTitleMatchMode, 2
#SingleInstance Force
CtrlColor := "FFFFFF" 
  ;White (FFFFFF) works best if transparent, otherwise
  ;some light, non-white color such as light gray (DDDDDD) if Edit is opaque
Gui, +AlwaysOnTop -Resize -MaximizeBox +ToolWindow ;ToolWindow is a thinner border style
Gui, Margin, 0, 0 ;A margin command is needed. Increase to create padding between GUI and Edit
Gui, Color,,%CtrlColor%  ;The last parameter is ControlColor, i.e., background color for all controls
Gui +LastFound  ; Make the GUI window the last found window for use by the line below.
WinSet, Transparent, 255  ;(0 = invisible, 255 = opaque)
Gui, font, s18, Tahoma  ; Set 10-point Tahoma 
Gui, Add, Edit, vSecs r1 x4 y1 w50 h33 +BackgroundTrans

Gui, font, s12, Tahoma  ; Set 10-point Tahoma 
Gui,Add,Progress, x60 y1  w110  h38  Disabled BackgroundRed  vC2
Gui,Add,Text, xp yp wp hp cWhite  BackgroundTrans Center 0x200 vB2 gRecordOrStop,STOP
Gui,Add,Progress,xp yp wp hp   Disabled BackgroundLime vC1
Gui,Add,Text,    xp yp wp hp   cBlack  BackgroundTrans Center 0x200 vB1 gRecordOrStop,RECORD
Gui, font, s14, Tahoma  ; Set 10-point Tahoma 
Gui,Add,Progress, x178  y1  w92  h38  Disabled BackgroundAqua   vC3
Gui,Add,Text, xp yp wp hp cBlack  BackgroundTrans Center 0x200 vB3 gPlayOrPause,PAUSE
Gui,Add,Progress,xp yp wp hp   Disabled BackgroundGreen vC4
Gui,Add,Text,    xp yp wp hp   cWhite  BackgroundTrans Center 0x200 vB4 gPlayOrPause,PLAY
Gui, font, s10 italic, Tahoma ; Set 10-point Tahoma 
Gui,Add,Text,x44 y44,Visit Thy Word We Love . Love
Gui, Show, w280 h66, Cakewalk Delay Record (v1.1)
  
Gosub,RecordOrStopDo
  
Return

GuiClose:
  Gui, Destroy
Return

ESC::ExitApp

PausePosition:
{
	IfWinExist,ahk_class Cakewalk Core
	{
		WinActivate,ahk_class Cakewalk Core
		WinWaitActive,ahk_class Cakewalk Core
		Send {Control Down}
		Send %A_Space%
		Send {Control Up}
	}
	return
}

PlayOrPause:
{
	If RecordingCountDown
		return
		
	If Playing = 1
	{
		;STOP THE PLAYING
		Playing := 0
		Recording := 0
		Gosub, ShowPlayButton
		Gosub, ShowRecordButton
		Gosub, PausePosition
		return
	}
	
	If Playing = 0
	{
		If Recording = 1
		{
			Recording := 0
			Tripped := 1
			;STOP RECORDING NO REWIND
			Gosub, ShowPlayButton
			Gosub, ShowRecordButton
			Gosub, PausePosition
		}
		else
		{
			;START THE PLAYING
			KeyWait,LButton,U

			Gosub, ShowStopButton
			Gosub, ShowPauseButton
			Playing := 1
			Tripped := 1
			Gosub, PlayIt
		}
	}
	return
}

PlayIt:
{
	IfWinExist,ahk_class Cakewalk Core
	{
		WinActivate,ahk_class Cakewalk Core
		WinWaitActive,ahk_class Cakewalk Core
		Send %A_Space%
	}
	return
}

RecordOrStop:
{
	RecordStopPress := 1
	return
}

RecordOrStopDo:
{
	outer:
	Loop
	{
		Sleep,100
		
		If RecordStopPress = 1
		{
			If Playing = 1
			{
				Playing := 0
				Gosub, ShowRecordButton
				Gosub, ShowPlayButton
				;MsgBox,,,here
				Gosub, PlayIt
				Tripped := 1
				continue
				;break outer
			}
			
			If Tripped
			{
				;MsgBox,,,here at tripped
				RecordStopPress := 0
				Tripped := 0
				continue
				;break outer
			}
			
			;MsgBox,,,here

			RecordStopPress := 0
			gui,submit,nohide
			if Recording = 0
			{
				GuiControlGet,Secs
				If !Secs
				{
					MsgBox,,,Enter seconds of pause
					continue
				}
				If Secs is Number
				{
					Recording := 1
					Gosub, ShowStopButton
					
					;reset play button just in case out of sync with player
					Gosub, ShowPlayButton
					;change text to show disabled
					GuiControl,, B4, -

					HoldSecs := Secs
					RecordingCountDown := 1
					Counter := Secs
					Loop,%Secs%
					{
						Sleep,250
						If RecordStopPress
						{
							break
						}
						Sleep,250
						If RecordStopPress
						{
							break
						}
						Sleep,250
						If RecordStopPress
						{
							break
						}
						Sleep,250
						If RecordStopPress
						{
							break
						}
						Counter--
						GuiControl,,Secs,%Counter%
					}

					GuiControl,, B4, PLAY
					
					If RecordStopPress = 1
					{
						RecordStopPress := 0
						Gosub,ShowRecordButton
					}
					else
					{
						RecordingCountDown := 0
						Recording := 1
						Gosub, ShowPauseButton
						IfWinExist,ahk_class Cakewalk Core
						{
							WinActivate,ahk_class Cakewalk Core
							WinWaitActive,ahk_class Cakewalk Core
							Send r
						}
					}

					GuiControl,,Secs,%HoldSecs%
				}
			}
			else
			{
				Playing := 0
				Recording := 0
				RecordingCountDown := 0
				Gosub, ShowRecordButton
				Gosub, ShowPlayButton
				
				IfWinExist,ahk_class Cakewalk Core
				{
					WinActivate,ahk_class Cakewalk Core
					WinWaitActive,ahk_class Cakewalk Core
					Send %A_Space%
				}
			}
		}
	}
	return
}

ShowRecordButton:
{
	GuiControl, hide,B2
	GuiControl, hide,C2
	GuiControl, show,B1
	GuiControl, show,C1
	GuiControl,,Secs,%HoldSecs%
	return
}

ShowStopButton:
{
	GuiControl, hide,B1
	GuiControl, hide,C1
	GuiControl, show,B2
	GuiControl, show,C2
	return
}

ShowPlayButton:
{
	GuiControl, hide,B3
	GuiControl, hide,C3
	GuiControl, show,B4
	GuiControl, show,C4
	return
}

ShowPauseButton:
{
	GuiControl, hide,B4
	GuiControl, hide,C4
	GuiControl, show,B3
	GuiControl, show,C3
	return
}