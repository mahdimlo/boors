FROM python:3.11

COPY ./app /home/app

RUN /usr/local/bin/pip install -r /home/app/requirements.txt

RUN /usr/local/bin/python /home/app/get_and_produce_data_to_kafka.py
