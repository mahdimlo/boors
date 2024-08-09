import requests
from jdatetime import datetime as jdatetime
from jdatetime import timedelta
import pandas as pd
from kafka import KafkaProducer
import set_log
import json


def produce_data_to_kafka(response, date):
    try: 
        df = pd.read_excel(response.content)
        df['تاریخ'] = str(date)
        data = df.to_dict(orient='records')
        producer = KafkaProducer(
            bootstrap_servers=['kafka-broker:29092'],
            value_serializer=lambda v: json.dumps(v).encode('utf-8')
        )
        for record in data:
            producer.send('boors_data_daily', record)
        set_log.info_logger.info(f"The data for this date {str(date)} was correctly sent to Kafka")
    except Exception as e:
        set_log.error_logger.error(f"Error sending data to Kafka: {str(e)}")


def get_data():
    try:
        now = jdatetime.now().date()
        now -= timedelta(days=4)
        if now.weekday() < 5:
            url = f"https://members.tsetmc.com/tsev2/excel/MarketWatchPlus.aspx?d={str(now)}"
            response = requests.get(url)
            if response.status_code == 200:
                set_log.info_logger.info(f"We have successfully connected to this URL: {url}")
                produce_data_to_kafka(response, now)
            else:
                set_log.error_logger.error(f"Could not connect to this URL: {url}")
        else:
            set_log.info_logger.info(f"{str(now)}: This day is weekend")
    except Exception as e:
        set_log.error_logger.error(f"Error downloading files: {str(e)}")


def main():
    get_data()

if __name__ == '__main__':
    main()