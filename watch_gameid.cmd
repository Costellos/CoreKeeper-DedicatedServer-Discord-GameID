@echo off
:: Define the GameID file, Discord webhook URL, and optional Message ID
set "filePath=GameID.txt"
set "webhookUrl=ReplaceWithDiscordWebHookUrl"
set "messageID=RepalceWithMessageIdOrRemove"  :: If you have an existing message ID, set it here (leave empty if no message exists)

set "fileFound=0"  :: Flag to check if the file was found

echo Starting the script to monitor GameID.txt...

:checkFileExistence
:: Check if the GameID.txt file exists
if not exist "%filePath%" (
    echo [%date% %time%] - File %filePath% does not exist. Waiting 5 seconds and checking again...
    timeout /t 5 /nobreak >nul
    goto checkFileExistence
)

:: When the file is found for the first time, set the flag
if "%fileFound%"=="0" (
    echo [%date% %time%] - File %filePath% found for the first time.
    set "fileFound=1"
    goto sendInitialGameID
)

:watchFile
:: Check if the file still exists in case it gets deleted while running
if not exist "%filePath%" (
    echo [%date% %time%] - File %filePath% was deleted. Waiting 5 seconds and checking again...
    timeout /t 5 /nobreak >nul
    set "fileFound=0"  :: Reset the flag if file is deleted
    goto checkFileExistence
)

:: Get the current timestamp of the file
for %%F in (%filePath%) do set "currentModified=%%~tF"

:: Compare the current timestamp with the last modified timestamp
if not "%currentModified%"=="%lastModified%" (
    :: File has been modified
    echo [%date% %time%] - File %filePath% has been updated.
    
    :: Update the last modified timestamp
    set "lastModified=%currentModified%"

    :: Read the Game ID from the file
    set /p gameID=<%filePath%

    :: If a message ID is set, update the message
    if not "%messageID%"=="" (
        echo [%date% %time%] - Updating message on Discord: Game ID %gameID%
        curl -H "Content-Type: application/json" -X PATCH -d "{\"content\": \"Game ID %gameID% has been updated.\"}" %webhookUrl%/messages/%messageID%
    ) else (
        echo [%date% %time%] - Sending new message to Discord: Game ID %gameID%
        curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"Game ID %gameID% has been updated.\"}" %webhookUrl%
    )
)

:: Wait for 5 seconds before checking again
timeout /t 5 /nobreak >nul
goto watchFile

:sendInitialGameID
:: Send the initial Game ID when the file is found or the script first starts
set /p gameID=<%filePath%

:: Send the initial message or update an existing one
if not "%messageID%"=="" (
    echo [%date% %time%] - Updating message on Discord: Game ID %gameID% detected
    curl -H "Content-Type: application/json" -X PATCH -d "{\"content\": \"Game ID %gameID%\"}" %webhookUrl%/messages/%messageID%
) else (
    echo [%date% %time%] - Sending initial message to Discord: Game ID %gameID% detected.
    curl -H "Content-Type: application/json" -X POST -d "{\"content\": \"Game ID %gameID%\"}" %webhookUrl%
)

:: Update the last modified timestamp
for %%F in (%filePath%) do set "lastModified=%%~tF"
goto watchFile
