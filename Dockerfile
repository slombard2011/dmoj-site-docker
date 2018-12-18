FROM ubuntu:xenial

RUN apt-get update
RUN apt-get install -y git
RUN git clone https://github.com/Maitre-Hiboux/dmoj-site-docker
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

RUN /dmoj-site-docker/7.sh
RUN /dmoj-site-docker/8.sh
RUN /dmoj-site-docker/9.sh
RUN /dmoj-site-docker/10.sh




