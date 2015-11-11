#!/usr/bin/env bash

DATABASE=${DATABASE:-"hat20"}
DBUSER=${DBUSER:-$DATABASE}
DBPASS=${DBPASS:-"hat20"}
HAT_HOME=${HAT_HOME:-"$PWD/.."}
DOCKER_DEPLOY=$HAT_HOME/deployment/docker-deploy

echo "Creating $DOCKER_DEPLOY"
mkdir $DOCKER_DEPLOY
mkdir $DOCKER_DEPLOY/required

echo "Copying needed files"
cp $HAT_HOME/deployment/docker-deploy-db.sh $DOCKER_DEPLOY/
cp $HAT_HOME/src/main/resources/database.conf $DOCKER_DEPLOY/required
cp $HAT_HOME/deployment/database.conf.template $DOCKER_DEPLOY/required
cp $HAT_HOME/src/sql/* $DOCKER_DEPLOY/required

echo "Setting up HAT access"
HAT_OWNER='bob@gmail.com'
HAT_OWNER_ID=5974832d-2dc1-4f49-adf1-c6d8bc790274
HAT_OWNER_NAME='Bob'
HAT_OWNER_PASSWORD='pa55w0rd'
HAT_PLATFORM=${HAT_PLATFORM:-'hatdex.org'}
HAT_PLATFORM_ID=${HAT_PLATFORM_ID:-47dffdfd-55e8-4575-836c-151e30bb5a50}
HAT_PLATFORM_NAME=${HAT_PLATFORM_NAME:-'hatdex'}
HAT_PLATFORM_PASSWORD_HASH=${HAT_PLATFORM_PASSWORD_HASH:-'$2a$04$oL2CXTHzB..OekL1z8Vijus3RkHQjSsbkAYOiA5Rj.7.6GA7a4qAq'}

echo "Generating Dockerfile"
cat Dockerfile-hat-postgres | sed -e "s/RDATABASE/$DATABASE/g"\
	-e "s/RDBUSERR/$DBUSER/g"\
	-e "s/RDBPASSR/$DBPASS/g"\
	-e "s/RHAT_OWNERR/$HAT_OWNER/g"\
	-e "s/RHAT_OWNER_IDR/$HAT_OWNER_ID/g"\
	-e "s/RHAT_OWNER_NAMER/$HAT_OWNER_NAME/g"\
	-e "s/RHAT_OWNER_PASSWORDR/$HAT_OWNER_PASSWORD/g"\
	-e "s/RHAT_PLATFORMR/$HAT_PLATFORM/g"\
	-e "s/RHAT_PLATFORM_IDR/$HAT_PLATFORM_ID/g"\
	-e "s/RHAT_PLATFORM_NAMER/$HAT_PLATFORM_NAME/g"\
	-e "s/RHAT_PLATFORM_PASSWORD_HASHR/$HAT_PLATFORM_PASSWORD_HASH/g"\
	> $DOCKER_DEPLOY/Dockerfile

cd $DOCKER_DEPLOY

echo "Building db docker image: docker-hat-postgres"
docker build -t docker-hat-postgres .

echo "Creating docker-hat-postgres run script"
echo "docker run docker-hat-postgres" > $DOCKER_DEPLOY/run-db.sh
#sudo chmod +x run-db.sh

if [ ! -f "$HAT_HOME/target/docker/Dockerfile" ]; then
	#ls target/
    echo "Missing $HAT_HOME/target/docker/Dockerfile" 
    echo "The docker-hat container was not created."
    echo "Please run 'sbt docker:stage' on main folder and re-run this script to generate it."
    exit
fi

#cd $HAT_HOME
echo "Building hat docker image: docker-hat-postgres"
#sbt -sbt-dir $HAT_HOME docker:stage
cp -r $HAT_HOME/target/docker/stage/opt $DOCKER_DEPLOY/
mv $DOCKER_DEPLOY/Dockerfile $DOCKER_DEPLOY/Dockerfile-hat-postgres
cp $HAT_HOME/target/docker/stage/Dockerfile $DOCKER_DEPLOY/
docker build -t docker-hat .

cd $DOCKER_DEPLOY
echo "Creating docker-hat run script"
echo "docker run docker-hat" > $DOCKER_DEPLOY/run-hat.sh
#sudo chmod +x run-hat.sh
