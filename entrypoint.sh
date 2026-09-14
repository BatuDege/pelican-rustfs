#!/bin/sh
set -eu

cd /home/container

exec /usr/bin/rustfs /home/container/data
