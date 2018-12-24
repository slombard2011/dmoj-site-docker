#FROM ubuntu:xenial
FROM debian:stretch
#FROM alpine:3.8

#RUN apk update
#RUN apk add apt
RUN apt-get update
RUN apt-get install -y git
RUN git clone https://github.com/Maitre-Hiboux/dmoj-site-docker
RUN git clone https://github.com/ajaxorg/ace-builds
RUN chmod 755 /dmoj-site-docker/*
RUN /dmoj-site-docker/1.sh
RUN /dmoj-site-docker/2.sh
RUN /dmoj-site-docker/3.sh
RUN /dmoj-site-docker/4.sh
#RUN /dmoj-site-docker/5.sh
RUN /dmoj-site-docker/6.sh

ENV SITE_DIR=/vagrant/site
ENV FILES_DIR=/vagrant/files
ENV VIRTUALENV_PATH=/envs/dmoj

RUN adduser dmoj
RUN adduser vagrant
RUN adduser dmoj-uwsgi

#RUN /dmoj-site-docker/7.sh
RUN /dmoj-site-docker/8.sh
RUN pip install pymysql
RUN mkdir -p /vagrant/files/
RUN cp /dmoj-site-docker/files/* /vagrant/files/

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

RUN rm /vagrant/site/judge/middleware.py
ADD middleware.py /vagrant/site/judge/
RUN chmod 755 /vagrant/site/judge/middleware.py
RUN rm /vagrant/site/judge/template_context.py
ADD template_context.py /vagrant/site/judge/
RUN chmod 755 /vagrant/site/judge/template_context.py

EXPOSE 80
EXPOSE 9999
EXPOSE 9998
EXPOSE 15100
EXPOSE 15101
EXPOSE 15102

WORKDIR /vagrant/site

RUN mkdir -p /vagrant/site/static/libs/ace
RUN cp -r /ace-builds/src-noconflict/* /vagrant/site/static/libs/ace/

#ADD docker-entrypoint.sh /vagrant/site/

ENTRYPOINT ["/dmoj-site-docker/docker-entrypoint.sh"]
