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

# PCSX2 = """--nogui"""
# RetroArch = """"-L""" """C:/Program Files/RetroArch/cores/dolphin_libretro.dll""""

# Define the individual filename without the rest of the path
$fileName = [System.IO.Path]::GetFileNameWithoutExtension("$filePath")

# Start decompression in 7Zip, skip files already present and nullify the entire output
"Starting decompression of [$filePath]..."
& $7ZipPath "e" $filePath "-aos" | Out-Null

# Define the file we want the emulator to load by searching the individual filename and looking for common extensions
"Looking for playable file..."
$extractedFile = Get-Item -Path "$fileName*" | Where-Object -Property Extension -Match -Value 'BIN|ISO' | Select-Object -Last 1 -ExpandProperty FullName

# Start emulator
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