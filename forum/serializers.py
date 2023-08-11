from rest_framework import serializers

from .models import Topic, Post


class PostSerializer(serializers.ModelSerializer):
    class Meta:
        model = Post
        fields = "__all__"
        read_only_field = (
            "id",
            "created_at",
            "updated_at",
        )


class TopicSerializer(serializers.ModelSerializer):
    class Meta:
        model = Topic
        fields = (
            "id",
            "name",
            "is_private",
            "owner",
            "created_at",
            "updated_at",
            "post_topic",
        )
        read_only_field = (
            "id",
            "created_at",
            "updated_at",
        )

    post_topic = serializers.SerializerMethodField()

    def get_posts(self, obj: Topic):
        post_topic = obj.post_topic.all()
        return PostSerializer(post_topic, many=True).data
        # return Post.objects.filter(topic=obj)



