FROM python:3.6.6
RUN ["apt-get", "update"]
RUN ["apt-get", "install", "-y", "vim"]
RUN ["apt-get", "install", "-y", "nano"]

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt
RUN groupadd -r django \
    && useradd -r -g django django

COPY . /app
RUN chown -R django /app

RUN mkdir -p /logs
RUN chown -R django:django /logs

COPY ./entrypoint.sh /entrypoint.sh

RUN sed -i 's/\r//' /entrypoint.sh \
    && chmod +x /entrypoint.sh \
    && chown django /entrypoint.sh

WORKDIR /app

EXPOSE 5000
ENTRYPOINT ["/entrypoint.sh"]
