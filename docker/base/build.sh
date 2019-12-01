#!/bin/bash
#
# Build helper for building and pushing an image.
#

set -e

COMMIT="$1"
MAKE_LATEST="$2"
if [ -z $COMMIT ]; then
    echo "Usage: $0 <git_sha_to_build> [--make-latest]"
    exit 1
fi

# Build the image.
sudo docker build -t dreamwidth/base:$COMMIT --build-arg COMMIT=$COMMIT .

# Always push the versioned image.
sudo docker tag dreamwidth/base:$COMMIT 194396987458.dkr.ecr.us-east-1.amazonaws.com/dreamwidth/base:$COMMIT
sudo docker push 194396987458.dkr.ecr.us-east-1.amazonaws.com/dreamwidth/base:$COMMIT

# If it's latest, do that too.
if [ "$MAKE_LATEST" == "--make-latest" ]; then
    sudo docker tag dreamwidth/base:$COMMIT dreamwidth/base:latest
    sudo docker tag dreamwidth/base:$COMMIT 194396987458.dkr.ecr.us-east-1.amazonaws.com/dreamwidth/base:latest
    sudo docker push 194396987458.dkr.ecr.us-east-1.amazonaws.com/dreamwidth/base:latest
fi
