# docker-test
Experimenting with Docker

# Generally there are 3 components:
- **Dockerfile**    (how image is created)
- .**dockerignore**    (skip files for efficient container building)
- **docker-compose.yaml**    (how containers are built from the images)

# **Container (runnable)**
- an environment that is isolated from the rest of your operating system, similar to a VM (Virtual Machine, has its own resources such as memory, networking)
- a runnable instance of an image

# **Image (read-only)**
- contains a set of instructions that create a container
- can be pulled from **Docker Hub - Github but for docker images**
- consists of several layers:
	- parent image
	- dependencies
	- sources
	- run commands

# **Docker Server (Daemon)**
- background process that can create images and run containers

# **Commands: dc -- ("docker container" boilerplate, but use full form when executing command)**
	
- **docker run {image-name} / dc run {image-name}**    *(same meaning but container just for context) (if not found, Docker CLI contacts Daemon to check if its image is available on Docker Hub and uses it) (run = create + start)*
	- **--name {container-name}:{tag}**  
	- **--it {interactive mode}**    (can interact with container CLI)  
	- **-p {src}:{dest}**    (port mapping) (eg: 4000:4000)
	- **-v {/path/on/host}:{/path/in/container}** (volumes for host mapping, use absolute path) (this ensures whatever is updated in local device file is in sync with another file in docker container)
- **dc ls**    *(lists all running containers by default)*
- **dc create {image-name}**     *(creates container of the image but doesnt run it, it returns the newly created container ID)*
- **dc start -a {cont-id}**    *(starts the container, -a attaches the output into the terminal)*
- **docker system prune --all**     *(removes all unused images)*
- **dc logs {cont-id}**    *(shows output for last running instance)*
- **dc stop {cont-id}**    *(gives 10 seconds to clean up before killing container)*
- **dc kill {cont-id}**    *(shutdown container immediately)*
- **dc rm {cont-id}**    *-f (force, optional)* *(deletes container)*
- **dc inspect {cont-id}**    *(container info)*
- **dc exec -it {cont-id} {cont-name}**    *(exec runs a command in an existing/active container, -it flag, interact mode, allows interaction and input)*    *(if cont-name is sh with -it flag, eg: dc exec -it abcd1234 sh, it will give the shell interface of the running container where you can navigate around, "exit" to quit)*
- **dc run -it {image-rname} sh**    *(runs container and enters shell mode instantly)*

## **Creating Custom Image**
### 1. **Manual Way**
- dc run -it --name {cont-name} {image} {command}     
(eg: dc run -it --name abc-container alphine:latest /bin/sh)

- once enter interface, install whatever required.    
(eg: apk add --update redis)

- dc commit {source-cont-name} {image-name}    (creates a new image from an existing container) 
(eg: dc commit abc-container abc-copy-image)

- once committed, can run "dc run {image-name} {command}"    
(eg: dc run abc-copy-image redis-server)

- to check, open a new terminal and run this command (new terminal cause server container cannot close)
(eg: dc exec -it {new-cont-name} {command, eg: redis-cli} )

## 2. Dockerfile
- Create a Dockerfile, these are the contents:  
**FROM {base-image}  
COPY {source} {dest}  
ADD {source} {dest}  
RUN {command}  
EXPOSE {port-number}
CMD \["{initialize command}"]  
\# This is a comment**  

eg:  
FROM alphine:latest  
RUN apk add --update redis   
CMD \["redis-server"]  

Dockerfile is like a new computer, doesnt have anything at all. Base image is the OS to install. RUN will execute the command on top of the base image, usually to install dependencies. CMD will initialize and activate those dependencies. Difference between COPY and ADD is ADD can also unpack .tar files and retrieve data from the internet, these can be sources.

- To execute the Dockerfile and create an image, run:  
**docker build -t {project-name}:{tag} {directory}**  
(eg: docker build -t thenewboston/bucky-redis . )

## NOTE
- any code changes require you to rebuild the image, and run the container again, as the old image contains configurations of previous versions.

# docker-compose.yaml
### - **Command:**    **docker-compose up**
- When running, it first locates the **build** of **each service**, then it will find the **Dockerfile** in those build paths and use them to build **images for each service**
- Then, it automatically runs the created images to create containers, the containers are configured based on the properties and values stated in the .yaml file\
### - **Command:**    **docker-compose down**
- Stops and deletes all containers, but images and volumes will remain
- **--rmi all**   (deletes all images)
- **-v**    (deletes volumes)
