FROM python:3.11-slim

ADD imperial_coldfront_plugin /usr/src/imperial_coldfront_plugin
WORKDIR /usr/src/
RUN pip install -r imperial_coldfront_plugin/requirements.txt && pip install -e imperial_coldfront_plugin
RUN mkdir /etc/coldfront
ADD coldfront_overrides/urls.py /usr/local/lib/python3.11/site-packages/coldfront/config/urls.py
ADD coldfront_overrides/settings.py /usr/local/lib/python3.11/site-packages/coldfront/config/settings.py
ADD coldfront_overrides/plugin_settings.py /usr/local/lib/python3.11/site-packages/coldfront/config/plugins/imperial.py
ADD coldfront_overrides/authorized_navbar.html /usr/local/lib/python3.11/site-packages/coldfront/templates/common/authorized_navbar.html

RUN mkdir /db && chown nobody:nogroup /db
VOLUME /db
VOLUME /srv/coldcront/static

# imperial specific settings
ADD local_settings.py /etc/coldfront/local_settings.py
USER nobody
