# we will inherit from  the Debian image on DockerHub
FROM debian

# set timezone so files' timestamps are correct
ENV TZ=Europe/Madrid

# install apache and php 7.3
# we include procps and telnet so you can use these with shell.sh prompt
RUN apt-get update -qq >/dev/null && apt-get install -y -qq procps telnet apache2 php7.3 -qq >/dev/null

# HTML server directory
WORKDIR /var/www/html
COPY . /var/www/html/

# Install mod evasive
RUN apt install aptitude -y
RUN aptitude install libapache2-mod-evasive -y
COPY evasive.conf /etc/apache2/mods-enabled/
RUN mkdir -p /var/log/mod_evasive
RUN chown -R root:www-data /var/log/mod_evasive
# Install text editor vi
RUN apt install vim -y

# The PHP app is going to save its state in /data so we make a /data inside the container
RUN mkdir /data && chown -R www-data /data && chmod 755 /data & chmod 777 -R /var/www/html/

# we need custom php configuration file to enable userdirs
COPY php.conf /etc/apache2/mods-available/php7.3.conf

# we run a script to stat the server; the array syntax makes it so ^C will work as we want
CMD  ["./entrypoint.sh"]

# Start apache2 service
RUN service apache2 start
