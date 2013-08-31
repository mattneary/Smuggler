# Smuggle
Smuggle is a covert messaging app for Mac which sends your clipboard contents to a
designated phone number upon the pressing of a hotkey (`command + shift + up-arrow`).

## Startup
To run Smuggler, double click the script app called `Smuggler`. It will prompt you about
speed-dial and phone numbers. If this is your first time running, note that your speed
dial is blank and you will thus say "No" to the first prompt.

It will then provide you with an area into which to enter the number. Note that the
placeholder value hints at the expected format, `+1XXXXXXXXXX`. Upon entering and
submitting your number, you will be told as which speed-dial this number has been saved.

Next, you will verify that it is pairing with the correct number, and the Smuggler app
will run. The app is a camel residing in your status bar. It is very subtle, with the 
only UI being a `Quit` button and the current phone number with which you are paired.

## Usage
When you are ready to send a message, select and copy the text (`command + c`) and then
utilize the hotkey for sending, `command + shift + up-arrow`. Before doing this, however,
you will need to set a few things up.

## Setup
### Run Messages
In order for messages to be sent, the Messages app needs to be running. Luckily, we will
make the application icon hidden. Hence, we need only hide the application window. This
is easily achieved by placing it in a space separate from your primary work.

### Hide the Dock Icon
To hide the dock icon of Messages.app, its bundle will need to be modified. Navigate to
`/Applications/Messages.app/Contents/` and edit the `Info.plist` to include an additional
key-pair like the following.

```xml
<key>LSUIElement</key>
<string>1</string>
```
