FROM python:3-alpine

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN apk add --update musl-dev gcc libffi-dev \
  && pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "./benchmark.py" ]
