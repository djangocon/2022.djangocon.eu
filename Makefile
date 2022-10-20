PROJECT_NAME=djangocon_2022
DEPLOY_SERVER=2022.djangocon.eu

## check form arm64 and apply override COMPOSE_FILE
## uname -m not used because we might be running a amd64 shell even in a arm-based mac
#UNAME=$(uname -v)
#ifneq (,$(findstring $(UNAME),ARM64))
#	COMPOSE_FILE=local.yml:local.arm.yml
#else
#	COMPOSE_FILE=local.yml
#endif
COMPOSE_FILE=local.yml

export COMPOSE_FILE

.PHONY: help up build down start stop prune clear ps restore_db shell manage
default: up

## help	:	Print commands help.
help : Makefile
	@sed -n 's/^##//p' $<

## up	:	Start up containers.
up:
	@echo "Starting up containers for for $(PROJECT_NAME)..."
	# docker-compose pull
	# docker-compose build
	docker-compose up -d --remove-orphans

## build	:	Build python image.
build:
	@echo "Building python image for for $(PROJECT_NAME) using $(COMPOSE_FILE)..."
	docker-compose build

## down	:	Stop containers.
down: stop

## start	:	Start containers without updating.
start:
	@echo "Starting containers for $(PROJECT_NAME) from where you left off..."
	docker-compose start

## stop	:	Stop containers.
stop:
	@echo "Stopping containers for $(PROJECT_NAME)..."
	docker-compose stop

## prune	:	Remove containers and their volumes.
##		You can optionally pass an argument with the service name to prune single container
##		prune postgres	: Prune `mariadb` container and remove its volumes.
##		prune postgres redis	: Prune `postgres` and `redis` containers and remove their volumes.
prune:
	@echo "Removing containers for $(PROJECT_NAME)..."
	docker-compose down -v $(filter-out rm,$(filter-out $@,$(MAKECMDGOALS)))

## clear       :	Remove images, containers and their volumes. Also prunes docker
##		Use with caution
clear: prune
	@echo "Removing images for $(PROJECT_NAME)..."
	$(eval IMAGES=$(shell docker images -f 'reference=$(PROJECT_NAME)*' -q))
	@if [ -n "$(IMAGES)" ]; then docker rmi $(IMAGES); docker image prune -af; docker builder prune -af; fi

## ps	:	List running containers.
ps:
	docker ps --filter name='$(PROJECT_NAME)*'

## backup_db	:	Restore database backup needs a database dump
##		Example: make backup_db
##		Use with caution, not enough tests made yet
backup_db:
	docker-compose exec postgres backup

## cp_backup	:	copy database backup
##		Example: make cp_backup xxx.sql.gz
##		Use with caution, not enough tests made yet
cp_backup:
	$(eval DB_IMAGE_ID=$(shell docker ps --filter name='$(PROJECT_NAME).*postgres' --format "{{.ID}}"))
	docker cp $(DB_IMAGE_ID):/backups/$(filter-out $@,$(MAKECMDGOALS)) .

## restore_db	:	Restore database backup needs a database dump
##		Example: make restore_db xxx.sql.gz
##		$(notdir ...) introduced to allow for backups in subdirectories
##		Use with caution, not enough tests made yet
restore_db:
	$(eval DB_IMAGE_ID=$(shell docker ps --filter name='$(PROJECT_NAME).*postgres' --format "{{.ID}}"))
	docker cp $(filter-out $@,$(MAKECMDGOALS)) $(DB_IMAGE_ID):/backups
	docker-compose exec postgres restore $(notdir $(filter-out $@,$(MAKECMDGOALS)))


## dbshell	:	Access `postgres` dbshell
##		uses exec
##		python manage.py dbshell does not use the correct psql version
##      psql 11(FROM python:3.8) and 12(FROM postgres:12) diverge quite a bit
dbshell:
	docker-compose exec postgres bash -c "psql -U \$$POSTGRES_USER"


## cp_db_production	 :	Get latest db production dump to backups folder
cp_db_production:
	mkdir -p backups
	rsync -azrP root@$(DEPLOY_SERVER):/var/lib/autopostgresqlbackup/latest/$(PROJECT_NAME)_* backups/


## restore_db_production  :  Restore latestes database backup from production
restore_db_production: cp_db_production
	$(MAKE) restore_db $(shell ls -t backups/*.sql.gz | head -1)

# This hack allows for exec when an existing container is found, instead of run --rm
CONTAINER=django
RUN=exec
ENTRYPOINT='/entrypoint'
EXEC=$(shell COMPOSE_FILE=$(COMPOSE_FILE) docker-compose $(RUN) $(CONTAINER) ls > /dev/null 2>&1; echo $$?)

ifeq ($(EXEC), 0)
	RUN=exec
	ENTRYPOINT='/entrypoint'
else
	RUN=run --rm
	ENTRYPOINT=
endif

## bash	:	Access container via shell.
##		You can optionally pass an argument with a service name to open a shell on the specified container
bash:
	docker-compose $(RUN) $(CONTAINER) $(ENTRYPOINT) bash $(filter-out $@,$(MAKECMDGOALS))

## shell	:	Access `django/python shell` container via shell.
##		You can optionally pass an argument with a service name to open a shell on the specified container
shell:
	docker-compose $(RUN) $(CONTAINER) $(ENTRYPOINT) python manage.py shell $(filter-out $@,$(MAKECMDGOALS))

## manage	:   django manage command
##		You can optionally pass an argument to manage
##		To use "--flag" arguments include them in quotation marks.
##		For example: make manage "makemessages --locale=pt"
manage:
	docker-compose $(RUN) $(CONTAINER) $(ENTRYPOINT) python manage.py $(filter-out $@,$(MAKECMDGOALS)) $(subst \,,$(MAKEFLAGS))

## makemigrate	:   call django manage commands 'makemigrations' and then 'migrate'
## 		It takes no arguments
makemigrate:
	docker-compose $(RUN) $(CONTAINER) $(ENTRYPOINT) python manage.py makemigrations
	docker-compose $(RUN) $(CONTAINER) $(ENTRYPOINT) python manage.py migrate

deploy:
	ssh django@$(DEPLOY_SERVER) " \
      cd /home/django/django \
      && source /home/django/.virtualenvs/django/bin/activate \
      && git pull \
      && git checkout main \
      && pip install -r requirements/production.txt \
      && python manage.py migrate \
      && python manage.py collectstatic --no-input \
      && sudo supervisorctl restart django \
      && exit"


# https://stackoverflow.com/a/6273809/1826109
%:
	@:
