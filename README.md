# jxcore-nodejs-socketio-c-plus-plus
An example project for using JXCore, nodejs (v0.12.2), socket.io and c++

### Installation
1. Install Command Line Tools from Xcode.
2. Installing Node.js (version 0.12.2):  
Go to [node v0.12.2](https://nodejs.org/download/release/v0.12.2) download and install.
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
  * Checking the npm version write:
  ```
  npm -v
  ```
  * Install node-gyp:
  ```
  sudo npm install node-gyp -g
  ```
  * Checking the node-gyp version write:
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
**_Still under progress because of the addon._**
#### Currently there are two ways
##### Correct way, from a script in Xcode:
There is a script written in the Xcode Project -> Target -> Build Phases.  
Currently the "Run script only when installing" is checked. To run the script un-check it. Build the target.  
It will fail, the problem here is that there is an [Apple bug opened](https://forums.developer.apple.com/thread/4572) on the latest Xcode, problem with gcc (Missing lgcc_s.10.5.dylib), their workaround doesn't work either.
_Need to make the script run with the latest Xcode compiler (llvm)._

##### Other way, from the terminal:
Check the "Run script only when installing", so that the script won't run.  
From the terminal, go to Winnery/JS/jxcore and write:
```
npm install
```
Now build and run the target from Xcode.  
The ios server doesn't work, you will see the following error:
```
Error!: dlopen(/Users/xxx/Library/Developer/CoreSimulator/Devices/45A45ADF-DC75-4504-A37D-357CACB2C73C/data/Containers/Bundle/Application/839AC5AE-47FE-4B17-8ADD-E80195922FBE/Winnery.app/JS/jxcore/build/Release/wineAddon.node, 1): no suitable image found.  Did find:
	/Users/xxx/Library/Developer/CoreSimulator/Devices/45A45ADF-DC75-4504-A37D-357CACB2C73C/data/Containers/Bundle/Application/839AC5AE-47FE-4B17-8ADD-E80195922FBE/Winnery.app/JS/jxcore/build/Release/wineAddon.node: mach-o, but not built for iOS simulator
```
#### Working without the addon on the iOS Server:
Go to socketFunctions.js file and comment out lines:
  * 2 - var wineAddon = require('bindings')('wineAddon');
  * 14 - var message = wineAddon.getMessage();
  * 15 - Mobile('OnWineSelected').call(message);

Then follow the terminal way.

### Starting from scratch
1. Open a new project.
2. Go to Github [jxcore-ios-sample](https://github.com/jxcore/jxcore-ios-sample) and download the project.
3. Take the JXcore and JS folders from JXcoreSample and add it to your project folder, the JS folder should be added as a reference folder to the project.
4. Now lets update the JXCore libraries:  
Go to [download in JXCore's web site](http://jxcore.com/downloads/) and download iOS Release Binaries.  
Take the downloaded libraries and replace them with those in the folder JXCore/bin.
5. In the project go to the targets Build Phases and add the following:
  * CoreFoundation.framework
  * libstdc++.6.0.9.dylib (In Xcode 7, Apple started to use .tbd, that currently isn't working, you will need to do the following: click '+' then click 'Add Other...' in the keyboard press 'command + shift + g' this will open the 'Go to folder' enter '/usr/lib' and find the lib).
6. Start writing your server under JS/jxcore folder.

### Working with JXCore
Make JXcore instance run under it's own thread:
```
[JXcore useSubThreading];
```

Start the engine:  
(main file will be JS/main.js. This is the initializer file taken from the JXcoreSample project)
```
[JXcore startEngine:@"JS/main"];
```

Start the application:  
In main.js there's an event called "StartApplication", we are going to call it with our js file.
```
NSArray *params = [NSArray arrayWithObjects:@"server.js", nil];
[JXcore callEventCallback:@"StartApplication" withParams:params];
```

#### Events
**Event on the iOS JS server side, for example:**
* In the js file lets register an "ABC" event so we can call it from the native side.
  ```
  Mobile('ABC').register(function(){
								console.log("We arrived to function ABC");
								});
  ```
	The function will run once the event "ABC" will be called.

* In an objective C file lets call the event "ABC".
	```
	[JXcore callEventCallback:@"ABC" withJSON:nil];
	```

**Event on the native side, for example:**
* In an objective C file lets register an "OnABCDone" event so we can call it from the iOS server side.
	```
	[JXcore addNativeBlock:^(NSArray *params, NSString *callbackId){
								NSLog(@"We arrived to function OnABCDone");
								} withName:@"OnABCDone"];
	```

* In the js file lets call the event "OnABCDone".
  ```
  Mobile('OnABCDone').call();
  ```

**We can combine them together** in order to call an event from the native side and get a call back once it's done, it will look as the following:
* JS file:  
  ```
	Mobile('ABC').register(function(){
								console.log("We arrived to function ABC");
								Mobile('OnABCDone').call();
								});
  ```

* Objective C file:
  ```
	[JXcore addNativeBlock:^(NSArray *params, NSString *callbackId){
								NSLog(@"We arrived to function OnABCDone");
  							} withName:@"OnABCDone"];  

	[JXcore callEventCallback:@"ABC" withJSON:nil];
	```

**An example for an Event on any node JS server side:**
```
socket.on('ABC', function(){
                console.log("We arrived to function ABC");
                socket.emit('OnABCDone');
                });
```

**References:**
[socket.io](http://socket.io/docs/server-api/)


#### Add-ons (c++)


#### Debuging
**Debuging the Mac Server**
[node-inspector](https://github.com/node-inspector/node-inspector)

**Debuging the iOS Server**


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
