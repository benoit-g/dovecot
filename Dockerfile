2.2.18.tar.gz

FROM        debian:latest
MAINTAINER  Benoit <benoit@terra-art.net>

# Set Environement variables
ENV         LC_ALL=C
ENV         DEBIAN_FRONTEND=noninteractive
ENV         DOVECOT_VERSION=2.2.18

# Update package repository and install packages
RUN         apt-get -y update && \
            apt-get -y install automake autoconf libssl-dev make wget && \
            apt-get clean

# Fetch the latest software version from the official website if needed
WORKDIR     /tmp
RUN         wget http://dovecot.org/releases/2.2/dovecot-${DOVECOT_VERSION}.tar.gz && \
            tar xvzf dovecot-${DOVECOT_VERSION}.tar.gz
WORKDIR     /tmp/dovecot-${OPENSMTPD_VERSION}
RUN         ./configure && make && make install

# Add configuration files. User can provides customs files using -v in the image startup command line.
COPY        dovecot_conf /user/etc/dovecot

# Expose IMAP port
EXPOSE      143

# Last but least, unleach the daemon!
WORKDIR     /root
ENTRYPOINT  ["/usr/local/sbin/dovecot", "-F", "-c", "/usr/local/etc/dovecot/dovecot.conf"]
