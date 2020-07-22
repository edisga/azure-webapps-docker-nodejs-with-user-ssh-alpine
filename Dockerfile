FROM node:12.18.2-alpine3.9
WORKDIR /code
ADD package.json /code/
RUN npm install
ADD . /code/

COPY entrypoint.sh /bin/
COPY sshd_config /etc/ssh/

RUN apk update \
    && apk upgrade \
    && echo "root:Docker!" | chpasswd \
    && apk add --update --no-cache openrc openssh bash sudo \
    && rc-update add sshd \
    && chmod 755 /bin/entrypoint.sh \
    && /usr/bin/ssh-keygen -A

ARG USER=demo
ARG GROUP=demo

RUN addgroup -g 1001 $GROUP && adduser -u 1001 -G $GROUP -h /home/$USER -D $USER \
         && echo "%$GROUP ALL=(ALL:ALL) NOPASSWD: /usr/sbin/sshd" > /etc/sudoers.d/$GROUP

USER $USER
EXPOSE 3000 2222
ENTRYPOINT ["/bin/entrypoint.sh"]