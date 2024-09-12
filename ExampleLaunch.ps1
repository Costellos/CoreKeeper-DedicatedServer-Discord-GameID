# I do not recomend using this file. As this file might have been updated by devs and I might have not updated this.
# Feel free to change these (see README), but keep in mind that changes to this file might be overwritten on update
$CoreKeeperArguments = @("-batchmode", "-logfile", "CoreKeeperServerLog.txt") + $args

$script:ckpid = $null
$watchPath = ".\watch_gameid.cmd"


function Quit-CoreKeeperServer {
	if ($script:ckpid -ne $null) {
		taskkill /pid $ckpid.Id
		Wait-Process -InputObject $ckpid
		Write-Host "Stopped CoreKeeperServer.exe"
	}
}

try {
	if (Test-Path -Path "GameID.txt") {
		Remove-Item -Path "GameID.txt"
	}

	$script:ckpid = Start-Process -PassThru -FilePath %0\..\CoreKeeperServer.exe -ArgumentList $CoreKeeperArguments
	Write-Host "Started CoreKeeperServer.exe"

	# Wait for GameID
	while (!(Test-Path -Path "GameID.txt")) {
		Start-Sleep -Milliseconds 100
	}

	Write-Host -NoNewline "Game ID: "
	Get-Content "GameID.txt"
	$watchProcess = Start-Process -FilePath "cmd.exe" -ArgumentList "/c $watchPath" -PassThru
 
	Write-Host "Press q to quit, DON'T close the window or the server process will just keep running"
   	While ($KeyInfo.VirtualKeyCode -eq $Null -or $KeyInfo.VirtualKeyCode -ne 81) {
		$KeyInfo = $Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
	}
}
finally {
	Quit-CoreKeeperServer
	 if ($watchProcess -and !$watchProcess.HasExited) {
        $watchProcess.Kill()
        Write-Host "The watch_gameid.cmd process was terminated."
    }
	pause
}
