#!/bin/bash
set -e

sudo /usr/sbin/sshd
node /code/server.js
