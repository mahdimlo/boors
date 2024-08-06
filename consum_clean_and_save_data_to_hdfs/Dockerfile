FROM python:3.11

COPY ./app /home/app

RUN /usr/local/bin/pip install --upgrade pip 

RUN /usr/local/bin/pip install -r /home/app/requirements.txt

RUN /usr/local/bin/python /home/app/consum_clean_and_save_data_to_hdfs.py

CMD ["tail", "-f", "/dev/null"]
