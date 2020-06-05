# blog.beilabs.com
Hosts the source code for the jekyll blog
Automatically builds the master branch and deploys to our kubernetes cluster when pushed

## Docker commands
docker build -t blog .
docker run -d -p 80:80 blog
curl http://172.17.0.1/

## Github
https://github.com/jonathanclarke/blog.beilabs.com

## Docker Hub
https://cloud.docker.com/repository/docker/vayu/blog.beilabs.com

## Buildkite
https://buildkite.com/banba-group/www-dot-beilabs-dot-com
