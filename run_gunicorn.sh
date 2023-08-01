#!/bin/bash

# 실행 경로 진입
cd /home/lion/devops6th

#gunicorn 실행
gunicorn lion_app.wsgi:application --config lion_app/gunicorn_config.py 
