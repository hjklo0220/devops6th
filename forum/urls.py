from django.urls import path
from rest_framework.routers import DefaultRouter

from forum import views


router = DefaultRouter()
router.register('topic', views.TopicViewSet, basename='topic')
