--- === hs.spotify ===
---
--- Controls for Spotify music player

local spotify = {}

local alert = require "hs.alert"
local as = require "hs.applescript"

--- hs.spotify.state_paused
--- Constant
--- A string that, when returned by hs.spotify.getPlayerState() indicates Spotify is paused
spotify.state_paused = "'kPSp'"

--- hs.spotify.state_playing
--- Constant
--- A string that, when returned by hs.spotify.getPlayerState() indicates Spotify is currently playing a track
spotify.state_playing = "'kPSP'"

--- hs.spotify.state_stopped
--- Constant
--- A string that, when returned by hs.spotify.getPlayerState() indicates Spotify is stopped (initial state after application startup)
spotify.state_stopped = "'kPSS'"

-- Internal function to pass a command to Applescript.
local function tell(cmd)
  local _cmd = 'tell application "Spotify" to ' .. cmd
  local ok, result = as.applescript(_cmd)
  if ok then
    return result
  else
    return nil
  end
end

--- hs.spotify.playpause()
--- Function
--- Toggles play/pause of current spotify track
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function spotify.playpause()
  tell('playpause')
end

--- hs.spotify.play()
--- Function
--- Play current spotify track
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function spotify.play()
  tell('play')
end

--- hs.spotify.pause()
--- Function
--- Pauses of current spotify track
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function spotify.pause()
  tell('pause')
end

--- hs.spotify.next()
--- Function
--- Skips to the next spotify track
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function spotify.next()
  tell('next track')
end

--- hs.spotify.previous()
--- Function
--- Skips to previous spotify track
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function spotify.previous()
  tell('previous track')
end

--- hs.spotify.displayCurrentTrack()
--- Function
--- Displays information for current track on screen
---
--- Parameters:
---  * None
---
--- Returns:
---  * None
function spotify.displayCurrentTrack()
  local artist = tell('artist of the current track') or "Unknown artist"
  local album  = tell('album of the current track') or "Unknown album"
  local track  = tell('name of the current track') or "Unknown track"
  alert.show(track .."\n".. album .."\n".. artist, 1.75)
end

--- hs.spotify.getCurrentArtist()
--- Function
--- Gets the name of the artist of the current track
---
--- Parameters:
---  * None
---
--- Returns:
---  * A string containing the Artist of the current track, or nil if an error occurred
function spotify.getCurrentArtist()
    return tell('artist of the current track')
end

--- hs.spotify.getCurrentAlbum()
--- Function
--- Gets the name of the album of the current track
---
--- Parameters:
---  * None
---
--- Returns:
---  * A string containing the Album of the current track, or nil if an error occurred
function spotify.getCurrentAlbum()
    return tell('album of the current track')
end

--- hs.spotify.getCurrentTrack()
--- Function
--- Gets the name of the current track
---
--- Parameters:
---  * None
---
--- Returns:
---  * A string containing the name of the current track, or nil if an error occurred
function spotify.getCurrentTrack()
    return tell('name of the current track')
end

--- hs.spotify.getPlayerState()
--- Function
--- Gets the current state of Spotify
---
--- Parameters:
---  * None
---
--- Returns:
---  * A string containing one of hs.spotify.state_stopped, hs.spotify.state_paused, hs.spotify.state_playing
function spotify.getPlayerState()
   return tell('get player state')
end

--- hs.spotify.isRunning()
--- Function
--- Returns whether Spotify is currently open. Most other functions in hs.spotify will automatically start the application, so this function can be used to guard against that.
---
--- Parameters:
---  * None
---
--- Returns:
---  * A boolean value indicating whether the Spotify application is running.
function spotify.isRunning()
   return hs.application.get("Spotify") ~= nil
end

--- hs.spotify.isPlaying()
--- Function
--- Returns whether Spotify is currently playing
---
--- Parameters:
---  * None
---
--- Returns:
---  * A boolean value indicating whether Spotify is currently playing a track, or nil if an error occurred (unknown player state). Also returns false if the application is not running
function spotify.isPlaying()
   -- We check separately to avoid starting the application if it's not running
   if not hs.spotify.isRunning() then
      return false
   end
   state = hs.spotify.getPlayerState()
   if state == hs.spotify.state_playing then
      return true
   elseif state == hs.spotify.state_paused or state == hs.spotify.state_stopped then
      return false
   else  -- unknown state
      return nil
   end
end

return spotify
