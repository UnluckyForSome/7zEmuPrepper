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
"Filetype To Launch: [$launchFile]"
"Keep Extracted?: [$KeepExtracted]"

# Define the individual filename without the rest of the path
$fileName = [System.IO.Path]::GetFileNameWithoutExtension("$filePath")

# See if the game is already extracted


# Set location
Set-Location -Path $extractionPath

if (Test-Path $fileName"."*) {
"Already Extracted?: [True]"
""

# Define the path of the correct file to try and launch with the emulator
$extractedFile = Get-Item -Path "$fileName*.*" | Where-Object -Property Extension -Match -Value $launchFile | Select-Object -Last 1 -ExpandProperty FullName
"Launching [$extractedFile]..."
Start-Process $emulatorPath -ArgumentList $emulatorArguments, """$extractedFile""" -Wait


}
else {
"Already Extracted?: [False]"
""

# Start extraction in 7Zip, skip files already present and output progress
"Extracting [$filePath]..."
& $7ZipPath "x" $filePath "-o$extractionPath" "-aos" "-bsp1" | out-string -stream | Select-String -Pattern "\d{1,3}%" -AllMatches | ForEach-Object { $_.Matches.Value } | foreach {
    [System.Console]::SetCursorPosition(0, [System.Console]::CursorTop) 
    Write-Host "Progress:" $_ -NoNewLine
}


# Define the path of the correct file to try and launch with the emulator
$extractedFile = Get-Item -Path "$fileName*.*" | Where-Object -Property Extension -Match -Value $launchFile | Select-Object -Last 1 -ExpandProperty FullName
""
"Launching [$extractedFile]..."
Start-Process $emulatorPath -ArgumentList $emulatorArguments, """$extractedFile""" -Wait
}
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