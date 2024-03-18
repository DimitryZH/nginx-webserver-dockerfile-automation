# Use Ubuntu 22.04 as the base image for building the application
FROM ubuntu:22.04 AS builder
# Adding author label to the image
LABEL author=DimitryZH
# Install necessary tools
RUN apt-get update && apt-get install -y git
# Cloning the website code from GitHub repository 
RUN git clone https://github.com/DimitryZH/content-widget-factory-inc.git /tmp/widget-factory-inc
# Clean up unnecessary files
RUN rm -rf /tmp/widget-factory-inc/.git
# Final runtime environment
FROM ubuntu:22.04
# Install Nginx
RUN apt-get update && apt-get install -y nginx
# Copy website code from the builder stage
COPY --from=builder /tmp/widget-factory-inc/web /var/www/html
# Setting the working directory
WORKDIR /var/www/html/
# Clean up unnecessary tools
RUN apt-get purge -y git && apt-get autoremove -y && apt-get clean
# Expose port 80
EXPOSE 80
# Start Nginx service
CMD ["nginx", "-g", "daemon off;"]
