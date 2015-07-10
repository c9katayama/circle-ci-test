while getopts a:e:r:k:p:s: OPT
do
  case $OPT in
    "a" ) EB_APP="$OPTARG";;
    "e" ) EB_ENV="$OPTARG";;
    "k" ) KEY_NAME="$OPTARG";;
    "r" ) REGION="$OPTARG";;
    "p" ) PLATFORM="$OPTARG";;
    "s" ) AWS_PROFILE"$OPTARG";;
     * ) echo "required:"
         echo " [-a EB_APP] [-e EB_ENV] [-k KEY_NAME]"
         echo "optional:"
         echo " [-r region(default 'ap-north-east-1')]"
         echo " [-p eb_platform(default '64bit Amazon Linux 2015.03 v1.4.1 running Docker 1.6.0')]"
         echo " [-s aws credential profile(default 'default')]"
         exit 1 ;;
  esac
done

if [ -z $EB_APP ]; then
  echo '-a EB_APP is not defined'
  exit 1
fi
if [ -z $EB_ENV ]; then
  echo '-e EB_ENV is not defined'
  exit 1
fi
if [ -z $KEY_NAME ]; then
  echo '-k KEY_NAME is not defined'
  exit 1
fi
if [ -z $REGION ]; then
	REGION="ap-northeast-1"
fi
if [ -z $PLATFORM ]; then
   PLATFORM="64bit Amazon Linux 2015.03 v1.4.1 running Docker 1.6.0"
fi
if [ -z $AWS_PROFILE ]; then
   AWS_PROFILE="default"
fi

EB_DIR="`pwd`/.elasticbeanstalk"
mkdir $EB_DIR 2>/dev/null

cat << EOF > $EB_DIR/config.yml
branch-defaults:
  default:
    environment: $EB_ENV
  master:
    environment: $EB_ENV
global:
  application_name: $EB_APP
  default_ec2_keyname: $KEY_NAME
  default_platform: $PLATFORM
  default_region: $REGION
  profile: $AWS_PROFILE
  sc: null
EOF
DATE=`env TZ=JST-9 date '+%Y%m%d-%H%M%S'`
COMMIT=`git log -n 1 --format=%H | cut -c 1-10`
LABEL="$DATE-$COMMIT"

eb init
eb use $EB_ENV
eb deploy --label $LABEL