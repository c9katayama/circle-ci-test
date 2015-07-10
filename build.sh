#!/bin/sh
echo "TRAVIS_BRANCH=$TRAVIS_BRANCH"

case $TRAVIS_BRANCH in
    master)
        echo "buid and test start."
		AWS_ACCESS_KEY_ID=$STAGING_AWS_ACCESSKEY
		AWS_SECRET_ACCESS_KEY=$STAGING_AWS_SECRETKEY
        ./gradlew build
        exit 0
        ;;
    staging-deploy)
        echo "deploy to staging"
		AWS_ACCESS_KEY_ID=$STAGING_AWS_ACCESSKEY
		AWS_SECRET_ACCESS_KEY=$STAGING_AWS_SECRETKEY
         ./eb_deploy.sh -a CI -e ci-env-green -k $STAGING_KEYNAME	
        exit 0
        ;;
    prod-deploy)
        echo "deploy to PROD."
		AWS_ACCESS_KEY_ID=$PROD_AWS_ACCESSKEY
		AWS_SECRET_ACCESS_KEY=$PROD_AWS_SECRETKEY
         ./eb_deploy.sh -a CI -e ci-env-green -k $PROD_KEYNAME	
        exit 0
        ;;
    *)
        echo "canceled."
        exit 1
esac