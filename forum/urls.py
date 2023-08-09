from django.urls import path
from rest_framework.routers import DefaultRouter

from forum import views


router = DefaultRouter()
router.register('topic', views.TopicViewSet, basename='topic')
router.register('post', views.PostViewSet, basename='post')

# topic/<topic_id>/post 이렇게 구성해야함.
