---
layout: post
title: Nginx error pages
---

A quick how-to on creating a custom 404 error page on a Nginx server.

To display a single page for a site, add the below to your config file. Below config assumes /404.html is in the root of the current site.


    server {
        ...
        error_page 404 /404.html;
        ...
    }


The error page it self doesn’t have to be anything special, just a clear message for the user to know that this page does not exist.

If you are using a reverse proxy you need to ensure that proxy_intercept_errors are on.  This directive decides if nginx will intercept responses with HTTP status codes of 400 and higher.  By default all responses will be sent as-is from the proxied server.  

If you set this to on then nginx will intercept status codes that are explicitly handled by an error_page directive. Responses with status codes that do not match an error_page directive will be sent as-is from the proxied server.


