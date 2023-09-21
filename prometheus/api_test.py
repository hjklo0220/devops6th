import requests
from faker import Faker

r = requests.get("http://localhost:8000/health/")
print(r.json())


class APIHandler:
    urls = {
        "topic": "/forum/topic/",
        "post": "/forum/post/",
    }

    def __init__(self, model: str, host: str = "localhost"):
        self.model = model
        self.host = host

    def _get_url(self, detail=False, pk: int = None) -> str:
        root_url = f"{self.host}{self.urls.get(self.model)}"
        if detail:
            return f"{root_url}{pk}"
        return root_url

    def _generate_data(self, fk: int) -> dict:
        fake = Faker()
        if self.model == "post":
            data = {
                "topic": fk,
                "title": fake.text(max_nb_chars=20),
                "content": fake.text(max_nb_chars=100),
            }
        elif self.model == "topic":
            data = {
                "name": fake.text(max_nb_chars=10),
                "is_private": False,
                # "owner": fk, # request.user
            }
        else:
            raise Exception

        return data

    def _get_pk(self, model: str = None) -> int:
        lst = self.list(model)
        return lst[0].pk

    def create(self):
        if self.model == "topic":
            fk = self._get_pk("user")
        elif self.model == "post":
            fk = self._get_pk("topic")
        res = requests.post(self._get_url(), data=self._generate_data(fk))
        return res.json()

    def list(self, model: str = None):
        target_model = model or self.model
        if target_model == "topic":
            res = requests.get(self._get_url())
        elif target_model == "post":
            res = requests.get(self._get_url())
        else:
            raise Exception

        return res

    def update(self):
        pk = self._get_pk()
        fk = self._get_pk()
        requests.put(self._get_url(detail=True, pk=pk), data=self._generate_data(fk))

    def destroy(self):
        pk = self._get_pk()
        requests.delete(self._get_url(detail=True, pk=pk))

    def detail(self):
        pk = self._get_pk()
        requests.get(self._get_url(detail=True, pk=pk))


if __name__ == "__main__":
    topic_handler = APIHandler("topic")
    post_handler = APIHandler("post")

    topic_handler.create()
    post_handler.destroy()

# # model의 각 api를 호출하는 함수(topic, post, topicgroupuser)
# # list, create, detail, delete, put
# url = "http://localhost:8000/forum"
# fake = Faker()
# data = {"name": fake.name(), "is_private": True, "owner": 1}
# print(data)

# # topic api test
# test_get = requests.get(f"{url}/topic/")
# test_post = requests.post(f"{url}/topic/", json=data)

# topic_num = 1  # test_post.json()["id"]

# test_get_detail = requests.get(f"{url}/topic/{topic_num}/")
# test_put = requests.put(f"{url}/topic/{topic_num}/", json={"name": "test_put"})
# test_delete = requests.delete(f"{url}/topic/{topic_num}/")
# test_topic_post = requests.get(f"{url}/topic/{topic_num}/posts/")


# # post api test
# data = {"topic": topic_num, "title": fake.name(), "content": fake.text()}

# post_get = requests.get(f"{url}/post/")
# post_post = requests.post(f"{url}post/", json=data)

# post_num = 1  # post_post.json()["id"]

# post_get_detail = requests.get(f"{url}post/{post_num}/")
# post_put = requests.put(f"{url}post/{post_num}/", json={"title": "test_put"})
# post_delete = requests.delete(f"{url}post/{post_num}/")
