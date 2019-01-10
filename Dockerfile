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

ADD files/nginx.conf /etc/nginx/conf.d/
RUN rm /etc/nginx/sites-available/default
RUN rm /etc/nginx/sites-enabled/default
ADD files/default /etc/nginx/sites-available/
ADD files/default /etc/nginx/sites-enabled/

RUN rm /dmoj/site/judge/middleware.py
COPY files/middleware.py /dmoj/site/judge/
RUN chmod 755 /dmoj/site/judge/middleware.py
RUN rm /dmoj/site/judge/template_context.py
COPY files/template_context.py /dmoj/site/judge/
RUN chmod 755 /dmoj/site/judge/template_context.py
RUN rm /dmoj/site/src/dmoj-wpadmin/wpadmin/templatetags/wpadmin_menu_tags.py
COPY files/wpadmin_menu_tags.py /dmoj/site/src/dmoj-wpadmin/wpadmin/templatetags/
RUN chmod 755 /dmoj/site/src/dmoj-wpadmin/wpadmin/templatetags/wpadmin_menu_tags.py
RUN rm /dmoj/site/judge/jinja2/gravatar.py
COPY files/gravatar.py /dmoj/site/judge/jinja2/
RUN chmod 755 /dmoj/site/judge/jinja2/gravatar.py
RUN rm /dmoj/site/judge/widgets/select2.py
COPY files/select2.py /dmoj/site/judge/widgets/
RUN chmod 755 /dmoj/site/judge/widgets/select2.py
COPY files/select2.min.js /dmoj/site/
COPY files/select2.min.css /dmoj/site/
RUN chmod 766 /dmoj/site/select2.min.*

WORKDIR /dmoj/site
COPY files/mathjax.js /dmoj/site/
RUN chmod 755 /dmoj/site/mathjax.js
COPY files/mathjax-load.html /dmoj/site/templates/
RUN chmod 755 /dmoj/site/templates/mathjax-load.html
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

#ENTRYPOINT ["sh", "/dmoj/site/docker-entrypoint.sh"]
