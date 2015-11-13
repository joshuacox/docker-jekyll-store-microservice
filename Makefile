.PHONY: all help build run builddocker rundocker kill rm-image rm clean enter logs rend dev octo d preview pull devola

user = $(shell whoami)
ifeq ($(user),root)
$(error  "do not run as root! run 'gpasswd -a USER docker' on the user of your choice")
endif

all: help

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""  Add your jekyll site right here in the base of the gitrepo
	@echo ""  An example site is given to be replaced
	@echo ""   1. make preview       - will give you a preview

build: NAME TAG builddocker

dev: rm  build rundocker

run: dev

d: run

r: run

rundocker:
	$(eval TMP := $(shell mktemp -d --suffix=DOCKERTMP))
	$(eval NAME := $(shell cat NAME))
	$(eval TAG := $(shell cat TAG))
	$(eval UID := $(shell id -u))
	chmod 777 $(TMP)
	@docker run --name=$(NAME) \
	--cidfile="cid" \
	-d \
	-e "DOCKER_UID=$(UID)" \
	-p 3000:3000 \
	-p 3001:3001 \
	-v $(TMP):/tmp \
	-v ~/.bash_profile:/home/sinatra/.bash_profile \
	-v ~/.gitconfig:/home/sinatra/.gitconfig \
	-v ~/.ssh:/home/sinatra/.ssh \
	-v /var/run/docker.sock:/run/docker.sock \
	-v $(shell which docker):/bin/docker \
	-t $(TAG)

builddocker:
	$(eval TAG := $(shell cat TAG))
	/usr/bin/time -v docker build -t $(TAG) .

beep:
	@echo "beep"
	@aplay /usr/share/sounds/alsa/Front_Center.wav

kill:
	-@docker kill `cat cid`

rm-name:
	-rm  name

rm-image:
	-@docker rm `cat cid`
	-@rm cid

rm: kill rm-image

clean: rm

enter:
	docker exec -i -t `cat cid` /bin/bash

logs:
		docker logs -f `cat cid`

NAME:
	@while [ -z "$$NAME" ]; do \
		read -r -p "Enter the name you wish to associate with this container [NAME]: " NAME; echo "$$NAME">>NAME; cat NAME; \
	done ;

TAG:
	@while [ -z "$$TAG" ]; do \
		read -r -p "Enter the tag you wish to associate with this container [TAG]: " TAG; echo "$$TAG">>TAG; cat TAG; \
	done ;
