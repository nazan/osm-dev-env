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

.PHONY: osmact-bash
osmact-bash:
	docker-compose exec osm-account bash

.PHONY: osmfil-bash
osmfil-bash:
	docker-compose exec osm-files bash

.PHONY: osmloc-bash
osmloc-bash:
	docker-compose exec osm-locker bash

.PHONY: osmui-serve
osmui-serve:
	docker-compose exec osm-ui npx webpack serve

.PHONY: osmui-bash
osmui-bash:
	docker-compose exec osm-ui bash






# Bring up/down services.

.PHONY: up
up: touch-all
	docker-compose up -d osm-files-nginx osm-locker-nginx redis-commander

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

.PHONY: osmact-prepare
osmact-prepare: osmact-touch
	docker-compose exec --user root:root osm-account /usr/src/aidock/build/prepare-super.sh
	docker-compose exec osm-account /usr/src/aidock/build/prepare.sh

.PHONY: osmfil-prepare
osmfil-prepare: osmfil-touch
	docker-compose exec --user root:root osm-files /usr/src/aidock/build/prepare-super.sh
	docker-compose exec osm-files /usr/src/aidock/build/prepare.sh

.PHONY: osmloc-prepare
osmloc-prepare: osmloc-touch
	docker-compose exec --user root:root osm-locker /usr/src/aidock/build/prepare-super.sh
	docker-compose exec osm-locker /usr/src/aidock/build/prepare.sh


.PHONY: prepare-all
prepare-all: osmdir-prepare osmact-prepare osmfil-prepare osmloc-prepare
	@echo "Post setup done for all application components."




.PHONY: checkout-masters
checkout-masters:
	git -C ./osm-directory checkout main
	git -C ./osm-auth checkout main
	git -C ./osm-account checkout dev
	git -C ./osm-files checkout main
	git -C ./osm-locker checkout main
	git -C ./osm-ui checkout main


.PHONY: osmdir-bootstrap
osmdir-bootstrap: osmdir-touch
	@echo "OSM Directory bootstrap complete."

.PHONY: osmauth-bootstrap
osmauth-bootstrap: osmauth-touch
	@echo "OSM Auth bootstrap complete."

.PHONY: osmact-bootstrap
osmact-bootstrap: osmact-touch
	@echo "OSM Account bootstrap complete."

.PHONY: osmfil-bootstrap
osmfil-bootstrap: osmfil-touch
	@echo "OSM Files bootstrap complete."

.PHONY: osmloc-bootstrap
osmloc-bootstrap: osmloc-touch
	@echo "OSM Locker bootstrap complete."


.PHONY: first-time
first-time: checkout-masters touch-all osmdir-bootstrap osmact-bootstrap osmfil-bootstrap osmloc-bootstrap
	@echo "First time routine complete."




.PHONY: purge-all
purge-all:
	docker-compose exec osm-directory /usr/src/aidock/build/purge.sh
	docker-compose exec osm-auth /usr/src/aidock/build/purge.sh
	docker-compose exec osm-account /usr/src/aidock/build/purge.sh
	docker-compose exec osm-files /usr/src/aidock/build/purge.sh
	docker-compose exec osm-locker /usr/src/aidock/build/purge.sh


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

.PHONY: osmact-touch
osmact-touch:
	cp -n ./osm-account/.env.example ./osm-account/.env
	touch ./osm-account/storage/logs/laravel.log
	
	cp -n ./osm-account-dc/.env.example ./osm-account-dc/.env
	mkdir -p ./osm-account-dc/.npm
	mkdir -p ./osm-account-dc/.npm-appuser
	mkdir -p ./osm-account-dc/log
	touch ./osm-account-dc/log/php-error.log
	touch ./osm-account-dc/log/nginx-error.log
	touch ./osm-account-dc/log/nginx-access.log

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

.PHONY: osmloc-touch
osmloc-touch:
	cp -n ./osm-locker/.env.example ./osm-locker/.env
	touch ./osm-locker/storage/logs/laravel.log
	
	cp -n ./osm-locker-dc/.env.example ./osm-locker-dc/.env
	mkdir -p ./osm-locker-dc/.npm
	mkdir -p ./osm-locker-dc/.npm-appuser
	mkdir -p ./osm-locker-dc/log
	touch ./osm-locker-dc/log/php-error.log
	touch ./osm-locker-dc/log/nginx-error.log
	touch ./osm-locker-dc/log/nginx-access.log

.PHONY: osmui-touch
osmui-touch:
	mkdir -p ./app/dist


.PHONY: touch-all
touch-all: osmdir-touch osmauth-touch osmact-touch osmfil-touch osmloc-touch osmui-touch
	cp -n ./.env.example ./.env
	@echo "Required files in host machine generated."