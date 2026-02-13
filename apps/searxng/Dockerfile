FROM docker.io/searxng/searxng

COPY searxng/settings.yml /etc/searxng/settings.yml
COPY searxng/limiter.toml /etc/searxng/limiter.toml
COPY searxng/uwsgi.ini /etc/searxng/uwsgi.ini

CMD ["uwsgi", "--ini", "/etc/searxng/uwsgi.ini"]