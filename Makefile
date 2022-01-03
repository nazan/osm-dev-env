DOCKER_REGISTRY ?= dkrhub.coloranomaly.xyz

MY_UID = $$(id -u)
MY_GID = $$(id -g)

THIS_FILE := $(lastword $(MAKEFILE_LIST))


.PHONY: host-user
host-user:
	@echo "HOST USER UID: $(MY_UID)"
	@echo "HOST USER GID: $(MY_GID)"

# Shell access to app container.

.PHONY: osmdir-bash
osmdir-bash:
	docker-compose exec osm-directory bash

.PHONY: osmauth-bash
osmauth-bash:
	docker-compose exec osm-auth bash

.PHONY: osmfil-bash
osmfil-bash:
	docker-compose exec osm-files bash






# Bring up/down services.

.PHONY: up
up: touch-all
	docker-compose up -d osm-files-nginx

.PHONY: down
down:
	docker-compose down






# Container preparation routines.

.PHONY: osmdir-prepare
osmdir-prepare: osmdir-touch
	docker-compose exec --user root:root osm-directory /usr/src/aidock/build/prepare-super.sh
	docker-compose exec osm-directory /usr/src/aidock/build/prepare.sh


.PHONY: osmauth-prepare
osmauth-prepare: osmauth-touch
	docker-compose exec --user root:root osm-auth /usr/src/aidock/build/prepare-super.sh
	docker-compose exec osm-auth /usr/src/aidock/build/prepare.sh

.PHONY: osmfil-prepare
osmfil-prepare: osmfil-touch
	docker-compose exec --user root:root osm-files /usr/src/aidock/build/prepare-super.sh
	docker-compose exec osm-files /usr/src/aidock/build/prepare.sh


.PHONY: prepare-all
prepare-all: osmdir-prepare osmauth-prepare osmfil-prepare
	@echo "Post setup done for all application components."




.PHONY: checkout-masters
checkout-masters:
	git -C ./osm-directory checkout main
	git -C ./osm-auth checkout main
	git -C ./osm-files checkout main


.PHONY: osmdir-bootstrap
osmdir-bootstrap: osmdir-touch
	@echo "OSM Directory bootstrap complete."

.PHONY: osmauth-bootstrap
osmauth-bootstrap: osmauth-touch
	@echo "OSM Auth bootstrap complete."

.PHONY: osmfil-bootstrap
osmfil-bootstrap: osmfil-touch
	@echo "OSM Files bootstrap complete."


.PHONY: first-time
first-time: checkout-masters touch-all osmdir-bootstrap osmauth-bootstrap osmfil-bootstrap
	@echo "First time routine complete."




.PHONY: purge-all
purge-all:
	docker-compose exec osm-directory /usr/src/aidock/build/purge.sh
	docker-compose exec osm-auth /usr/src/aidock/build/purge.sh
	docker-compose exec osm-files /usr/src/aidock/build/purge.sh


# Create required directories and files in host machine.

.PHONY: osmdir-touch
osmdir-touch:
	cp -n ./osm-directory/.env.example ./osm-directory/.env
	touch ./osm-directory/storage/logs/laravel.log
	
	cp -n ./osm-directory-dc/.env.example ./osm-directory-dc/.env
	mkdir -p ./osm-directory-dc/.npm
	mkdir -p ./osm-directory-dc/.npm-appuser
	mkdir -p ./osm-directory-dc/log
	touch ./osm-directory-dc/log/php-error.log
	touch ./osm-directory-dc/log/nginx-error.log
	touch ./osm-directory-dc/log/nginx-access.log


.PHONY: osmauth-touch
osmauth-touch:
	cp -n ./osm-auth/.env.example ./osm-auth/.env
	touch ./osm-auth/storage/logs/laravel.log
	
	cp -n ./osm-auth-dc/.env.example ./osm-auth-dc/.env
	mkdir -p ./osm-auth-dc/.npm
	mkdir -p ./osm-auth-dc/.npm-appuser
	mkdir -p ./osm-auth-dc/log
	touch ./osm-auth-dc/log/php-error.log
	touch ./osm-auth-dc/log/nginx-error.log
	touch ./osm-auth-dc/log/nginx-access.log

.PHONY: osmfil-touch
osmfil-touch:
	cp -n ./osm-files/.env.example ./osm-files/.env
	touch ./osm-files/storage/logs/laravel.log
	
	cp -n ./osm-files-dc/.env.example ./osm-files-dc/.env
	mkdir -p ./osm-files-dc/.npm
	mkdir -p ./osm-files-dc/.npm-appuser
	mkdir -p ./osm-files-dc/log
	touch ./osm-files-dc/log/php-error.log
	touch ./osm-files-dc/log/nginx-error.log
	touch ./osm-files-dc/log/nginx-access.log


.PHONY: touch-all
touch-all: osmdir-touch osmauth-touch osmfil-touch
	cp -n ./.env.example ./.env
	@echo "Required files in host machine generated."