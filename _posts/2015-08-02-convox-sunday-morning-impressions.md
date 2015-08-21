---
layout: post
title:  "Convox - Sunday morning impressions"
date:   2015-08-02 
categories: devops docker convox
tags: devops docker convox
image:  http://www.beilabs.com/public/article_images/2015-08-02-convox-sunday-morning-impressions/code.png
excerpt: Sunday morning browsing Hacker News brought me to Convox.  Shiney! Lets dive in.
---


Sunday morning browsing Hacker News brought me to Convox.  Shiney! Lets dive in.

    Convox is an open source Platform as a Service that runs in your own Amazon Web Services (AWS) account. Instead of signing up for a multi-tenant PaaS like Heroku, you can have your own. This gives you privacy and control over your platform and avoids the substantial markup on AWS prices that other platforms charge.

Sounds great.  I've always wanted to check out Docker and possibly lower my platform bills as a result.  With Opsworks shitting a brick on Friday and Chef just being a pile of shit I decided to jump into the rabbit hole head first. 

Firstly, I install the CLI on my laptop (Since coming to Nepal I face about 50 hours of powercuts each week, my linux machine is not an option yet.)

    $: curl -Ls https://www.convox.com/downloads/osx/convox.zip     /tmp/convox.zip
    $: unzip /tmp/convox.zip -d /usr/local/bin

So, todays goal is to remove this blog from Heroku.  I haven't used heroku in some time so I set up a new application on Monday.  Imagine my shock when I found that instead of just letting my application get some sleeep (feck all people read this app), the app was constantly being used according to Heroku and they were shoving email reminders down my throat.  

Now that its installed on my local machine (very familiar to the heroku installable) I need to set it up for my AWS account.

    $: convox install

All of the AWS resources required for creating a powerful app deployment platform will be correctly configured at this point. (excellent)

        ___    ___     ___   __  __    ___   __  _
       / ___\ / __ \ /  _  \/\ \/\ \  / __ \/\ \/ \
      /\ \__//\ \_\ \/\ \/\ \ \ \_/ |/\ \_\ \/     </
      \ \____\ \____/\ \_\ \_\ \___/ \ \____//\_/\_\
       \/____/\/___/  \/_/\/_/\/__/   \/___/ \//\/_/
    
    
    This installer needs AWS credentials to install the Convox platform into
    your AWS account. These credentials will only be used to communicate
    between this installer running on your computer and the AWS API.
    
    We recommend that you create a new set of credentials exclusively for this
    install process and then delete them once the installer has completed.
    
    To generate a new set of AWS credentials go to:
    https://console.aws.amazon.com/iam/home?region=us-east-1#security_credential
    
    AWS Access Key ID: **********
    AWS Secret Access Key: **********

It's at this point I feel as an adventurer of old, not sure what to expect.  I hit enter. 



    Installing Convox...
    Created ECS Cluster: convo-Clust-*******
    Created IAM User: convox-RegistryUser-*******
    Created Access Key: *******
    Created IAM User: convox-LogsUser-*******
    Created IAM User: convox-KernelUser-*******
    Created Access Key: *******
    Created Access Key: *******
    Created S3 Bucket: convox-settings-*******
    Created S3 Bucket: convox-registrybucket-*******
    Created Lambda Function: convox-CustomTopic-*******
    Created VPC: vpc-*******
    Created VPC Internet Gateway: igw-*******
    Created Routing Table: rtb-*******
    Created Unknown: Custom::KMSKey: EncryptionKey
    Created Kinesis Stream: convox-Kinesis-*******
    Created DynamoDB Table: convox-releases
    Created DynamoDB Table: convox-builds
    Created Security Group: sg-*******
    Created Security Group: sg-*******
    Created VPC Subnet: subnet-*******
    Created VPC Subnet: subnet-*******
    Created VPC Subnet: subnet-*******
    Created Elastic Load Balancer: convox
    Created ECS TaskDefinition: KernelTasks
    Created ECS Service: Kernel
    Created AutoScalingGroup: convox-Instances-*******
    Created CloudFormation Stack: convox
    Waiting for load balancer...
    Logging in...
    Success, try `convox apps`

Holy carp!  The kraken has been unleased!  Yeah, I know, my adventurer plot down a rabbit hole now has a large legendary sea monster involved (Its my story, deal with it) * Aside, I'm very sarcastic when I don't have coffee yet. Also, to those assholes who want to know the AWS Access keys - hahaha.

Try 'convox apps' you say?  What does it do?  

,![I must know](/public/article_images/2015-08-02-convox-sunday-morning-impressions/i-must-know.png "I must know")

    $: convox apps
    APP  STATUS

I am disappoint.

OK, so nothing is there, but wait, that's a good thing.  Thankfully Convox is not a stealth porn empire looking for access keys + scaling up its massive clusters on the backs of Hacker News readers.  Thankfully, otherwise, I'd be screwed.  This reminds me, someone, not me, should really do a good code review of this to make sure there is not some shady shit happening in the background of all this awesomeness!

So, I said before I want to get this blog off of heroku.  Lets create my blog on Convox and see how we far we can get.

    $: convox apps create
    Creating app www.beilabs.com: 
    ERROR: ValidationError: 1 validation error detected: Value 'www.beilabs.com' at 'stackName' failed to satisfy constraint: Member must satisfy regular expression pattern: [a-zA-Z][-a-zA-Z0-9]*
    	status code: 400, request id: [e68bc3ac-38ea-11e5-8e84-f5001148309a]

Hmm, ok, same rules as heroku so.  Lets create www-beilabs-com instead. 

    $: convox apps create www-beilabs-com
    Creating app www-beilabs-com: 
    ERROR: <html><body><h1>408 Request Time-out</h1>
    Your browser didn't send a complete request in time.
    </body></html>

Eh.  Ok, something went wrong but I'm not sure what happened.  Is my app created or what?  Lets see if I can list the apps that are there:

    $: convox apps
    APP              STATUS
    www-beilabs-com  creating


Hmmm....I might come back to this later.

Oh, hi, what's this.  3 EC2 nodes have been set up with a load balancer.  My free blog now costs about $85 a month. 

    convox apps delete www-beilabs-com
    convox uninstall

I'll return to this for something meatier in production.  In the meantime; I think I'll start reading up on exactly what architecture decisions they have made so I can incorporate it into my Opsworks stack.

First impressions though, pretty awesome.  If they can somehow have this scaled down for a single instance and then gradually scale up with the introduction of a load balancer at that point.  Auto custom domain integration with Route 53 for bonus points would be great. 





