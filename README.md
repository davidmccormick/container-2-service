# container-2-service
Very simple to make a systemd service in place of using docker run commands

e.g. running

`$ docker_service.sh alpine-mirror -v /home/mccormd/alpine-mirror:/var/www/localhost/htdocs/alpine -p 6000:80  davem/alpine-mirror`

The first argument need to be the name of the service, which will be the name of the systemd service and the name given to the docker container.
The rest of the arguments are passed onto the docker run command...

will create the following systemd service file /etc/systemd/system/alpine-mirror.service: -

~~~~
[Unit]
Description=Containerized Service alpine-mirror
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=/usr/bin/docker run -d --name alpine-mirror -v /home/mccormd/alpine-mirror:/var/www/localhost/htdocs/alpine -p 6000:80 davem/alpine-mirror
ExecStop=/usr/bin/docker stop -t 2 alpine-mirror
ExecStopPost=/usr/bin/docker rm -f alpine-mirror

[Install]
WantedBy=default.target
~~~~

Start the service with `systemctl start alpine-mirror`
Stop the service with `systemctl stop alpine-mirror`
Enable at boot with `systemctl enable alpine-mirror`

