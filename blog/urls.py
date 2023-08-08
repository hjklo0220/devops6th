from django.urls import path
from rest_framework.routers import DefaultRouter

from blog import views


router = DefaultRouter()
router.register('', views.BlogViewSet, basename='blog')

