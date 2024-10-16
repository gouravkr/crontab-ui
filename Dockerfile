# docker run -d -p 8000:8000 alseambusher/crontab-ui
FROM alpine:3.20.3

ENV   CRON_PATH /etc/crontabs

RUN   mkdir /crontab-ui; touch $CRON_PATH/root; chmod +x $CRON_PATH/root

RUN   apk --no-cache add \
      python3 \
      py3-pip \
      build-base

RUN python3 -m venv /opt/venv
RUN /opt/venv/bin/pip install --no-cache pandas psycopg2-binary sqlalchemy requests python-dotenv

ENV PATH="/opt/venv/bin:$PATH"
ENV LOG_PATH="/crontab-ui/crontabs/logs"

WORKDIR /crontab-ui

LABEL maintainer "@alseambusher"
LABEL description "Crontab-UI docker"

RUN   apk --no-cache add \
      wget \
      curl \
      nodejs \
      npm \
      supervisor \
      tzdata


COPY supervisord.conf /etc/supervisord.conf
COPY . /crontab-ui

RUN   npm install

ENV   HOST 0.0.0.0

ENV   PORT 8000

ENV   CRON_IN_DOCKER true

EXPOSE $PORT

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
