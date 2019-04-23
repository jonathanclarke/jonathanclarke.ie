---
layout: post
title: Ruby 4 secret_key_base
---

Something that caught be out week was the introduction of the secret_key base in Rails 4. 

When adding a new environment make sure to add the secret_key_base for your environment in config/secrets.yml.  
<pre>
  <code class="ruby">
    development:
      secret_key_base: YOUR_DEVELOPMENT_KEY_HERE
    test:
      secret_key_base: YOUR_TEST_KEY_HERE
    staging:
      secret_key_base: YOUR_STAGING_KEY_HERE
    production:
      secret_key_base: YOUR_PRODUCTION_KEY_HERE
  </code>
</pre>
