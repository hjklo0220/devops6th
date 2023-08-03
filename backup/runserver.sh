#!/bin/bash

# git pull
echo "git pull"
git pull

# source
echo "venv activate"
source venv/bin/activate

# runserver
python3 manage.py runserver 0.0.0.0:8000

