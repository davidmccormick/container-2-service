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
Restart=always
ExecStart=/usr/bin/docker run -d --name ${SERVICENAME} $*
ExecStop=/usr/bin/docker stop -t 2 ${SERVICENAME}
ExecStopPost=/usr/bin/docker rm -f ${SERVICENAME}

[Install]
WantedBy=default.target
EOT

systemctl daemon-reload

