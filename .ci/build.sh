#!/bin/sh
set -ex

#mkdir -p ~/.docker/; echo $DOCKER_AUTH_CONFIG >~/.docker/config.json
export REGISTRY=docker.io
export IMAGE_REPO=rawfile-localpv
export IMAGE="$REGISTRY/$IMAGE_REPO"
export COMMIT=${TRAVIS_COMMIT}

docker build \
  -t $IMAGE:$COMMIT \
  --build-arg IMAGE_REPOSITORY=$IMAGE \
  --build-arg IMAGE_TAG=$COMMIT \
  .
docker push $IMAGE:$COMMIT

