FROM python:3.11-alpine
LABEL likelion.web.backend.author="JunYoung Kim <hjklo0220@gmail.com>"

# RUN apk add --no--cache --upgrade

ARG APP_HOME=/app

# 환경변수
# 모든 출력들이 바로바로 보이게 됨
ENV PYTHONUNBUFFERED 1
# .pyc라는 바이트코드가 만들어지는데 컨테이너안에선 필요없어서 뺴주는것임(경량화)
ENV PYTHONDONTWRITEBYTECODE 1

RUN mkdir ${APP_HOME}
WORKDIR ${APP_HOME}

#install requirements
COPY ./requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
# --no-cache-dir 이미지를 한번 만들변 다시 할일이 없기 때문에 캐시디렉토리 안만들어주게함

#run server
# 필요한 모든 파일을 복사
COPY . ${APP_HOME}

COPY ./script/start /start
RUN sed -i  's/\r$//g' /start
RUN chmod +x /start

# lion-app이 먼저 켜지는거 방지 스크립트
COPY ./script/entrypoint /entrypoint
RUN sed -i  's/\r$//g' /entrypoint
RUN chmod +x /entrypoint

# RUN if [ -e /vat/www/html/static ]; then rm -rf /var/www/html/static fi
RUN python manage.py collectstatic

ENTRYPOINT [ "/entrypoint" ]

CMD [ "python", "--version" ]
# CMD [ "gunicorn", "lion_app.wsgi:application", "--config", "lion_app/gunicorn_config.py" ]



