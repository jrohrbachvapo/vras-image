FROM registry.access.redhat.com/ubi8/httpd-24:latest

# Setup the IRIS env vars
ENV ISC_PACKAGE_HOSTNAME=localhost \
    ISC_PACKAGE_SUPERSERVER_PORT=1972 \
    ISC_PACKAGE_INSTANCENAME="VRSR0PSVR" \
    ISC_PACKAGE_PLATFORM="lnxrh8x64" \
    ISC_PACKAGE_MODE="unattended"

# Download and extract the WebGateway
# ENV IRIS_WEBGATEWAY_INSTALL_PFX=WebGateway-2024.1.4.516.1-lnxrh8x64
# COPY ${IRIS_WEBGATEWAY_INSTALL_PFX}.tar.gz /tmp
# RUN mkdir -p /tmp/webgw
# RUN tar xzf /tmp/${IRIS_WEBGATEWAY_INSTALL_PFX}.tar.gz -C /tmp/webgw

# Install WebGateway
# WORKDIR /tmp/webgw/${IRIS_WEBGATEWAY_INSTALL_PFX}/install
# RUN /tmp/webgw/${IRIS_WEBGATEWAY_INSTALL_PFX}/install/GatewayInstall
# RUN rm -rf /tmp/webgw
# RUN rm /tmp/${IRIS_WEBGATEWAY_INSTALL_PFX}.tar.gz

# Add Tini
# ENV TINI_VERSION=v0.19.0
# ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
# RUN chmod +x /tini

# Create a non-root user for OpenShift compatibility
# RUN useradd -r -u 1001 -g root -G apache runner
# RUN chmod 775 /var/log/httpd && \
#     chmod 775 /run/httpd && \
#     chmod 775 /etc/httpd/logs 

# USER 1001

# EXPOSE 8080/tcp

# WORKDIR /var/www/html

# Start Apache in the foreground
# CMD ["httpd", "-D", "FOREGROUND", "-E", "/tmp/error_log"]
# ENTRYPOINT ["/tini", "--", "httpd", "-D", "FOREGROUND"]

# CMD ["/bin/bash", "-c", "tail -f /dev/null"]
CMD ["/usr/bin/run-httpd"]
