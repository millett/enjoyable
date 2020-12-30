Enjoyable is an application for Mac OS X which allows you to use
controller inputs like a mouse or keyboard.

If you've ever played a video game which only supports mouse and
keyboard input but you want to use a joystick or gamepad, then
Enjoyable will help you do that.

Enjoyable supports

 * Mapping gamepad and joystick buttons to keyboard and mouse actions
 * Fine control over mouse movement and scrolling using analog axis
   inputs
 * Automatic and dynamic switching between different input mappings
 * Downloading and sharing input presets for different applications
 * Modern OS X features like resume and automatic termination

Enjoyable is free software written by Joe Wreschnig with minor additions
by Matt Millett, Sam Deane and Ruotger Deecke, and is based on the Enjoy codebase written by [Yifeng Huang](http://nongraphical.com)
and [Sam McCall](http://abstractable.net/enjoy/).


# How to use
1. Download the zip [here](https://github.com/millett/enjoyable/raw/master/Enjoyable3.zip) and unzip it. Enjoyable.app should be inside.
2. Go to System Preferences -> Security & Privacy -> Accessibility, then click the (+) button, select the app (Enjoyable), and specifically allow permissions under "allow this app to control your computer".
3. press buttons on your controller and see them light up the app. Set up your key mapping.
4. press the little arrow in the top right corner and now, when you press buttons on your controller, it should act like you pressed those buttons on the computer!

### New in 1.4

- Support for Apple Silicon and Big Sur.
- Enjoyable stays in light mode even if the system is in dark mode.
- Unfortunately some older versions of macOS needed to be dropped. (is 10.13+ now)

### New in 1.3.1alpha
Add functionality for any other random buttons/doohickeys on your controller. (Treats them as buttons)
(Tested only with the Xbox One trigger so far!)
- no promises if this crashes your stuff, but it works ok for me!
 - I have not experienced any weird side effects yet...
 
### New in 1.3

Added in 1.3 is support for a "centered" mode for mouse move.

In this mode, rather than nudging the mouse position left/right/up/down, tan analog input can be
used to set the absolute location of the mouse as a deviation from the centre of the screen. The further
the analog input is from the neutral point, the further away from the centre of the screen the mouse
gets placed. 

This is intended to be a better solution for games such as Elite: Dangerous which can map the mouse
to yaw/roll/pitch, and where it's valuable to be able to have the mouse snap back to a central point
when the input is released.

## How to Use

To start, just press a button on your joystick or gamepad, then press
the key you want to map it for. Then press the ▶ button and switch
back to your game. For more details, Enjoyable has a in-application
manual available in Help Viewer via `⌘?`.

## Requirements

* Mac OS X 10.13+
* One or more HID-compatible (e.g. USB or Bluetooth) input devices

## License

Copyright 2020 Matt Millet, Ruotger Deecke
		  2013 Joe Wreschnig  
          2012 Yifeng Huang  
          2009 Sam McCall, University of Otago

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

The joystick icon is from the Tango icon set and is public domain.
