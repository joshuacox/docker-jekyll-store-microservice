#!/bin/bash

  # Check for a passed in DOCKER_UID environment variable. If it's there
  # then ensure that the sinatra user is set to this UID. That way we can
  # easily edit files from the host.
  if [ -n "$DOCKER_UID" ]; then
    printf "Updating UID...\n"
    # First see if it's already set.
    current_uid=$(getent passwd sinatra | cut -d: -f3)
    if [ "$current_uid" -eq "$DOCKER_UID" ]; then
      printf "UIDs already match.\n"
    else
      printf "Updating UID from %s to %s.\n" "$current_uid" "$DOCKER_UID"
      usermod -u "$DOCKER_UID" sinatra
    fi
  fi


echo -n "whoami? "
whoami
chown -R sinatra. /home/sinatra
chown -R sinatra. /srv/www
time sync

sudo -u sinatra /bin/bash -c "/srv/www/run.sh"
