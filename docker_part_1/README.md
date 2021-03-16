# Task list

1. Run container from ubuntu image: 
    ```$ docker run -d --name ubuntu-container ubuntu sleep 500```
    * Login to this container: 
    ```$ docker exec -it ubuntu-container /bin/bash```
    * Create file /sizefile with size 100MB:  
    ```$ dd if=/dev/zero of=sizefile bs=1024 count=102400```
    * Check docker container size(RW layer and virtual size): 
    ```$ docker ps --size | grep 'ubuntu-container'```
    * Delete container: 
    ```$ docker container stop ubuntu-container && docker container rm ubuntu-container```
2. Create your own image hw14 based on ubuntu image
    ```docker build ./ -t hw_14_image:0.1```
    * For this use Dockerfile
    * Add file /sizefile with size =100MB to Dockerfile
    * Run container from hw14 images
    ```docker run -d --name hw14-container hw_14_image:0.1 sleep 500```
    * Check docker container size(RW layer and virtual size)
    * Push your image to your docker hub account(create if account does not exist)
    ```docker pull antonstasheuski/dockerhub:hw_14_image```
3. Run containers from ubuntu image
    * With first mount use bind mount
    ```docker run -d --rm --name ubuntu-container -v $(pwd)/bash_scripts:/app ubuntu sleep 500```
    * With second run use volume mount
    ```docker run -d --rm --name ubuntu-container -v myvol:/app ubuntu sleep 500```
4. Run nginx container from nginx image.
    * Map 8081 port to 80 port of nginx container. Check it
    ```docker run --name mynginx1 -p 80:80 -d nginx```
    * Do not use a particular port and get any random port mapped to 80 port of your nginx container. [image1]


# Documentation

* https://docs.docker.com/
* https://codefresh.io/docker-tutorial/build-docker-image-dockerfiles/

# Images

Nginx container: ![image1](https://i.ibb.co/tQD7mmW/Screenshot-2021-03-16-at-23-09-33.png)

# Links

My docker hub: https://hub.docker.com/u/antonstasheuski
