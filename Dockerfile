FROM debian:stable

RUN apt-get update && apt-get install -y supervisor nginx wget

RUN if [ ! -e '/bin/systemctl' ]; then ln -s /bin/echo /bin/systemctl; fi
RUN wget -q https://omnidb.org/dist/2.16.0/omnidb-server_2.16.0-debian-amd64.deb \
    && dpkg -i omnidb-server_2.16.0-debian-amd64.deb \
    && rm -rf omnidb-server_2.16.0-debian-amd64.deb


COPY /dockup /dockup
COPY /dockup/supervisor.conf /etc/supervisor/conf.d/omnidb.conf
COPY /dockup/nginx.conf /etc/nginx/sites-available/default
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

EXPOSE 80

CMD ["supervisord", "-n"]
