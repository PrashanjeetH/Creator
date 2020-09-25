#!/bin/sh

helpFunction()
{
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
# echo "$parameterA"
# echo "$parameterB"
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
			python -m pip install --upgrade pip
		fi

else
	echo "Please Install python and set env variables for python and pip!"
fi

# Catching arguements
PROJECT_NAME=$parameterA
APP_NAME=$parameterB

# Initialise project
echo Creating project \"$PROJECT_NAME\"
django-admin startproject $PROJECT_NAME
echo Project \"$PROJECT_NAME\" Created...


#Change working directory to the Projects' root directory
cd $PROJECT_NAME

# Create app
python manage.py startapp $APP_NAME
# echo Django app \"$APP_NAME\" Created...
echo Django Web application \"$APP_NAME\" Created Successfully !

#Copy all the Static files and templates
echo "Copying all the required static files..."
cp -r ./../static ./${APP_NAME}
cp -r ./../templates ./${APP_NAME}

# Create requirements
echo""
echo "Creating requirements.txt ..."
touch requirements.txt
echo "django >= 2.1.6, < 3.0" >> requirements.txt


#create views
cd $APP_NAME
echo "Creating views..."
echo "
# Definition of views.

from datetime import datetime
from django.shortcuts import render
from django.http import HttpRequest

def home(request):
    # Renders the home page.
    assert isinstance(request, HttpRequest)
    return render(
        request,
        'app/index.html',
        {
            'title':'Home Page',
            'year':datetime.now().year,
        }
    )

def contact(request):
    # Renders the contact page.
    assert isinstance(request, HttpRequest)
    return render(
        request,
        'app/contact.html',
        {
            'title':'Contact',
            'message':'Your contact page.',
            'year':datetime.now().year,
        }
    )

def about(request):
    # Renders the about page.
    assert isinstance(request, HttpRequest)
    return render(
        request,
        'app/about.html',
        {
            'title':'About',
            'message':'Your application description page.',
            'year':datetime.now().year,
        }
    )
" > views.py

# Create user login form
touch forms.py
echo "Creating forms..."
echo "
# Definition of forms.

from django import forms
from django.contrib.auth.forms import AuthenticationForm
from django.utils.translation import ugettext_lazy as _

class BootstrapAuthenticationForm(AuthenticationForm):
    # Authentication form which uses boostrap CSS.
    username = forms.CharField(max_length=254,
                               widget=forms.TextInput({
                                   'class': 'form-control',
                                   'placeholder': 'User name'}))
    password = forms.CharField(label=_('Password'),
                               widget=forms.PasswordInput({
                                   'class': 'form-control',
                                   'placeholder':'Password'}))
" > forms.py

# Creating URLS
touch urls.py
echo "Creating urls..."

echo "
from datetime import datetime
from django.urls import path
from django.contrib import admin
from django.contrib.auth.views import LoginView, LogoutView
from . import forms, views

urlpatterns = [
    path('', views.home, name='home'),
    path('contact/', views.contact, name='contact'),
    path('about/', views.about, name='about'),
    path('login/',
         LoginView.as_view
         (
             template_name='app/login.html',
             authentication_form=forms.BootstrapAuthenticationForm,
             extra_context=
             {
                 'title': 'Log in',
                 'year' : datetime.now().year,
             }
         ),
         name='login'),
    path('logout/', LogoutView.as_view(next_page='/'), name='logout'),
]" > urls.py

cd ../$PROJECT_NAME

# Setting up the required configurations
echo "Configuring $PROJECT_NAME ..."
sed "/'django.contrib.staticfiles',/a""'$APP_NAME'," settings.py > temp
mv temp settings.py
#1 temp

# Initialising app urls in project urls
echo "Configuring $APP_NAME ..."
echo "
from django.contrib import admin
from django.urls import include, path
urlpatterns = [ path('', include('"$APP_NAME.urls"')), path('admin/', admin.site.urls), ]" > urls.py



# Performing migrations
cd ./..
#python manage.py makemigrations
#python manage.py migrate
echo ""
echo "Project $PROJECT_NAME is ready for you to start working!"
echo "Utility developed by Prashanjeet (https://prashanjeet.com)"
echo "HAPPY CODING :)"
