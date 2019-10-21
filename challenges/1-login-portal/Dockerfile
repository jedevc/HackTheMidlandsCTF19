FROM python:3-alpine

WORKDIR /usr/src/app/
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

RUN mkdir -p templates static app
COPY app ./app
COPY static ./static
COPY templates ./templates
COPY config.json config.json

CMD ["python", "-m", "app"]
