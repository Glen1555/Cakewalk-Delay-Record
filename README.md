# Cakewalk-Delay-Record
THIS PROGRAM HAS BEEN SUPERCEEDED BY Cakewalk-Record-Delay. Please go there. I did not know how to delete this entry on the repository. The updated version, now renamed correctly has lots more features. Thank you!

Provides a small topmost window for delay of recording by seconds entered. Easy playback rewind or pause recording and play at current position
NOTE: The PDF and other places mention that this program might work with other DAW. Nevertheless, the .exe included is specific as placing focus on the Cakewalk DAW. If you wish to use with another DAW, modify the include .ahk where both WinActivate and WinWait are being used. The dialog buttons are able to be tested without a DAW running. The main part of the code is within an infinite loop with a Sleep,100 so as not to consume the processor, espcially that DAWs and libraries thereof run heavy on processing. Cakewalk-Delay-Record should make very little difference on performance of the DAWs.
CHANGES COMING SOON - Modifying now to include a PLAY IN Toggle button. CWDR will intelligently allow the play to a set point and go immediatley into recording (adding in any delay if desired). I felt this was needed since the "sound on sound" recording mode was really eating up the processor. There will be included a settings file that will go into the data directory. 
