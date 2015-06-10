FROM        debian:latest
MAINTAINER  Benoit <benoit@terra-art.net>

# Set Environement variables
ENV         LC_ALL=C
ENV         DEBIAN_FRONTEND=noninteractive
ENV         DOVECOT_VERSION=2.2.18

# Update package repository and install packages
RUN         apt-get -y update && \
            apt-get -y install automake autoconf libldap2-dev libmysqlclient-dev libssl-dev make wget && \
            apt-get clean

# Fetch the latest software version from the official website if needed
WORKDIR     /tmp
RUN         wget http://dovecot.org/releases/2.2/dovecot-${DOVECOT_VERSION}.tar.gz && \
            tar xvzf dovecot-${DOVECOT_VERSION}.tar.gz
WORKDIR     /tmp/dovecot-${OPENSMTPD_VERSION}
RUN         ./configure --with-ldap=yes --with-sql=yes --with-mysql --with-ssl=openssl --without-shared-libs && \
            make && make install && make clean

# Add configuration files. User can provides customs files using -v in the image startup command line.
COPY        dovecot_conf /user/etc/dovecot

# Expose IMAP(S) and LMTP port
EXPOSE      134 939 24

# Last but least, unleach the daemon!
WORKDIR     /root
ENTRYPOINT  ["/usr/local/sbin/dovecot", "-F", "-c", "/usr/local/etc/dovecot/dovecot.conf"]
