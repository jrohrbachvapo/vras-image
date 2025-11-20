FROM registry.access.redhat.com/ubi8:latest

# --build-arg USER_PASSWD=password-goes-here
ARG USER_PASSWD
# ARG ISC_PACKAGE_PLATFORM=lnxrh8x64

# Update package lists
RUN dnf -y --refresh update

# Install software (example with curl and git)
RUN dnf -y install openssl httpd hostname wget procps-ng

# Enable FIPS Mode
RUN fips-mode-setup --enable

# Allow Apache to run on priv ports
# RUN setcap 'cap_net_bind_service=+ep' /usr/sbin/httpd
# RUN chown -R apache:apache /var/log/httpd
# RUN chown -R apache:apache /etc/httpd/run
# RUN chmod 755 /var/log/httpd
# RUN chmod 775 /etc/httpd/run

# Change default port 80 to 8080
RUN sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf

# Setup the IRIS env vars
ENV ISC_PACKAGE_HOSTNAME = "localhost" \
    ISC_PACKAGE_SUPERSERVER_PORT = 1972 \
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
RUN chown -R 0:0 /var/www/html && chmod -R g+rwX /var/www/html
RUN chown -R 0:0 /var/log/httpd && chmod -R g+rwX /var/log/httpd
RUN chown -R 0:0 /etc/httpd/run && chmod -R g+rwX /etc/httpd/run
RUN chown -R 0:0 /etc/httpd/logs && chmod -R g+rwX /etc/httpd/logs

USER 1001

EXPOSE 8080/tcp
EXPOSE 8443/tcp

# WORKDIR /var/www/html

# Start Apache in the foreground
CMD ["httpd", "-D", "FOREGROUND", "-E", "/tmp/error_log"]
# ENTRYPOINT ["/tini", "--", "httpd", "-D", "FOREGROUND"]

LABEL maintainer="Ronaldo Nascimento <ronaldo.nascimento@va.gov>" \
    version="2.6.5" \
    description="VA Baseline RHEL 8 with InterSystems WebGateway 2024.1.4"
