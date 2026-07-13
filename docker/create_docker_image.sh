WEBCLIENT_TAG=$(echo "$1" | tr '/' '-')
if [ "$CI" = "true" ]; then
    echo "Running in GitHub Actions.."
else
    echo "Running Locally.."
    # echo "This script requires sudo access to install openjdk-21 & ant ."
    export docker_username="local"
    export docker_reponame="local"
fi

WEBCLIENT_REPO=$(pwd)/..

cd $WEBCLIENT_REPO

sed -i 's/services.i2b2.org/i2b2-core-server:8080/'   $WEBCLIENT_REPO/i2b2_config_domains.json
# sed -i 's/debug: false/debug: true/'  $BASE/i2b2-webclient/i2b2_config_domains.json

sed -i 's#127.0.0.1:8080/#i2b2-core-server:8080/#g'  $WEBCLIENT_REPO/proxy.php
sed -i 's#http://services.i2b2.org#http://i2b2-core-server:8080#g' $WEBCLIENT_REPO/proxy.php

docker build -t $docker_username/$docker_reponame:i2b2-webclient_$WEBCLIENT_TAG $WEBCLIENT_REPO/

if [ "$CI" = "true" ]; then
    docker push $docker_username/$docker_reponame:i2b2-webclient_$WEBCLIENT_TAG
fi

# docker buildx build --platform linux/amd64,linux/arm64 -t $docker_username/$docker_reponame:i2b2-webclient-$1-$date --push $BASE/

# docker buildx build --platform linux/amd64,linux/arm64 -t $docker_username/$docker_reponame:i2b2-webclient-master_build_platform --push $WEBCLIENT_REPO/docker


# docker tag local/i2b2-web:release-$TAG  ${{ secrets.DOCKER_REPO }}/new_repo:i2b2-web-release-$TAG
# docker images 

# docker push  ${{ secrets.DOCKER_REPO }}/new_repo:i2b2-web-release-$TAG

