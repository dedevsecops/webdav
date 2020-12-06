FROM httpd:2.4.46-alpine

# Need openssl to generate self-signed certificates for Quick Start.
RUN apk add --no-cache openssl

# Enabling SSL and disabling insecure HTTP traffic on port 80.
RUN sed -i \
        -e 's/^#\(Include .*httpd-ssl.conf\)/\1/' \
        -e 's/^#\(LoadModule .*mod_socache_shmcb.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_ssl.so\)/\1/' \
        -e 's/^Listen 80/#Listen 80/' \
        conf/httpd.conf

# Enabling WebDAV
RUN mkdir /usr/local/apache2/var
RUN chown daemon:daemon /usr/local/apache2/var
RUN mkdir /usr/local/apache2/uploads
RUN chown daemon:daemon /usr/local/apache2/uploads
RUN sed -i \
        -e 's/^#\(Include .*httpd-dav.conf\)/\1/' \
        -e 's/^#\(LoadModule .*mod_auth_digest.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_dav.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_dav_fs.so\)/\1/' \
        -e 's/^#\(LoadModule .*mod_dav_lock.so\)/\1/' \
        conf/httpd.conf
COPY user.passwd /usr/local/apache2/

# Adding docker-entrypoint that generates self-signed SSL cert if no cert is found.
COPY docker-entrypoint /usr/local/bin/
CMD ["docker-entrypoint"]
