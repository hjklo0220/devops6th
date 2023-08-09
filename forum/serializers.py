from rest_framework import serializers

from .models import Topic, Post


class TopicSerializer(serializers.ModelSerializer):
    class Meta:
        model = Topic
        fields = "__all__" # 모델 필드 전부다 쓰겟다
        read_only_field = (
            "id",
            "created_at",
            "updated_at",
        )

class PostSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        fields = "__all__"
        read_only_field = (
            "id",
            "created_at",
            "updated_at",
        )

