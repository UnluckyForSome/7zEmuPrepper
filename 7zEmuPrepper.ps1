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
    [Parameter(Mandatory=$True)]
    [string]$launchFile, # File extension to try and launch
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
"Filetype(s) To Launch: [$launchFile]"
"Keep Extracted?: [$KeepExtracted]"
""

# Define the individual filename without the rest of the path
$fileName = [System.IO.Path]::GetFileNameWithoutExtension("$filePath")

# Start decompression in 7Zip, skip files already present and nullify the entire output
"Starting decompression of [$filePath]..."
& $7ZipPath "x" $filePath "-o$extractionPath" "-aos" | Out-Null

# Set location to where the files have been extracted
Set-Location -Path $extractionPath

# Define the path of the correct file to try and launch with the emulator
$extractedFile = Get-Item -Path "$fileName*.*" | Where-Object -Property Extension -Match -Value $launchFile | Select-Object -Last 1 -ExpandProperty FullName

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