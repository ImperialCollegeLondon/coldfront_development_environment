FROM python:3.11-slim
WORKDIR /usr/src/
RUN apt-get update && apt-get install -y python3-dev default-libmysqlclient-dev build-essential pkg-config

ADD imperial_coldfront_plugin /usr/src/imperial_coldfront_plugin
ADD requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

# support sqlite for development
RUN mkdir /db && chown nobody:nogroup /db
VOLUME /db

# static files directory
RUN mkdir -p /srv/coldfront && chown nobody:nogroup /srv/coldfront
VOLUME /srv/coldfront

# imperial specific settings
RUN mkdir /etc/coldfront
ADD local_settings.py /etc/coldfront/local_settings.py
USER nobody

# template overrides
ADD coldfront_overrides/urls.py /usr/local/lib/python3.11/site-packages/coldfront/config/urls.py
ADD coldfront_overrides/settings.py /usr/local/lib/python3.11/site-packages/coldfront/config/settings.py
ADD coldfront_overrides/plugin_settings.py /usr/local/lib/python3.11/site-packages/coldfront/config/plugins/imperial.py
ADD coldfront_overrides/templates/authorized_navbar.html /usr/local/lib/python3.11/site-packages/coldfront/templates/common/authorized_navbar.html
ADD coldfront_overrides/templates/authorized_home.html /usr/local/lib/python3.11/site-packages/coldfront/templates/portal/authorized_home.html
ADD coldfront_overrides/templates/nonauthorized_home.html /usr/local/lib/python3.11/site-packages/coldfront/templates/portal/nonauthorized_home.html
ADD coldfront_overrides/templates/navbar_admin.html /usr/local/lib/python3.11/site-packages/coldfront/templates/common/navbar_admin.html
ADD coldfront_overrides/templates/nonauthorized_navbar.html /usr/local/lib/python3.11/site-packages/coldfront/templates/common/nonauthorized_navbar.html
ADD coldfront_overrides/templates/project_detail.html /usr/local/lib/python3.11/site-packages/coldfront/templates/project/project_detail.html
ADD coldfront_overrides/templates/project_list.html /usr/local/lib/python3.11/site-packages/coldfront/templates/project/project_list.html
ADD coldfront_overrides/templates/project_user_detail.html /usr/local/lib/python3.11/site-packages/coldfront/templates/project/project_user_detail.html
ADD coldfront_overrides/templates/allocation_detail.html /usr/local/lib/python3.11/site-packages/coldfront/templates/allocation/allocation_detail.html
ADD coldfront_overrides/templates/project_add_users.html /usr/local/lib/python3.11/site-packages/coldfront/templates/project/project_add_users.html
ADD coldfront_overrides/templates/allocation_remove_users.html /usr/local/lib/python3.11/site-packages/coldfront/templates/allocation/allocation_remove_users.html
ADD coldfront_overrides/static/ /usr/share/coldfront/site/static/
ADD coldfront_overrides/templates/navbar_brand.html /usr/local/lib/python3.11/site-packages/coldfront/templates/common/navbar_brand.html
ADD coldfront_overrides/templates/allocation_list.html /usr/local/lib/python3.11/site-packages/coldfront/templates/allocation/allocation_list.html
