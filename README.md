# README - ClubFare

This is an application designed to manage craft beer for a small bar.
It is specifically designed for the [*Ruakura Club*](http://ruakura-club.co.nz) in Hamilton, New Zealand.

* Ruby version

Ruby is 2.1.2

* System dependencies

We depend on Postgres

* Development instructions

An easy way to deploy a development version of Clubfare is with docker-compose, some quick docs:

1. Install [Docker](https://www.docker.com/) and [docker-compose](https://docs.docker.com/compose/install/).

2. Run `docker-compose up` which will boot up a development clubfare webserver with a postgres database instance.

3. Create the database by first launching bash in the docker `sudo docker-compose run web bash` and then run:

```
RAILS_ENV=development rake db:create
RAILS_ENV=development rake db:migrate
```

* Deployment instructions

1. Install [Docker](https://www.docker.com/).

2. Download [automated build](https://registry.hub.docker.com/u/gizmoguy/clubfare/) from public [Docker Hub Registry](https://registry.hub.docker.com/): `docker pull gizmoguy/clubfare`

3. Generate a SECRET_KEY_BASE with `rake secret` either inside Docker container or outside.

4. Run docker with environment variables to point it towards a real DB server:

```
#!/bin/bash

DATABASE_URL="postgres://clubfare:clubfare@172.17.42.1/clubfare"
SECRET_KEY_BASE="blah"

docker run -d --restart=always \
	-p 127.0.0.1:8081:80  \
	-e "DATABASE_URL=$DATABASE_URL" -e "SECRET_KEY_BASE=$SECRET_KEY_BASE" \
	--name clubfare gizmoguy/clubfare
```

## Contributors

* Greig McGill - Feb 2014
* Andrew Kampjes - [@akampjes](https://twitter.com/akampjes)
