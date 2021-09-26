Toggle Mirror Display
=====================

![mirror-display](https://user-images.githubusercontent.com/1200316/134811392-d50d9cc0-e038-4aca-a9f6-cd0923d8bdac.png)


This is a simple AppleScript that can be used with Automator to toggle Mirror Display option using a keyboard shortcut.

This can be useful if you have multiple displays and want to switch between Mirror Display option and default extended display option with a single keyboard shortcut.

Normally the same task can be done by using the existing  `CMD` + `fn` + `F1` keyboard shortcut.
However, it doesn't set "Optimize for:" option to the Built-in Display. This script does that.

Usage
-----

1. Create a new **Application** with the Script using the **Automator** App.
2. Give the Application accessibility cabability from `System Preferences` -> `Security & Privacy` -> `Accessibility`.
3. Create a new **Quick Action** from **Automator** to launch the Application.
4. Finally from `System Preferences` -> `Keyboard` -> `Shortcuts` -> `Services` -> `general`, activate the **Quick Action** with the keyboard shortcut of your choice.

Todo
----

1. Better Error Handling.
2. Revert back to the old active state of **System Preferences** if it was already running.
3. Give time limit to `repeat until` blocks.

License
-------

The toggle-mirror-display script is licensed under the **MIT license**.
