FROM ubuntu:xenial

RUN apt-get update
RUN apt-get install -y nano wget supervisor nginx git gcc g++ make python-dev python-pip libxml2-dev libxslt1-dev zlib1g-dev ruby-sass gettext curl

RUN pip install --upgrade pip

RUN wget -q --no-check-certificate -O- https://bootstrap.pypa.io/get-pip.py | python


RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs


RUN npm install -g pleeease-cli

RUN echo "mysql-server mysql-server/root_password password vagrant"       | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password vagrant" | debconf-set-selections

RUN apt-get -y install mysql-server libmysqlclient-dev

#RUN /etc/init.d/mysql start

#RUN mysql -uroot -pvagrant --protocol=tcp -e "CREATE DATABASE dmoj DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci"
#RUN mysql -uroot -pvagrant -e "grant all privileges on dmoj.* to 'vagrant'@'localhost' identified by 'vagrant'"

#RUN /etc/init.d/mysql restart


WORKDIR /opt
RUN wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN tar xvf phantomjs-2.1.1-linux-x86_64.tar.bz2

ENV SITE_DIR=/vagrant/site
ENV FILES_DIR=/vagrant/files
ENV VIRTUALENV_PATH=/envs/dmoj

RUN adduser dmoj

RUN pip install virtualenv
RUN rm -rf $VIRTUALENV_PATH
RUN mkdir -p $VIRTUALENV_PATH

RUN virtualenv -p python $VIRTUALENV_PATH
RUN adduser vagrant
RUN mkdir /vagrant
RUN chown -R vagrant:vagrant $VIRTUALENV_PATH


RUN git clone https://github.com/DMOJ/site.git $SITE_DIR
WORKDIR $SITE_DIR
RUN git pull
RUN git submodule init
RUN git submodule update
RUN chmod +x $VIRTUALENV_PATH/bin/activate
RUN $VIRTUALENV_PATH/bin/activate

WORKDIR $SITE_DIR

RUN npm install

RUN git config --global url."https://github.com/".insteadOf git@github.com
RUN git config --global url."https:".insteadOf git:

RUN pip install -r requirements.txt
RUN pip install mysqlclient
RUN pip install websocket-client

WORKDIR /
RUN git clone https://github.com/Xyene/dmoj-env/
RUN mkdir -p $FILES_DIR
RUN cp /dmoj-env/site-env/files/* $FILES_DIR/

WORKDIR $SITE_DIR
 
RUN cp $FILES_DIR/local_settings.py /vagrant/site/dmoj/local_settings.py

#RUN python manage.py check
RUN python manage.py migrate

RUN make_style.sh

RUN echo "yes" | python manage.py collectstatic
RUN python manage.py compilemessages
RUN python manage.py compilejsi18n
RUN python manage.py loaddata navbar
RUN python manage.py loaddata language_small
RUN python manage.py loaddata demo

RUN mkdir -p /vagrant/files
WORKDIR /vagrant/files

RUN curl -s http://uwsgi.it/install | bash -s default "$PWD/uwsgi" >> "$LOGS_DIR/uwsgi.log"

RUN touch /vagrant/bridge.log
RUN chmod 666 /vagrant/bridge.log

RUN cp $FILES_DIR/site.conf /etc/supervisor/conf.d/site.conf
RUN cp $FILES_DIR/bridged.conf /etc/supervisor/conf.d/bridged.conf
RUN cp $FILES_DIR/nginx.conf /etc/nginx/conf.d/nginx.conf
RUN sed -i 's|# server_names_hash_bucket_size 64;|server_names_hash_bucket_size 265;|g' /etc/nginx/nginx.conf

RUN systemctl restart supervisor
RUN systemctl restart nginx
