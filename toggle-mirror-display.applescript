(*
 * Toggle macOS Mirror Display Option
 *
 * @author: Fayaz Ahmed
 * version: 1.0.0
 * license: MIT
 *)

# Script attributes
use AppleScript version "2.5"
use scripting additions

# initial state of the "System Preferences"
set runningSP to (get running of application "System Preferences")

# first open the Display Preferences
tell application "System Preferences"
    if not runningSP then
        activate
    end if
    set the current pane to pane id "com.apple.preference.displays"
    reveal anchor "displaysArrangementTab" of pane id "com.apple.preference.displays"
end tell

# Now execute the click events to do what we need
tell application "System Events"

    tell process "System Preferences"
        set prevCheckBoxStatus to true

        # Wait for the System Preferences Window, this is better than: delay 1
        repeat until tab group 1 of window 1 exists
            delay 0.1
        end repeat

        # collect all the window names
        set _windows to get the name of every window of application "System Preferences"
        # log _windows

        local mdCheckBox, checkBoxWindow
        set mdCheckBox to false

        repeat until mdCheckBox
            repeat with _window in _windows
                try
                    set mdCheckBox to checkbox "Mirror Displays" of tab group 1 of window _window
                    set checkBoxWindow to _window
                    exit repeat
                on error errText number errNum
                    # some error handling
                    log "No checkbox in " & _window
                end try
            end repeat
            delay 0.1
        end repeat

        tell mdCheckBox
            set prevCheckBoxStatus to value of mdCheckBox as boolean
            # log prevCheckBoxStatus

            click mdCheckBox
        end tell

        # Again wait for the System Preferences Window
        repeat until tab group 1 of window "Built-in Display" exists
        end repeat

        # for "Mirror Displays" we need to make the "Built-in Display" as default
        if prevCheckBoxStatus is false then
            # log "now we need to select the Built-in Display"
            click pop up button of tab group 1 of window "Built-in Display"

            # Wait for the Menu item to appear
            repeat until menu item "Built-in Display" of menu 1 of pop up button "Optimize for:" of tab group 1 of window "Built-in Display" exists
                delay 0.1
            end repeat

            click menu item "Built-in Display" of menu 1 of pop up button "Optimize for:" of tab group 1 of window "Built-in Display"
        end if
    end tell
end tell

# we are done, now quit "System Preferences" if it was not already open
if not runningSP then
    quit application "System Preferences"
else
    # Return to the main screen of "System Preferences"
    tell application "System Events"
        click menu item 3 of menu 1 of menu bar item 4 of menu bar 1 of process "System Preferences"
    end tell
end if