#!/bin/bash

NAME="DjangoBlog"
DJANGODIR=/www/django-blog-tutorial/ #Django project directory
#SOCKFILE=/www/django-blog-tutorial/run/gunicorn.sock # we will communicte using this unix socket
USER=root # the user to run as
GROUP=root # the group to run as
NUM_WORKERS=2 # how many worker processes should Gunicorn spawn
DJANGO_SETTINGS_MODULE=blogproject.settings # which settings file should Django use
DJANGO_WSGI_MODULE=blogproject.wsgi # WSGI module name

echo "Starting $NAME as `whoami`"

# Activate the virtual environment
cd $DJANGODIR
source /www/django-blog-tutorial/ceshi_venv/bin/activate
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH

# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR

# Start your Django Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
#gunicorn目录(刚刚创建的虚拟环境的bin目录中)
exec /www/django-blog-tutorial/ceshi_venv/bin/gunicorn ${DJANGO_WSGI_MODULE}:application \
--name $NAME \
--workers $NUM_WORKERS \
--user=$USER --group=$GROUP \
--bind="0.0.0.0:8000"
--log-level=debug \
--log-file=-
