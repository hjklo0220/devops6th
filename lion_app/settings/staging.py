import os

from .base import *

SECRET_KEY = os.getenv("DJANGO_SECRET_KEY")

DEBUG = True

ALLOWED_HOSTS = [
    "default-lion-app-lb-bdc1d-19455954-976c14ee0e44.kr.lb.naverncp.com",
    "*",
]

# CSRF_TRUSTED_ORIGINS = [
#     "http://lion-lb-staging-18975817-1caa10020eef.kr.lb.naverncp.com",
# ]
