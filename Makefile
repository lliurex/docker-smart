VERSION := lliurex
TAGVERSION := 3.0
TAG := $(subst __COLON__,:,$(VERSION)__COLON__$(TAGVERSION))
VIDEO_OPTS := $(subst __COLON__,:,-v /tmp/.X11-unix__COLON__/tmp/.X11-unix -e DISPLAY="__COLON__0" --device /dev/dri/card0)
#VIDEO_OPTS := $(subst __COLON__,:,-v /tmp/.X11-unix__COLON__/tmp/.X11-unix -e DISPLAY="__COLON__0")
#RUNOPTS := --rm -ti --privileged
RUNOPTS := --rm --privileged -d
#REPO := $(subst __COLON__,:,http__COLON__//172.20.8.6/llx16-debmirror)

IMAGE_LIST := $(shell docker images -q)
CONTAINER_LIST := $(shell docker ps -a -q)

.PHONY: clean_images clean_containers clean clean-all
.DEFAULT_GOAL: run

.build : 
	@echo Building
ifneq ($(strip $(REPO)),)
	docker build --rm=false --tag $(TAG) --build-arg REPO=$(REPO) -f Dockerfile .
else
	docker build --rm=false --tag $(TAG) -f Dockerfile . 
endif
	touch .build

run : .build
	@echo Running
	docker run $(RUNOPTS) $(VIDEO_OPTS) $(TAG)
	touch .run

clean_images :
	@echo Cleaning images
	rm -f .build
ifneq ($(strip $(IMAGE_LIST)),)
	docker rmi -f $(IMAGE_LIST) > /dev/null 2>&1
endif

clean_containers :
	@echo Cleaning containers
	rm -f .run
ifneq ($(strip $(CONTAINER_LIST)),)
	docker rm -f $(CONTAINER_LIST) > /dev/null 2>&1
endif

clean : clean_containers
clean-all: clean_containers clean_images