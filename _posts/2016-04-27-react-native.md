---
layout: post
title:  React Native
date:   2016-05-27
image: https://www.beilabs.com/public/article_images/2016-05-27-react-native/react-native.png
excerpt: The past month or so I've been reading up on React Native.  React Native was open sourced about 2 years ago. React Native is an open source framework by Facebook which allows you to write Android and IOS applications using HTML like code (known as JSX) and JavaScript.
---

The past month or so I've been reading up on React Native.

React Native was open sourced about 2 years ago. React Native is an open source framework by Facebook which allows you to write Android and IOS applications using HTML like code (known as JSX) and JavaScript.

The whole framework is based upon React.js, it's a JavaScript framework.  You can use these React.js components, piece them together, to assemble IOS and Android Apps.

Coming from a Java world of "Write once, run anywhere", React turns this paradigm on its head with "Learn once, write anywhere"

React Native allows a developer to use native IOS / Android components, and bring about changes to the UI through a JavaScript thread running in the background.  The theory means that this should allow the application to feel native and smooth (even though it's not a native application / powered by JavaScript).

I have never run a react native application; I'm not a JavaScript guy whatsoever.  This is going to be an interesting journey.

### 1. Install homebrew

Homebrew, in order to install the required NodeJS, in addition to some recommended installs.

	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

### 2. Install nodejs
Use Homebrew to install Node.js.

NodeJS 4.0 or greater is required for React Native. The default Homebrew package for Node is currently 6.0, so that is not an issue.

	brew install node

### 3. Install the React Native command line tools

The React Native command line tools allow you to easily create and initialize projects, etc.

	npm install -g react-native-cli

### 4. XCode - if you are using a mac

Xcode 7.0 or higher. Open the App Store or go to https://developer.apple.com/xcode/downloads/. This will also install git as well.

### 5. Watchman 

Watchman is a tool by Facebook for watching changes in the filesystem. It is recommended you install it for better performance.

	brew install watchman

### 6. Flow 

Flow, for static typechecking of your React Native code (when using Flow as part of your codebase).

	brew install flow

### 7. Android - Install Android Studio

Get it here: https://developer.android.com/studio/index.html

### 8. Use the android cli tools
Add the following lines to your ~/.bash_profile where <username> is your username

	export ANDROID_HOME=/Users/<username>/Library/Android/sdk/
	export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

### 9. Install the Android Build Tools

Run the following command:

	android list sdk -a

Which will provide you a list. 

We opted to install    
	
	8- Android SDK Build-tools, revision 23.0.1

So the next command was:

	android update sdk -a -u -t 8

where 8 was the option to install from the list provided. 

### 10. react-native init AwesomeProject

	react-native init AwesomeProject

This will walk you through creating a new React Native project in /Users/username/workspace/AwesomeProject

	Installing react-native package from npm...
	Setting up new React Native app in /Users/username/workspace/AwesomeProject
	AwesomeProject@0.0.1 /Users/username/workspace/AwesomeProject
	└── react@15.0.2 
	To run your app on iOS:
	cd /Users/username/workspace/AwesomeProject
	react-native run-ios
	- or -
	 Open /Users/username/workspace/AwesomeProject/ios/AwesomeProject.xcodeproj in Xcode
	Hit the Run button
	To run your app on Android:
	Have an Android emulator running (quickest way to get started), or a device connected
	cd /Users/username/workspace/AwesomeProject
	react-native run-android


### 11. Next lets run the android version
Start your android emulator in ADB (you might have to create one first)

Enter the AwesomeProject directory

	cd AwesomeProject

Next lets run the android version
	
	react-native run-android

This really will take a while; it's a long process. 

You'll then be greeted with the AwesomeProject blank screen running on your device. (Not even a miserable Hellow World)

### 12. Install Gradle
	brew install gradle

Create the following file:  ~/.gradle/gradle.properties

Add the following:
	
	org.gradle.daemon=true
