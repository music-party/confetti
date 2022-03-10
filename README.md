# confetti

## Getting started

Clone the repo

```console
git clone https://github.com/music-party/confetti.git
cd confetti
```

[Create and activate](https://docs.python.org/3/library/venv.html#creating-virtual-environments) the virtual environment

```console
python -m venv .venv
source .venv/bin/activate
```

Install django and graphene

```console
pip install django graphene-django django-filter
```

Start the server

```console
python manage.py migrate
python manage.py runserver
```
