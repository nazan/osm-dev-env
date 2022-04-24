FROM node:12.22.5-buster

ARG UID
ARG GID

#RUN npm install -g npm@7.0.9
#RUN npm install -g npm@next

USER root

RUN usermod -u $UID node
RUN groupmod -g $GID node

RUN find / -path /proc -prune -o -type d -group 1000 | xargs chgrp -h node
RUN find / -path /proc -prune -o -type d -user 1000 | xargs chown -h node

COPY endless.sh /usr/local/bin/endless.sh

USER node:node

#RUN if grep -q "^appuser" /etc/group; then echo "Group already exists."; else groupadd -g $GID appuser; fi
#RUN useradd -m -r -u $UID -g appuser appuser

RUN mkdir -p /home/node/app

WORKDIR /home/node/app

USER node:node