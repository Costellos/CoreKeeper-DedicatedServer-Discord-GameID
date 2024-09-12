# CoreKeeper-DedicatedServer-Discord-GameID
This is a simple CMD file that watches for an update to the GameID.txt file inside of the Core Keeper Dedicated server root location, and will either create a message, or edit an existing one in a Discord server channel using a Discord WebHook. 

# Requirements
- You will need to have Core Keeper Dedicated Server installed. 
    - I have this written for running on a windows machine using a CMD file, but the same could be done with a python script or really any other scripts. If you write it for something else please feel free to share it with me. Ill be happy to add it to the project after they have been vetted.
- You will also need to create a discord WebHook in your server. [Here](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks) is a good guide how to get it. 
- If you are having the webhook edit a message, then you will need to get that Discord Message ID. Keep in mind this needs to be a message the bot has already sent. You can get the message ID by right clicking on the message and selecting "Get Message Id" in the dropdown. 

# Setup/Installation
Below I will walk you through getting this setup. 

You will need to find the location that Core Keeper Dedicated Server is installed. For me it was "C:\Program Files (x86)\Steam\steamapps\common\Core Keeper Dedicated Server"

Take the file from this Repo called "watch_gameid.cmd" and drop it in the above location (or similar for where you game is installed). 

1. Open the file the "Launch.ps1" file.  
2. Find the following on line 6:

        $script:ckpid = $null

3. Replace it with the following:

        $script:ckpid = $null
        $watchPath = ".\watch_gameid.cmd"

4. Find the following on line 30:

        Write-Host -NoNewline "Game ID: "
        Get-Content "GameID.txt"Z

5. Replace it with the following:

        Write-Host -NoNewline "Game ID: "
        Get-Content "GameID.txt"Z
        $watchProcess = Start-Process -FilePath "cmd.exe" -ArgumentList "/c $watchPath" -PassThru

6. Find the following on line 40:

        Quit-CoreKeeperServer
        pause

7. Find the following on line 40:

        Quit-CoreKeeperServer
        if ($watchProcess -and !$watchProcess.HasExited) {
            $watchProcess.Kill()
            Write-Host "The watch_gameid.cmd process was terminated."
        }
        pause

8. Open "watch_gameid.cmd".
9. Find the following on line 4:

        ReplaceWithDiscordWebHookUrl

10. And replace with your Discord Webhook URL
11. If this is the first message the bot is sending, ignore this step so the bot can send the first message. Find the following on line 5:

        RepalceWithMessageIdOrRemove

12. Replace with the Discord Message ID. (Remember, this has to be a message that has already been sent by this bot).

Thats it, After you save everything, and launch the Core Keeper Dedicated server, it should work like normal and once GameID.txt is created from the Server it should either send a new message, or update an existing one. 

# Having Issues?
If you are having issues please feel free to open an issue. I will be happy to help as best I can.