#!/bin/bash
source /home/sinatra/.rvm/scripts/rvm

cd /srv/www/app
git pull

# echo "debug hang"
# sleep 600

echo -n "whoami? "
whoami

echo envtest
printenv |grep JSM
echo envtest
ruby app.rb -o 0.0.0.0
