---
layout: post
title: Evergreen - Beautiful Javascript unit testing
---

![Jasmine Javascript testing](http://s3.amazonaws.com/blog.beilabs.com/images/2012-04-01-jasmine-sample-tests.png "Jasmine testing")

I've been coding quite a bit lately after work lately since I got back from Nepal.  While I was introduced to Jasmine a fair while ago I just recently discovered [evergreen](https://github.com/jnicklas/evergreen/ "Evergreen gem").

Evergreen is a tool to run javascript unit tests for client side JavaScript. It combines a server which allows you to serve up and run your specs in a browser, as well as a runner which uses Capybara and any of its drivers to run your specs. Evergreen uses the Jasmine unit testing framework for JavaScript.  I'm a huge fan of automating my tests and you can see if your JS tests pass by running in the console:

``bundle exec rake spec:javascripts``

Handy stuff.  Now back to write some decent, tested Javascript for a change.