param (
    [Parameter(Mandatory=$True)]
    [string]$7ZipPath, # File location of the 7Zip exe
    [Parameter(Mandatory=$True)]
    [string]$emulatorPath, # File location of the Emulator exe
    [Parameter(Mandatory=$True)]
    [string]$emulatorArguments, # Arguments for the Emulator
    [Parameter(Mandatory=$True)]
    [string]$extractionPath, # Path to extract to
    [Parameter(Mandatory=$True)]
    [string]$filePath, # Exact location of the compressed file
    [Parameter(Mandatory=$False)]
    [switch]$KeepExtracted # Determines whether extracted files are kept or deleted
)
"7Zip Emu-Prepper by UnluckyForSome"
""
"7Zip: [$7ZipPath]"
"Emulator: [$emulatorPath]"
"Emulator Arguments: [$emulatorArguments]"
"Archive: [$filePath]"
"Extracting To: [$extractionPath]"
"Keep Extracted?: [$KeepExtracted]"
""

# Define the individual filename without the rest of the path
$fileName = [System.IO.Path]::GetFileNameWithoutExtension("$filePath")

# Start decompression in 7Zip, skip files already present and nullify the entire output
"Starting decompression of [$filePath]..."
& $7ZipPath "x" $filePath "-o$extractionPath" "-aos" | Out-Null

# Set location to where the files have been extracted
Set-Location -Path $extractionPath

# Perform a general pass of filetypes to try and launch if emulator is not identified in the following steps
$extractedFile = Get-Item -Path "$fileName.*" | Where-Object -Property Extension -Match -Value 'GDI|CUE|BIN|ISO' | Select-Object -Last 1 -ExpandProperty FullName

# Identify PCSX2 as the emulator and search for the right type of files to launch
if ($emulatorPath -Match 'pcsx2.exe')
{
$extractedFile = Get-Item -Path "$fileName.*" | Where-Object -Property Extension -Match -Value 'BIN|ISO' | Select-Object -Last 1 -ExpandProperty FullName
}

# Identify RetroArch as the emulator and search for the right type of files to launch
if ($emulatorPath -Match 'retroarch.exe')
{
$extractedFile = Get-Item -Path "$fileName.*" | Where-Object -Property Extension -Match -Value 'GDI|CUE|BIN|ISO' | Select-Object -Last 1 -ExpandProperty FullName
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