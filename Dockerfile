#FROM ubuntu:xenial
FROM debian:stretch
#FROM alpine:3.8

#RUN apk update
#RUN apk add apt
RUN apt-get update
RUN apt-get install -y git
RUN mkdir -p /dmoj-site-docker/files
COPY * /dmoj-site-docker/
COPY files/* /dmoj-site-docker/files/
#RUN git clone https://github.com/Maitre-Hiboux/dmoj-site-docker
RUN git clone https://github.com/ajaxorg/ace-builds
RUN chmod 755 /dmoj-site-docker/*
RUN /dmoj-site-docker/1.sh
RUN /dmoj-site-docker/2.sh
RUN /dmoj-site-docker/3.sh
RUN /dmoj-site-docker/4.sh
#RUN /dmoj-site-docker/5.sh
RUN /dmoj-site-docker/6.sh

ENV SITE_DIR=/dmoj/site
ENV FILES_DIR=/dmoj/files
ENV VIRTUALENV_PATH=/envs/dmoj

RUN adduser dmoj
RUN adduser dmoj-uwsgi

#RUN /dmoj-site-docker/7.sh
RUN /dmoj-site-docker/8.sh
RUN pip install pymysql
RUN mkdir -p /dmoj/files/
RUN cp /dmoj-site-docker/files/* /dmoj/files/

RUN /dmoj-site-docker/9.sh


WORKDIR /dmoj-site-docker/files

RUN mkdir /uwsgi
WORKDIR /uwsgi
COPY files/uwsgi.ini /uwsgi
#RUN rm -rf /home/root/.local/lib/python2.7/site-packages/OpenSSL
#RUN rm -rf usr/local/lib/python2.7/dist-packages/OpenSSL/
#RUN pip install pyOpenSSL

RUN echo "restart from here"

RUN pip install uwsgi
COPY files/site.conf /etc/supervisor/conf.d/site.conf
COPY files/bridged.conf /etc/supervisor/conf.d/bridged.conf
#COPY files/wsevent.conf /etc/supervisor/conf.d/wsevent.conf
#COPY files/config.js /site/websocket

RUN apt-get install python-ldap
#RUN pip install ldap
RUN apt-get install -y python-django-auth-ldap

ADD files/nginx.conf /etc/nginx/conf.d/
ADD files/nginx.conf /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/nginx.conf

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
