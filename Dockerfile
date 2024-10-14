FROM python:3.11-slim

ADD coldfront /usr/src/coldfront
ADD imperial_coldfront_plugin /usr/src/imperial_coldfront_plugin
ADD requirements.txt /usr/src/requirements.txt
WORKDIR /usr/src/
RUN pip install -r requirements.txt
RUN mkdir /etc/coldfront

RUN mkdir /db && chown nobody:nogroup /db
VOLUME /db
VOLUME /srv/coldcront/static
ADD local_settings.py /etc/coldfront/local_settings.py
ADD . /usr/src/app/
USER nobody
