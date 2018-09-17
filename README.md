This script is designed for various **front-ends**. **LaunchBox** can do this itself, but has trouble with Original Redump PS2 games. If you're using those with LaunchBox, try my [LaunchBox-to-PCSX2-Extractor](https://github.com/UnluckyForSome/LaunchBox-to-PCSX2-Extractor).

# 7zEmuPrepper

I compress all of my disc-based games (I have full sets so must do this to fit them all on my disk) - which saves a lot of space, but means compatibility is reduced as some emulators won't load compressed files. **7zEmuPrepper** acts as an intermediary between front-end and emulator. In simple terms the steps the script takes are as follows:

1. Extracts the chosen archive into a location of your choice
2. Works out which file is the correct file to launch the emulator with
3. Launches the chosen emulator with the playable file
4. Removes the files after the emulator has closed (you can keep them "cached" afterwards for faster load times instead if you like, too!)

# Usage
This **PowerShell** script has been converted into a `.exe` for usage. You can use the `.exe` provided here, but if you don't trust me (and why would you?) then I have also included **"ps2exe.ps1"**, which is the tool I used that converts **PowerShell** scripts to `.exe` files. Using this, you can review the **7zEmuPrepper.ps1** code, and compile your own `.exe` file. If you open up a PowerShell window, navigate to the directory **"ps2exe.ps1"** and **7zEmuPrepper.ps1** are both in, and type `./ps2exe.ps1 ./7zEmuPrepper.ps1 ./7zEmuPrepper.exe -noconfig` then your own `.exe` file will be compiled. See the [Microsoft PS2EXE Download Page](https://gallery.technet.microsoft.com/scriptcenter/PS2EXE-GUI-Convert-e7cb69d5) for more information on how to use this (it's super easy).

Once you have the `.exe` file ready, all that’s left to do is set up the command-line arguments. **7zEmuPrepper** uses command-line arguments to select it's options; how these are put together on various different "front-ends" varies, but in it's simplest terms, each in quotes and seperated by a single space, you will need the following in order:

1. The path of the 7zEmuPrepper `.exe` file
2. The path of the 7-Zip `.exe` file
3. The path of the Emulator `.exe` file
4. Command-line arguments for the Emulator itself
5. The path to extract the archive to
6. The path of the game archive (the front-end usually has this as "%ROM%")
7. **NEW** The filetype you want the emulator to try to launch with (if multiple, seperate with a pipe `|`, 7zEmuPrepper will prioritise from right to left)
8. (Optional) the `-KeepExtracted` option will ensure that extracted games stay in the extraction folder and will not be deleted by the script after the emulator closes

![LaunchBox Settings](https://i.imgur.com/3rcNefO.png)

# Command-Line Examples

#### Running a PS1 game from EmulationStation using the RetroArch Beetle PSX HW core, which needs a .CUE file to launch
`"C:/Users/Joe/.emulationstation/7zEmuPrepper.exe" "C:\PROGRA~1\7-Zip\7z.exe" "C:\PROGRA~1\RetroArch\retroarch.exe" "-L C:\PROGRA~1\RetroArch\cores\mednafen_psx_hw_libretro.dll -f" "D:\TempExtraction" "cue" "%ROM%"`

#### Running a PS2 game (4x4 Evo) from a desktop shortcut using PCSX2, which needs a .BIN file to launch
`"C:\Users\Joe\Documents\McWork\7zEmuPrepper.exe" "C:\PROGRA~1\7-Zip\7z.exe" "C:\PROGRA~2\PCSX2\pcsx2.exe" """--nogui""" "D:\TempExtraction" "bin" "D:\PS2\4x4 Evo (USA).7z"`

#### Running a PS1 game from EmulationStation using the RetroArch Beetle PSX HW core, which needs a .CUE file to launch, whilst keeping the extracted file in place afterwards
`"C:/Users/Joe/.emulationstation/7zEmuPrepper.exe" "C:\PROGRA~1\7-Zip\7z.exe" "C:\PROGRA~1\RetroArch\retroarch.exe" "-L C:\PROGRA~1\RetroArch\cores\mednafen_psx_hw_libretro.dll -f" "D:\CachedGames" "cue" "%ROM%"`

#### Running a PS2 game from EmulationStation using PCSX2, which is in either a .BIN or a .ISO format
`"C:\Users\Joe\Documents\McWork\7zEmuPrepper.exe" "C:\PROGRA~1\7-Zip\7z.exe" "C:\PROGRA~2\PCSX2\pcsx2.exe" """--nogui""" "D:\TempExtraction" "bin|iso" "%ROM%"`

# Troubleshooting
- Remember, different frontends work differently - sometimes you will be asked to provide an "Emulator Path", which is what you need to point towards **7zEmuPrepper.exe**. You can then remove this from the rest of the command.

- Try and use `PROGRA~1` instead of `Program Files` in your paths. The space sometimes messes things up.

- Emulator arguments with double hyphens `--` need **triple quoting**. See how I have quoted `--nogui` in the PCSX2 example above.
