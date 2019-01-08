FROM debian:stretch

RUN apt-get update
RUN apt-get install -y git

RUN mkdir -p /dmoj-site-docker/files
RUN mkdir /dmoj-site-docker/buildscripts
COPY * /dmoj-site-docker/
COPY files/* /dmoj-site-docker/files/
COPY buildscripts/* /dmoj-site-docker/buildscripts/

RUN git clone https://github.com/ajaxorg/ace-builds
RUN chmod 755 -R /dmoj-site-docker/*

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
COPY files/site.conf /etc/supervisor/conf.d/site.conf
COPY files/bridged.conf /etc/supervisor/conf.d/bridged.conf
COPY files/wsevent.conf /etc/supervisor/conf.d/wsevent.conf
COPY files/config.js /dmoj/site/websocket/

RUN apt-get install python-ldap
#RUN pip install ldap
RUN apt-get install -y python-django-auth-ldap
RUN npm install qu ws simplesets

ADD files/nginx.conf /etc/nginx/conf.d/
RUN rm /etc/nginx/sites-available/default
RUN rm /etc/nginx/sites-enabled/default
ADD files/default /etc/nginx/sites-available/
ADD files/default /etc/nginx/sites-enabled/

RUN rm /dmoj/site/judge/middleware.py
ADD middleware.py /dmoj/site/judge/
RUN chmod 755 /dmoj/site/judge/middleware.py
RUN rm /dmoj/site/judge/template_context.py
ADD template_context.py /dmoj/site/judge/
RUN chmod 755 /dmoj/site/judge/template_context.py

EXPOSE 80
EXPOSE 9999
EXPOSE 9998
EXPOSE 15100
EXPOSE 15101
EXPOSE 15102

WORKDIR /dmoj/site

RUN mkdir -p /dmoj/site/static/libs/ace
RUN cp -r /ace-builds/src-noconflict/* /dmoj/site/static/libs/ace/

ADD docker-entrypoint.sh /dmoj/site/
RUN chmod 755 /dmoj/site/docker-entrypoint.sh
#ENTRYPOINT ["/dmoj/site/docker-entrypoint.sh"]
