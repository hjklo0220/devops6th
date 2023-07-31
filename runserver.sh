#!/bin/bash

APP_NAME=devops6th

# git pull
echo "git pull"
git pull

# source
echo "venv activate"
source venv/bin/activate

# runserver
python3 $APP_NAME/manage.py runserver 0.0.0.0:8000

