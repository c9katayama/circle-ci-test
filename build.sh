#!/bin/sh

echo $PROD_AWS_ACCESSKEY
echo "TRAVIS_BRANCH=$TRAVIS_BRANCH"

APP="CI"
KEY_NAME=$PROD_KEYNAME
AWS_ACCESS_KEY_ID=$PROD_AWS_ACCESSKEY
AWS_SECRET_ACCESS_KEY=$PROD_AWS_SECRETKEY

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