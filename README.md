# 7zEmuPrepper

I compress all of my disc-based games (I have full sets so must do this to fit them all on my disk) - which saves a lot of space, but means compatibility is reduced as some emulators won't load compressed files. **7zEmuPrepper** acts as an intermediary between front-end and emulator. In simple terms the steps the script takes are as follows:

1. Extracts the chosen archive into a location of your choice
2. Works out which file is the correct file to launch the emulator with
3. Launches the chosen emulator with the playable file
4. Removes the files after the emulator has closed (you can keep them "cached" afterwards for faster load times instead if you like, too!)

**7zEmuPrepper** uses command-line arguments to select it's options; how these are put together on various different "front-ends" varies, but in it's simplest terms, each in quotes and seperated by a single space, you will need the following:

1. The path of the 7zEmuPrepper `.exe` file
2. The path of the 7-Zip `.exe` file
3. The path of the Emulator `.exe` file
4. Command-line arguments for the Emulator itself
5. The path to extract the archive to
6. The path of the game archive (the front-end usually has this as "%ROM%")
7. (Optional) the `-KeepExtracted` option will ensure that extracted games stay in the extraction folder and will not be deleted by the script after the emulator closes

# Examples

#### Command for running a PS1 game from EmulationStation using the RetroArch Beetle PSX HW core
`"C:/Users/Joe/.emulationstation/7zEmuPrepper.exe" "C:\PROGRA~1\7-Zip\7z.exe" "C:\PROGRA~1\RetroArch\retroarch.exe" "-L C:\PROGRA~1\RetroArch\cores\mednafen_psx_hw_libretro.dll -f" "%ROM%"`

#### Command for running a PS2 game (4x4 Evo) from a desktop shortcut using PCSX2
`"C:\Users\Joe\Documents\McWork\7zEmuPrepper.exe" "C:\PROGRA~1\7-Zip\7z.exe" "C:\PROGRA~2\PCSX2\pcsx2.exe" """--nogui""" "D:\Recent\Recent" "D:\PS2\4x4 Evo (USA).7z"`

#### Command for running a PS1 game from EmulationStation using the RetroArch Beetle PSX HW core, whilst keeping the extracted file in place afterwards
`"C:/Users/Joe/.emulationstation/7zEmuPrepper.exe" "C:\PROGRA~1\7-Zip\7z.exe" "C:\PROGRA~1\RetroArch\retroarch.exe" "-L C:\PROGRA~1\RetroArch\cores\mednafen_psx_hw_libretro.dll -f" "%ROM%"`
