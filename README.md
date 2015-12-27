# jxcore-nodejs-socketio-c-plus-plus
An example project for using JXCore, nodejs, socket.io and c++

### Installation
1. Install Command Line Tools from Xcode.
2. Installing Node.js (version 0.12.2):
Go to https://nodejs.org/download/release/v0.12.2 download and install.
3. Open a terminal window.
* Check the installed node version by writing the following:
```
node -v
```
* Updating/Installing the npm:
("-g" installs it globaly therefore "sudo" is needed and it will request admin password)
```
sudo npm install npm -g
```
Checking the npm version write:
```
npm -v
```
* Install node-gyp:
```
sudo npm install node-gyp -g
```
Checking the node-gyp version write:
```
node-gyp -v
```
4. Go to the project folder.

### Making the Mac Server work:
1. Go to "Mac Server" folder.
2. Open a terminal window.
* To compile and build write the following.
```
npm install
```
* Run the server, write:
```
node server.js
```
### Making the iOS server work:
#### Still under progress because of the addon.
#### Currently there are two ways
#### Correct way:
1. There is a script written in the Xcode Project -> Target -> Build Phases.
Currently the "Run script only when installing" is checked. To run the script un-check it. Build the target. It will fail, the problem here is that there is an Apple bug opened on the latest Xcode, problem with gcc.

2. Check the "Run script only when installing", so that the script won't run. From the terminal, go to Winnery/JS/jxcore and write:
```
npm install
```
Now build and run the target from Xcode. The ios server doesn't work, you will see the following error:
```
Error!: dlopen(/Users/xxx/Library/Developer/CoreSimulator/Devices/45A45ADF-DC75-4504-A37D-357CACB2C73C/data/Containers/Bundle/Application/839AC5AE-47FE-4B17-8ADD-E80195922FBE/Winnery.app/JS/jxcore/build/Release/wineAddon.node, 1): no suitable image found.  Did find:
	/Users/xxx/Library/Developer/CoreSimulator/Devices/45A45ADF-DC75-4504-A37D-357CACB2C73C/data/Containers/Bundle/Application/839AC5AE-47FE-4B17-8ADD-E80195922FBE/Winnery.app/JS/jxcore/build/Release/wineAddon.node: mach-o, but not built for iOS simulator
```

# License
Copyright 2015 Or Kazaz

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
