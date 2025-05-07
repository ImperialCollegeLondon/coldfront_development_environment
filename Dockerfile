FROM python:3.11-slim

ADD imperial_coldfront_plugin /usr/src/imperial_coldfront_plugin
WORKDIR /usr/src/
RUN apt-get update && apt-get install -y python3-dev default-libmysqlclient-dev build-essential pkg-config
RUN pip install -r imperial_coldfront_plugin/requirements.txt && pip install -e imperial_coldfront_plugin && pip install mysqlclient==2.2.7
RUN mkdir /etc/coldfront
ADD coldfront_overrides/urls.py /usr/local/lib/python3.11/site-packages/coldfront/config/urls.py
ADD coldfront_overrides/settings.py /usr/local/lib/python3.11/site-packages/coldfront/config/settings.py
ADD coldfront_overrides/plugin_settings.py /usr/local/lib/python3.11/site-packages/coldfront/config/plugins/imperial.py
ADD coldfront_overrides/authorized_navbar.html /usr/local/lib/python3.11/site-packages/coldfront/templates/common/authorized_navbar.html
ADD coldfront_overrides/authorized_home.html /usr/local/lib/python3.11/site-packages/coldfront/templates/portal/authorized_home.html
ADD coldfront_overrides/navbar_admin.html /usr/local/lib/python3.11/site-packages/coldfront/templates/common/navbar_admin.html
ADD coldfront_overrides/nonauthorized_navbar.html /usr/local/lib/python3.11/site-packages/coldfront/templates/common/nonauthorized_navbar.html
ADD coldfront_overrides/project_detail.html /usr/local/lib/python3.11/site-packages/coldfront/templates/project/project_detail.html
ADD coldfront_overrides/project_list.html /usr/local/lib/python3.11/site-packages/coldfront/templates/project/project_list.html
ADD coldfront_overrides/project_user_detail.html /usr/local/lib/python3.11/site-packages/coldfront/templates/project/project_user_detail.html
ADD coldfront_overrides/allocation_detail.html /usr/local/lib/python3.11/site-packages/coldfront/templates/allocation/allocation_detail.html
ADD coldfront_overrides/project_add_users.html /usr/local/lib/python3.11/site-packages/coldfront/templates/project/project_add_users.html
ADD coldfront_overrides/allocation_add_users.html /usr/local/lib/python3.11/site-packages/coldfront/templates/allocation/allocation_add_users.html
ADD coldfront_overrides/allocation_remove_users.html /usr/local/lib/python3.11/site-packages/coldfront/templates/allocation/allocation_remove_users.html

RUN mkdir /db && chown nobody:nogroup /db
VOLUME /db
RUN mkdir -p /srv/coldfront && chown nobody:nogroup /srv/coldfront
VOLUME /srv/coldfront

# imperial specific settings
ADD local_settings.py /etc/coldfront/local_settings.py
USER nobody
