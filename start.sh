#!/usr/bin/env bash


DIRECTORY="/home/vagrant/apps/homestead.dev"

if [ ! -d "$DIRECTORY" ]; then
  /bin/echo 'Creating default app...'
  # sudo su - vagrant -c 'script -c "laravel new apps/homestead.dev"'
  #sudo su - vagrant -c 'mkdir /home/vagrant/apps'
  # sudo su - vagrant -c 'cp -rf /home/vagrant/default-app /home/vagrant/apps/homestead.dev'
  cp -rf /home/vagrant/default-app /home/vagrant/apps/homestead.dev
  chown -Rf vagrant.vagrant /home/vagrant/apps/homestead.dev
  su - vagrant -c 'cd /home/vagrant/apps/homestead.dev; php artisan key:generate'
  /bin/echo 'Running database migrations...'
  su - vagrant -c 'cd /home/vagrant/apps/homestead.dev; php artisan migrate'
  /bin/echo 'Linking The Storage Directory...'
  su - vagrant -c 'ln -s /home/vagrant/apps/homestead.dev/storage/app/public /home/vagrant/apps/homestead.dev/public/storage'
  /bin/echo 'Default app successfully created!'
fi

service nginx restart
service php7.0-fpm restart
#service mysql restart

/bin/echo 'Homestead running...yes!'

tail -f /dev/null
# /usr/bin/supervisord
