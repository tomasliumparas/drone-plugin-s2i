#!/bin/sh

[ "$PLUGIN_BUILDER" == "" ] && echo "You must set BUILDER paramter in settings" && exit 1
[ "$PLUGIN_TARGET" == "" ] && echo "You must set image target in settings" && exit 1

# if [ $PLUGIN_CERT != "" ]; then
#     mkdir -p /etc/docker/certs.d/$PLUGIN_REGISTRY
#     echo "$PLUGIN_CERT" | base64 -d > /etc/docker/certs.d/$PLUGIN_REGISTRY/ca.crt
#
# fi
#
# if not target given, use "latest" tag per default
[ "$PLUGIN_TARGET" == "" ] && PLUGIN_TARGET="latest"
#
# OPTS=""
# if [ "$PLUGIN_INSECURE" == "true" ] && [ "$PLUGIN_REGISTRY" != "" ]; then
#     OPTS=' --insecure-registry='$PLUGIN_REGISTRY
# fi
#
# # build s2i options
# S2IOPTS=""
# if [ "$PLUGIN_INCREMENTAL" == "true" ]; then
#     S2IOPTS="--incremental"
# fi


# Launching Docker
dockerd-entrypoint.sh >/dev/null 2>&1 &

# Wait for docker daemon
until docker info > /dev/null 2>&1; do echo "---> Waiting for dockerd"; sleep 1; done

docker info

echo
echo "---> Dockerd is ready, building..."

# try to login if needed
if [ "${PLUGIN_USERNAME}" != "" ] && [ "${PLUGIN_PASSWORD}" != "" ]; then
    echo "---> Loging into registry..."
    docker login $PLUGIN_REGISTRY --username "$PLUGIN_USERNAME" --password "$PLUGIN_PASSWORD"
fi

# build DRONE env
echo "---> Building..."
set -x
s2i build ${DRONE_WORKSPACE_BASE} $S2IOPTS --context-dir=${PLUGIN_CONTEXT-./} ${PLUGIN_BUILDER} ${PLUGIN_TARGET} --env=DRONE=true || exit 1

# push tag if wanted
if [ "$PLUGIN_PUSH" == "true" ]; then
    echo "---> Pushing $PLUGIN_TARGET"

    for tag in ${PLUGIN_TAGS//,/" "}; do
        docker tag ${PLUGIN_TARGET} ${PLUGIN_REGISTRY}/$PLUGIN_TARGET:${tag}
        docker push ${PLUGIN_REGISTRY}/${PLUGIN_TARGET}:${tag} || exit 1
    done
    echo "---> Pushed"
fi

set -x
docker system prune -f || :

exit 0
