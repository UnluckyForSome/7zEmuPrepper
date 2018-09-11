param (    
    [string]$7ZipPath, # File location of the 7Zip exe
    [string]$emulatorPath, # File location of the Emulator exe
    [string]$emulatorArguments, # Arguments for the Emulator
    [string]$filePath, # Exact location of the compressed file
    [switch]$KeepExtracted # Determines whether extracted files are kept or deleted
)
"7Zip Emu-Prepper by UnluckyForSome"
""
"7Zip: [$7ZipPath]"
"Emulator: [$emulatorPath]"
"Emulator Arguments: [$emulatorArguments]"
"Archive: [$filePath]"
"Keep Extracted?: $KeepExtracted"
""

# Example commands:
# PCSX2 = """--nogui"""
# RetroArch = """"-L""" """C:/Program Files/RetroArch/cores/dolphin_libretro.dll""""

# Playstation with Beetle PSX RetroArch
# C:\Users\Joe\Documents\McWork\7zPrepper.exe "C:\PROGRA~1\7-Zip\7z.exe" "C:\PROGRA~1\RetroArch\retroarch.exe" "-L C:\PROGRA~1\RetroArch\cores\mednafen_psx_hw_libretro.dll -f" "D:\PS1\American Pool (USA).zip"

# Playstation 2 with PCSX2
# C:\Users\Joe\Documents\McWork\7zPrepper.exe "C:\PROGRA~1\7-Zip\7z.exe" "C:\PROGRA~2\PCSX2\pcsx2.exe" """--nogui""" "D:\PS2\Chess Challenger (Europe) (En,Fr,De,Es,It).7z"

# Define the individual filename without the rest of the path
$fileName = [System.IO.Path]::GetFileNameWithoutExtension("$filePath")

# Start decompression in 7Zip, skip files already present and nullify the entire output
"Starting decompression of [$filePath]..."
& $7ZipPath "e" $filePath "-aos" | Out-Null

# Perform a general pass of filetypes to try and launch if emulator is not identified in the following steps
"RetroArch Matched"
$extractedFile = Get-Item -Path "$fileName*" | Where-Object -Property Extension -Match -Value 'CUE|BIN|ISO' | Select-Object -Last 1 -ExpandProperty FullName

# Identify PCSX2 as the emulator and search for the right type of files to launch
if ($emulatorPath -Match 'pcsx2.exe')
{
"PCSX2 Matched"
$extractedFile = Get-Item -Path "$fileName*" | Where-Object -Property Extension -Match -Value 'BIN|ISO' | Select-Object -Last 1 -ExpandProperty FullName
}

# Identify RetroArch as the emulator and search for the right type of files to launch
if ($emulatorPath -Match 'retroarch.exe')
{
"RetroArch Matched"
$extractedFile = Get-Item -Path "$fileName*" | Where-Object -Property Extension -Match -Value 'CUE|BIN|ISO' | Select-Object -Last 1 -ExpandProperty FullName
}

# Launch emulator
"Launching emulator with [$extractedFile]..."
Start-Process $emulatorPath -ArgumentList $emulatorArguments, """$extractedFile""" -Wait

# If "KeepExtracted" argument passed, exit before removal
if ($KeepExtracted)
{ 
    "Process Complete!"
    exit
}

# If "KeepExtracted" argument is not passed, remove all of the extracted files when emulator closes
else
{
    # Get the name of the extracted file without the extension so we can delete everything with that name
    $extractedFileNoExtension = $extractedFile.Substring(0, $extractedFile.LastIndexOf("."))

    "Removing the extracted file..."
    Remove-Item "$extractedFileNoExtension.*"
    "Process Complete!"
    exit
}