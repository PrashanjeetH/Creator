#!/bin/sh

helpFunction()
{
   echo ""
   echo "Usage: $0 -p project_name -a app_name"
   echo -e "\t-p Your django project name."
   echo -e "\t-a Your django app name."
   exit 1 # Exit script after printing help
}

while getopts "a:p:" opt
do
   case "$opt" in
      p ) parameterA="$OPTARG" ;;
      a ) parameterB="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$parameterA" ] || [ -z "$parameterB" ]
then

	helpFunction
fi

# Begin script in case all parameters are correct
echo "$parameterA"
echo "$parameterB"
echo "Hey there! I'll help you set up your Django project."
py_verion=`python --version`

if [ $? -eq 0  ]
then
	echo working environment \"$py_verion\"
	django_conf=`pip show django`

		if [ $? -eq 0 ]
		then
			echo Django Already Installed!
		else
			pip install django
		fi

else
	echo "Please Install python and set env variables for python and pip!"
fi

PROJECT_NAME=$parameterA
APP_NAME=$parameterB

echo Creating project \"$PROJECT_NAME\"
django-admin startproject $PROJECT_NAME
echo Project \"$PROJECT_NAME\" Created...
cd $PROJECT_NAME
python manage.py startapp $APP_NAME
echo app \"$APP_NAME\" Created Successfully !



#pip show django
echo DONE
