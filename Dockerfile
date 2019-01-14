FROM debian:stretch
LABEL maintainer="maxime.prost@edf.fr"

RUN mkdir -p /dmoj-site-docker/files
RUN mkdir /dmoj-site-docker/buildscripts
COPY * /dmoj-site-docker/
COPY files/* /dmoj-site-docker/files/
COPY buildscripts/* /dmoj-site-docker/buildscripts/
RUN chmod +x /dmoj-site-docker/buildscripts/*

RUN /dmoj-site-docker/buildscripts/logsinit.sh
RUN /dmoj-site-docker/buildscripts/dependencies.sh
RUN /dmoj-site-docker/buildscripts/node.sh
RUN /dmoj-site-docker/buildscripts/pleeeasecli.sh
RUN /dmoj-site-docker/buildscripts/phantomjs.sh

ENV SITE_DIR=/dmoj/site
ENV FILES_DIR=/dmoj/files
ENV VIRTUALENV_PATH=/envs/dmoj

RUN adduser dmoj
RUN adduser dmoj-uwsgi

RUN /dmoj-site-docker/buildscripts/webapp.sh
RUN pip install pymysql
RUN mkdir -p /dmoj/files/
RUN cp /dmoj-site-docker/files/* /dmoj/files/

RUN /dmoj-site-docker/buildscripts/setupapp.sh


WORKDIR /dmoj-site-docker/files

RUN mkdir /uwsgi
WORKDIR /uwsgi
COPY files/uwsgi.ini /uwsgi

RUN pip install uwsgi

RUN /dmoj-site-docker/buildscripts/processconf.sh
RUN /dmoj-site-docker/buildscripts/offline.sh

WORKDIR /dmoj/site
RUN mkdir -p /dmoj/site/static/libs/ace
RUN cp -r /ace-builds/src-noconflict/* /dmoj/site/static/libs/ace/
RUN npm install qu ws simplesets
ADD docker-entrypoint.sh /dmoj/site/
RUN chmod 755 /dmoj/site/docker-entrypoint.sh

EXPOSE 80
EXPOSE 9999
EXPOSE 9998
EXPOSE 15100
EXPOSE 15101
EXPOSE 15102

ENTRYPOINT ["/dmoj/site/docker-entrypoint.sh"]
