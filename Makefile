default : check kitchen

check : rubocop foodcritic

travis : check
	kitchen verify

rubocop :
	rubocop .

foodcritic :
	foodcritic -P -f any .

kitchen :
	kitchen test

docker-clean :
	docker stop $(shell docker ps -a -q); docker rm $(shell docker ps -a -q); docker rmi $(shell docker images -q); rm -rf .kitchen/

.PHONY:
	travis test check rubocop foodcritic kitchen
