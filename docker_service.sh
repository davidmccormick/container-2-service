#!/bin/bash

# Simple script to allow us to schedule docker containers with systemd

# e.g. docker_run_systemd service_name -v /var/cache -p etc...
# Must be run as root

if [[ "$(id -u)" != "0" ]]; then
  echo "Sorry, $(basename $0) must be run as root."
  exit 1
fi

SERVICENAME=$1
shift

cat >/etc/systemd/system/${SERVICENAME}.service <<EOT
[Unit]
Description=Containerized Service ${SERVICENAME}
Requires=docker.service
After=docker.service

[Service]
Type=simple
Restart=always
TimeoutStartSec=300
ExecStartPre=-/usr/bin/docker stop ${SERVICENAME}
ExecStartPre=-/usr/bin/docker rm ${SERVICENAME}
ExecStart=/usr/bin/docker run --rm --net="host" --name ${SERVICENAME} $*
ExecStop=-/usr/bin/docker stop -t 2 ${SERVICENAME}

[Install]
WantedBy=multi-user.target
EOT

systemctl daemon-reload

