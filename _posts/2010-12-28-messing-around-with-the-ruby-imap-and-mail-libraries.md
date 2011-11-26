---
layout: post
title: Messing around with the Ruby IMAP and Mail libraries
---

So today I got to build a small little application that does the following:

*      It reads a specific email account through the IMAP protocol
*      Imports the message and all of it's attachments
*      Saves the message to a postgres database
*      Marks the message as read
*      Copies the message to the Complete folder
*      Removes the message from the Inbox


So why did I do this? Well, I really want a simple way to post messages from my phone to my blog.  Gmail currently allows me to work on drafts while on the move and will push when I resume connectivity.  Hopefully this will result in a vast increase in the number of posts I make in the future.

All of this was down to the Ruby IMAP library and Mikel Lindsaars awesome Mail library.  You can view the source code of this website at [https://github.com/beilabs/www.beilabs.com](https://github.com/beilabs/www.beilabs.com) *This blog is now replaced with a simplified Jekyll blog framework.

There are still a number of things to do such as:

*      Read and process attachments
*      Save to Amazon S3

