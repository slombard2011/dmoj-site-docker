#!/bin/bash

LOGS_DIR="/dmoj/logs"
echo -e "\n --- Setting up the site to work offline (behind proxy) ---\n"
{
	rm /dmoj/site/judge/middleware.py
	cp /dmoj-site-docker/files/middleware.py /dmoj/site/judge/
	chmod 755 /dmoj/site/judge/middleware.py
	rm /dmoj/site/judge/template_context.py
	cp /dmoj-site-docker/files/template_context.py /dmoj/site/judge/
	chmod 755 /dmoj/site/judge/template_context.py
	rm /dmoj/site/src/dmoj-wpadmin/wpadmin/templatetags/wpadmin_menu_tags.py
	cp /dmoj-site-docker/files/wpadmin_menu_tags.py /dmoj/site/src/dmoj-wpadmin/wpadmin/templatetags/
	chmod 755 /dmoj/site/src/dmoj-wpadmin/wpadmin/templatetags/wpadmin_menu_tags.py
	rm /dmoj/site/judge/jinja2/gravatar.py
	cp /dmoj-site-docker/files/gravatar.py /dmoj/site/judge/jinja2/
	chmod 755 /dmoj/site/judge/jinja2/gravatar.py
	rm /dmoj/site/judge/widgets/select2.py
	cp /dmoj-site-docker/files/select2.py /dmoj/site/judge/widgets/
	chmod 755 /dmoj/site/judge/widgets/select2.py
	cp /dmoj-site-docker/files/select2.min.js /dmoj/site/
	cp /dmoj-site-docker/files/select2.min.css /dmoj/site/
	chmod 766 /dmoj/site/select2.min.*
	cp /dmoj-site-docker/files/mathjax.js /dmoj/site/
	chmod 755 /dmoj/site/mathjax.js
	cp /dmoj-site-docker/files/mathjax-load.html /dmoj/site/templates/
	chmod 755 /dmoj/site/templates/mathjax-load.html
} >> "$LOGS_DIR/offline.log"
