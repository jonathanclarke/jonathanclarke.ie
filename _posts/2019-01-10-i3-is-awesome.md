---
layout: post
title: i3 is awesome
---

Having been using the default OS of Debian / Ubuntu for the past 20 years I've slowly starting looking for alternatives.  My goal was to reduce the load as much as possible on either my laptop or desktop at startup, preferring that my docker containers would use those resources instead.  I'm not one of those folks who has compiz installed, please don't offend my eyes.

Enter /r/unixporn

For those who are unaware; the #unixporn channel usually features people bragging about how they use Arch Linux with a beautiful array of customised minimalistic window settings.  Time and time again, i3 came up.

 i3 is a tiling window manager, completely written from scratch. The target platforms are GNU/Linux and BSD operating systems, our code is Free and Open Source Software (FOSS) under the BSD license. i3 is primarily targeted at advanced users and developers.

The goal of a window manager is to control the appearance and placement of windows in a windowing system.   A tiling window manager automatically arranges the windows to occupy the whole screen in a non-overlapping way.  It does not dictate the applications you should use.  Pick the tools that make the most sense for your workflow, and i3 will manage them all in the same way.  I3 does not get involved in the Vim or Emacs wars.

Since you don't need to worry about window positioning, i3 generally makes better use of your screen real estate. It also allows you to get to what you need faster.  I feel that this focus is probably the main benefit of using i3; A full screen browser, code editor and terminal across different screens has brought my productivity to an all time high.   Should you need more space for a particular window, enable full-screen mode or switch to a different layout, such as stacked or tabbed.  I find I've been using single workspaces per program but you can simply split the screen easily and use the entire section for your use.

Keyboard shortcuts abound.  Opening the terminal and other programs, resizing and positioning windows, changing layouts, and even exiting i3.  You just need to remember a few of them to start off but once you get the hang of them you'll never go back.   I've reduced my use of the mouse by being able to switch screens soley using the keyboard.  I've definitely improved the speed and efficiency of my workflow.

To open a new terminal, press <SUPER>+<ENTER>.  SUPER for my laptop is the Command key while on my desktop is the ALT key. Since the windows are automatically positioned, you can start typing your commands right away. 

Because i3 is a window manager, it does not provide tools to enable customizations; you'll need additional programs such as the following:
    'feh' to define a background picture for your desktop.
    'dmenu' to enable customizable menus that can be launched from a keyboard shortcut.
    'dunst' for desktop notifications. (I turned this off)

Being fully configurable, and you can control every aspect of it by updating the default configuration file. From changing all keyboard shortcuts, to redefining the name of the workspaces, to modifying the status bar, you can make i3 behave in any way that makes the most sense for your needs.

In i3, you can group workspaces in different ways according to your workflow. For example, you can put the browser on one workspace, the terminal on another, your IDE on a third, etc. You can even change i3's configuration to always assign specific applications to their own workspaces.

Press <SUPER>+num to switch to workspace num. If you get into the habit of always assigning applications/groups of windows to the same workspace, you can quickly switch between them, which makes workspaces a very useful feature.

You can use workspaces to control multi-monitor setups, where each monitor gets an initial workspace. If you switch to that workspace, you switch to that monitor—without moving your hand off the keyboard.  I've set my own config to automatically rotate multiple screens as I prefer to code in them horizontally. 

For some reading this article you might think it's for advanced users only but that's not the case.  I find the minimalistic approach attractive and the shortcuts have improved my productivity immensely.  Give it a try but commit to it; you'll find it hard to go back. 