#!/bin/sh

echo "TRAVIS_BRANCH=$TRAVIS_BRANCH"

eb_deploy(){
	echo $KEY_NAME
	
	mkdir target
	cd target
	mkdir .elasticbeanstalk
	cd .elasticbeanstalk
	
	cat << EOF > config.yml
	branch-defaults:
	  default:
	    environment: null
	global:
	  application_name: $APP
	  default_ec2_keyname: $KEY_NAME
	  default_platform: 64bit Amazon Linux 2015.03 v1.4.1 running Docker 1.6.0
	  default_region: ap-northeast-1
	  profile: null
	  sc: null
	EOF
	cd ..
	
	eb use ci-env-blue
	eb deploy
}
case $TRAVIS_BRANCH in
    master)
        echo "buid and test start."
		AWS_ACCESS_KEY_ID=$PROD_AWS_ACCESSKEY
		AWS_SECRET_ACCESS_KEY=$PROD_AWS_SECRETKEY
        ./gradlew build
        exit 0
        ;;
    staging-deploy)
        echo "deploy to staging"
		APP="CI"
		KEY_NAME=$PROD_KEYNAME
		AWS_ACCESS_KEY_ID=$STAGING_AWS_ACCESSKEY
		AWS_SECRET_ACCESS_KEY=$STAGING_AWS_SECRETKEY
		eb_deploy
        exit 0
        ;;
    prod-deploy)
        echo "deploy to PROD."
		APP="CI"
		KEY_NAME=$PROD_KEYNAME
		AWS_ACCESS_KEY_ID=$PROD_AWS_ACCESSKEY
		AWS_SECRET_ACCESS_KEY=$PROD_AWS_SECRETKEY
        eb_deploy
        exit 0
        ;;
    *)
        echo "canceled."
        exit 1
        ;;
esac