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

build: HOST DOMAIN  GMAIL GMAIL_PASS PAYMILL_KEY BRAINTREE_KEY NAME TAG jessie builddocker

dev: rm  build rundocker

run: dev

d: run

r: run

jessie:
	sudo bash my-jessie.sh

rundocker:
	$(eval TMP := $(shell mktemp -d --suffix=DOCKERTMP))
	$(eval NAME := $(shell cat NAME))
	$(eval DOMAIN := $(shell cat DOMAIN))
	$(eval HOST := $(shell cat HOST))
	$(eval TAG := $(shell cat TAG))
	$(eval UID := $(shell id -u))
	$(eval GMAIL := $(shell cat GMAIL))
	$(eval GMAIL_PASS := $(shell cat GMAIL_PASS))
	$(eval PAYMILL_KEY := $(shell cat PAYMILL_KEY))
	$(eval BRAINTREE_KEY := $(shell cat BRAINTREE_KEY))

	chmod 777 $(TMP)
	@docker run --name=$(NAME) \
	--cidfile="cid" \
	-d \
	-e "DOCKER_UID=$(UID)" \
	-e "JSM_FRONT_URL=$(HOST)" \
	-e 'JSM_PURCHASES_EMAIL=$(GMAIL)' \
	-e 'JSM_ERRORS_EMAIL=$(GMAIL)' \
	-e "JSM_PAYMENT_METHOD=paymill" \
	-e "JSM_SMTP_ADDRESS=smtp.gmail.com" \
	-e "JSM_SMTP_DOMAIN=$(DOMAIN)" \
	-e "JSM_SMTP_HOST=$(HOST)" \
	-e "JSM_SMTP_PORT=587" \
	-e 'JSM_SMTP_USER=$(GMAIL)' \
	-e "JSM_SMTP_PASS=$(GMAIL_PASS)" \
	-e "JSM_SMTP_AUTH=plain" \
	-e "JSM_SMTP_START_TLS_AUTO=True" \
	-e "JSM_PAYMILL_PRIVATE_KEY=replaceme" \
	-v $(TMP):/tmp \
	-P \
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

HOST:
	@while [ -z "$$HOST" ]; do \
		read -r -p "Enter the name you wish to associate with this container [HOST]: " HOST; echo "$$HOST">>HOST; cat HOST; \
	done ;

DOMAIN:
	@while [ -z "$$DOMAIN" ]; do \
		read -r -p "Enter the name you wish to associate with this container [DOMAIN]: " DOMAIN; echo "$$DOMAIN">>DOMAIN; cat DOMAIN; \
	done ;

BRAINTREE_KEY:
	@while [ -z "$$BRAINTREE_KEY" ]; do \
		read -r -p "Enter the name you wish to associate with this container [BRAINTREE_KEY]: " BRAINTREE_KEY; echo "$$BRAINTREE_KEY">>BRAINTREE_KEY; cat BRAINTREE_KEY; \
	done ;

PAYMILL_KEY:
	@while [ -z "$$PAYMILL_KEY" ]; do \
		read -r -p "Enter the name you wish to associate with this container [PAYMILL_KEY]: " PAYMILL_KEY; echo "$$PAYMILL_KEY">>PAYMILL_KEY; cat PAYMILL_KEY; \
	done ;

GMAIL:
	@while [ -z "$$GMAIL" ]; do \
		read -r -p "Enter the name you wish to associate with this container [GMAIL]: " GMAIL; echo "$$GMAIL">>GMAIL; cat GMAIL; \
	done ;

GMAIL_PASS:
	@while [ -z "$$GMAIL_PASS" ]; do \
		read -r -p "Enter the name you wish to associate with this container [GMAIL_PASS]: " GMAIL_PASS; echo "$$GMAIL_PASS">>GMAIL_PASS; cat GMAIL_PASS; \
	done ;

