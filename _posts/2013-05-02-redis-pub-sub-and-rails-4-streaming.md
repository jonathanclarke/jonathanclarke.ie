---
layout: post
title: Redis Pub/Sub and Rails 4 Live Streaming
---

So today I got to play a bit with the newly minded Rails 4 RC 1. A new feature is Live Streaming so I decided to see how it would work with redis publish / subscribe channels.

So lets create an infinite loop which is publishing on the redis queue "namespaced:stream"

    require 'redis'
    require 'json'

    $i = 1
    redis = Redis.new
    begin
        data = {"time" => "#{ Time.now }" }
        redis.publish("namespaced:stream", data.to_json)
        sleep 1
        $i +=1
    end while $i > 0

Lets have that running indefinitely, it is now publishing on the channel namespaced:stream.

Lets install the latest Ruby on Rails 4 and get a streaming controller up and running

    class StreamsController < ActionController::Base
        include ActionController::Live
  
        def the_stream
            response.headers['Content-Type'] = 'text/event-stream'
            redis = Redis.new
            redis.subscribe('namespaced:stream') do |on|
                on.message do |event, data|
                    response.stream.write("data:#{ data }\n\n")
                end
            end
            ensure
                response.stream.close
            end
        end
    end

Make sure you install the puma server and start it.

Now head to /streams/the_stream

Viola, pub/sub with live streaming through Rails 4 + Redis.  You could hook up some javascript to access this data.  

Stick this in item.js
    $(document).ready(initialize);

    function initialize() {
        var source = new EventSource('/products/latest-product-events');
        source.addEventListener('message', function(e) {
            console.log("Received "+e.data);
            updateItemsPage(e.data);
        }, false);
    
        source.addEventListener('open', function(e) {
            console.log("Connection was opened.");
        }, false);
    
        source.addEventListener('error', function(e) {
            if (e.readyState == EventSource.CLOSED) {
                console.log("Connection was closed.");
            }else{
                console.log("Something else");
            }
        }, false);
    };

    function updateItemsPage(event) {
        var item = $('<li>').text(event);
        $('#items').prepend(item);
    }

So, why is this cool?  Well, firstly it leverages an advanced key-value store, Redis.  Next, Rails 4 Live streaming is is a huge advantage.  It allows Rails apps to be competitive with Node.js. Unfortunately most Rails application servers are not able to stream, so throw thin + unicorn out.  Puma is the way forward it would seem.