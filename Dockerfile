FROM ubuntu:xenial

RUN apt-get update
RUN apt-get install -y git
RUN git clone https://github.com/Maitre-Hiboux/dmoj-site-docker
RUN chmod 755 /dmoj-site-docker/*
RUN /dmoj-site-docker/1.sh
RUN /dmoj-site-docker/2.sh
RUN /dmoj-site-docker/3.sh
RUN /dmoj-site-docker/4.sh
RUN /dmoj-site-docker/5.sh
RUN /dmoj-site-docker/6.sh

ENV SITE_DIR=/vagrant/site
ENV FILES_DIR=/vagrant/files
ENV VIRTUALENV_PATH=/envs/dmoj

RUN adduser dmoj
RUN adduser vagrant

RUN /dmoj-site-docker/7.sh
RUN /dmoj-site-docker/8.sh
RUN pip install pymysql
RUN mkdir -p /vagrant/files/
RUN cp /dmoj-site-docker/files/* /vagrant/files/

RUN /dmoj-site-docker/9.sh


WORKDIR /dmoj-site-docker/files

RUN mkdir /uwsgi
WORKDIR /uwsgi
COPY uwsgi.ini /uwsgi
RUN curl http://uwsgi.it/install | bash -s default $PWD/uwsgi
RUN apt-get install -y supervisor
COPY site.conf /etc/supervisor/conf.d/site.conf
COPY bridged.conf /etc/supervisor/conf.d/bridged.conf
COPY wsevent.conf /etc/supervisor/conf.d/wsevent.conf
COPY config.js /site/websocket

#RUN apt-get install -y nginx
RUN rm /etc/nginx/sites-enabled/*
ADD nginx.conf /etc/nginx/sites-enabled
RUN service nginx reload

RUN service supervisor start
RUN service nginx start



#RUN /dmoj-site-docker/10.sh
EXPOSE 80



