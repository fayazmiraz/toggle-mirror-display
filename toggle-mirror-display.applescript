(*
 * Toggle macOS Mirror Display Option
 *
 * @TODO
 *  - Improve Error Handling
 *  - Convert repeat until tab group 1 of window 1 exists end repeat blocks to function calls
 *      and keep repeat to max 10 seconds. After that the script should quit.
 *
 * description:
 *  macOS automation script to toggle the macOS Mirror Display option.
 *  Normally cmd+fn+f1 does this, however it doesn't set "Optimize for:" option to the Built-in Display
 *  This script does that.
 *
 * @author: Fayaz Ahmed
 * @home: https://fayaz.dev/
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
    # just checking all the anchor names
    # set names to get the name of every anchor of pane id "com.apple.preference.displays"
    # log names
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
        log _windows

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

        # set mdCheckBox to checkbox "Mirror Displays" of tab group 1 of window 1
        log mdCheckBox

        tell mdCheckBox
            set prevCheckBoxStatus to value of mdCheckBox as boolean
            log prevCheckBoxStatus

            # we need accessibility capability to run this.
            # repeat until (name of second radio button of tab group 1 of window 1 of process "System Preferences") is "Accessibility Keyboard"
            # end repeat
            click mdCheckBox
        end tell

        # wait a bit so that the settings can be applied
        # delay 1

        # Again wait for the System Preferences Window
        repeat until tab group 1 of window "Built-in Display" exists
        end repeat

        # for "Mirror Displays" we need to make the "Built-in Display" as default
        if prevCheckBoxStatus is false then
            log "now we need to select the Built-in Display"
            click pop up button of tab group 1 of window "Built-in Display"

            # Wait for the Menu item to appear
            repeat until menu item "Built-in Display" of menu 1 of pop up button "Optimize for:" of tab group 1 of window "Built-in Display" exists
                delay 0.1
                # We'll quit if delay is more than 5 seconds
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
    # @todo: is it possible to revert back to the old active state of "System Preferences" if it was already running?
    tell application "System Events"
        click menu item 3 of menu 1 of menu bar item 4 of menu bar 1 of process "System Preferences"
    end tell
end if