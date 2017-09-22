# docker-laravel-homestead
Docker image for Laravel Homestead https://github.com/laravel/homestead


#### Use with compose
It makes sense to run the image with docker-compose
```
docker-compose up -d
```
So, you can keep your project files, databases and configs permanently. Keep in mind if you change anything inside the image anywhere out of shared folders, next time you run the container you lose the changes.
Share files you want to edit with the host file system, see the `volumes:` section in `docker-compose.yml`.
By default in my example I have only main project files and nginx site configuration. You can add more site, configurations, databases etc.


I use a reverse proxy https://github.com/jwilder/nginx-proxy with my docker, so I can set any local host names, therefore docker-compose.yml contains extra networking.
You can use pure docker-compose-noproxy.yml and directly expose the homestead.
Note: Original Laravel's Homestead uses vagrant and virtual machines and forces you to create multiple projects in a single virtual machine instance, that makes sense as you don't want to waste system resources on more virtual machines.
Docker encourage you to run one app per container, I share this approach and the reverse proxy helps me to do so easily. If I need more apps, I'd rather run more containers (it's easier on system resources than running more virtual machines ), but you still can create more apps (nginx sites) inside one container, if you manually add more site to nginx conf (I'd share the whole `- ./shared/nginx/sites-enabled:/etc/nginx/sites-enabled` directory in the compose file)
@TODO: add example of multisite configuration


#### WIP (work in progress)
https://docs.docker.com/engine/examples/postgresql_service/

RUN Kitematic and Docker Quickstart Terminal as Administrator and symlinks will be OK


I'm trying to build a docker image as close as it possible to original Homestead vagrant image. I even use Ubuntu's upstart which is officially not supported by docker. Here is the dump
```
root@5957f82f7e59:/# service --status-all
[ - ]  apparmor
[ - ]  blackfire-agent
[ ? ]  console-setup
[ - ]  cron
[ - ]  dbus
[ ? ]  killprocs
[ ? ]  kmod
[ ? ]  mysql  (? but it's OK)
[ ? ]  networking
[ + ]  nginx
[ ? ]  ondemand
[ + ]  php7.0-fpm
[ - ]  procps
[ ? ]  rc.local
[ + ]  resolvconf
[ - ]  rsync
[ - ]  rsyslog
[ ? ]  sendsigs
[ - ]  sudo
[ - ]  supervisor
[ - ]  udev
[ ? ]  umountfs
[ ? ]  umountnfs.sh
[ ? ]  umountroot
[ - ]  unattended-upgrades
[ - ]  urandom
[ - ]  x11-common

```

Keeping usual homestead user and password  
user: `vagrant`  
password: `vagrant`  

Customization is another vital point here. Every time you upgrade your homestead base image, you lose every change you have made on your VM. It's very natural to do so, as you don't upgrade the base image frequently, treat your VM as stable environment, until one day... boom!
There is no way to keep the changes, unless you're willing to do some extra provisioning, which never worked for me as I expected. Docker solves this problem because of the containers disposable nature. You can build your custom images on top of this one and keep your changes over any upgrades. Just don't install anything inside a running container, always do it in the Dockerfile and you will keep everything every time you run it.

Installing new Laravel application could be a relatively long process. To speed things up I bundled default app in archive. On the first run Docker will extract the default app and regenerate the key, so you can run your first app in seconds.


**!!!important!!!**  
run with `-d` otherwise you'll hang your terminal

default app location  
`./shared/homestead.app/`  
`./shared/homestead.app/public/` - web  
if it isn't present, default Laravel app will be installed

Midnight Commander as a bonus
run  
`mc -a`
![MC](https://raw.githubusercontent.com/vitr/vitr.github.io/master/_drafts/mc.png)


based on
https://github.com/laravel/settler
The scripts that build the Laravel Homestead development environment.


similar projects:
* https://github.com/laraedit/laraedit-docker
* https://github.com/shincoder/homestead-docker
* https://github.com/LaraDock/laradock - the right docker way with compose

I like currently available projects, they are a great source for inspiration.
They use mixed approaches with docker images and compose, some of them implement some homestead features, but not all of them.
I'm trying to build an exact copy of Laravel Homestead in one monstrous docker image, which is not the canonical docker way of doing things, but it's a quick hack to get you started with Laravel.

If you're looking for a better docker solution, I have another project
LaraWhale https://github.com/vitr/larawhale. It's more like Lego blocks to build you custom environment picking a webserver, database, queue, etc.
With LaraWhale you could build something very similar to Homestead, but I couldn't say it would be exact copy of Homestead.

### Roadmap
- [ ] install Laravel by default
- [ ] run acceptance tests
- [ ] mysql
- [ ] postgresql https://docs.docker.com/engine/examples/postgresql_service/
- [ ] add yaml config similar to Homestead.yaml
