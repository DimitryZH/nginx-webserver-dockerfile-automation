# Nginx Web Server Dockerfile Automation

## Description
Creating a container image by hand is possible, as shown [here](https://github.com/DimitryZH/handcrafting-container-image), but it requires manual processes. There has to be a more automatic way to build images. Manual processes do not scale and are not easily version controlled. Docker provides a solution to this problem - the Dockerfile. Here I will create a Dockerfile to build an image, and host a static website.

## Implementation

Follow these steps to implement the Dockerfile automation:

1. Create a new directory:
   ```bash
   mkdir newdir
2. Create a Dockerfile:
  ```bash
  touch dockerfile
  ```
3. Paste the following commands into the Dockerfile:
  ```bash
  nano dockerfile
```
## Dockerfile
 ```Dockerfile
# Use Ubuntu 22.04 as the base image for building the application
FROM ubuntu:22.04 AS builder
LABEL author=DimitryZH

# Install necessary tools and clone the website code
RUN apt-get update && apt-get install -y \
    git

RUN git clone https://github.com/DimitryZH/content-widget-factory-inc.git /tmp/widget-factory-inc

# Clean up unnecessary files
RUN rm -rf /tmp/widget-factory-inc/.git

# Final runtime environment
FROM ubuntu:22.04

# Install Nginx
RUN apt-get update && apt-get install -y \
    nginx

# Copy website code from the builder stage
COPY --from=builder /tmp/widget-factory-inc/web /var/www/html

WORKDIR /var/www/html/

# Clean up unnecessary tools
RUN apt-get purge -y \
    git && \
    apt-get autoremove -y && \
    apt-get clean

# Expose port 80
EXPOSE 80

# Start Nginx service
CMD ["nginx", "-g", "daemon off;"]
```
Exit from the text editor.

4. Run the command to build an image:

```bash
docker build -t dockerfileimage:v01 .
```
5. Run container from the image:
```bash
docker run -d --name mycontainer -p 8081:80 dockerfileimage:v01
```
6. Verify the container running on <SERVER_PUBLIC_IP_ADDRESS>:8081.
   
## Results
Link to the image built can be found in my DockerHub [here](https://hub.docker.com/r/dmitryzhuravlev/dockerfileimage).

## Summary
This Dockerfile automates the process of building an Nginx web server container image, making it easier to manage and deploy static websites.
