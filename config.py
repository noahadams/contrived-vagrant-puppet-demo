import os

DEBUG = (os.environ.get('DEBUG', 'False') == 'True')

# DB
SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL', None)
SQLALCHEMY_ECHO = DEBUG

# Celery
CELERY_ENABLE_UTC = True
CELERY_TIMEZONE = 'UTC'

CELERYD_CONCURRENCY = int(os.environ.get('WORKER_CONCURRENCY', 4))

BROKER_URL = os.environ.get('RABBIT_MQ_URL', os.environ.get('RABBITMQ_BIGWIG_TX_URL', None))

CELERY_RESULT_BACKEND = "amqp"