FROM ubuntu:xenial

RUN apt-get update
RUN apt-get install -y git
RUN git clone https://github.com/Maitre-Hiboux/dmoj-site-docker
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
RUN pip install uwsgi
RUN uwsgi --ini /uwsgi/uwsgi.ini
#RUN curl http://uwsgi.it/install | bash -s default $PWD/uwsgi
COPY files/site.conf /etc/supervisor/conf.d/site.conf
COPY files/bridged.conf /etc/supervisor/conf.d/bridged.conf
#COPY files/wsevent.conf /etc/supervisor/conf.d/wsevent.conf
#COPY files/config.js /site/websocket

RUN pip install ldap
RUN pip install django_auth_ldap

RUN rm -v /etc/nginx/nginx.conf
ADD files/nginx.conf /etc/nginx/
#RUN echo "daemon off;" >> /etc/nginx/nginx.conf

EXPOSE 80
EXPOSE 9999
EXPOSE 9998
EXPOSE 15100
EXPOSE 15101
EXPOSE 15102

WORKDIR /vagrant/site

ADD start.sh /vagrant/site/


CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
CMD ["/usr/sbin/supervisor"]
