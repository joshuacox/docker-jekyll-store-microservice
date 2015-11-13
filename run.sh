#!/bin/bash
source /home/yeoman/.rvm/scripts/rvm

cd /srv/www/app
git pull
cd /srv/www

# echo "debug hang"
# sleep 600

echo -n "whoami? "
whoami

grunt serve
