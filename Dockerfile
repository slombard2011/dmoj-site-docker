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
#RUN curl http://uwsgi.it/install | bash -s default $PWD/uwsgi
COPY files/site.conf /etc/supervisor/conf.d/site.conf
COPY files/bridged.conf /etc/supervisor/conf.d/bridged.conf
#COPY files/wsevent.conf /etc/supervisor/conf.d/wsevent.conf
#COPY files/config.js /site/websocket


#RUN rm /etc/nginx/sites-enabled/*
#ADD files/nginx.conf /etc/nginx/sites-enabled
#RUN service nginx reload

RUN service supervisor start
#RUN service nginx start


#RUN /dmoj-site-docker/10.sh
EXPOSE 80
EXPOSE 9999
EXPOSE 9998
EXPOSE 15100
EXPOSE 15101
EXPOSE 15102

