import pandas as pd
from kafka import KafkaConsumer
import json
import set_log
from hdfs import InsecureClient



def consum_data_from_kafka():
    try:
        consumer = KafkaConsumer("boors_data_daily", 
                                    bootstrap_servers=['kafka-broker:29092'],
                                    auto_offset_reset='earliest',
                                    group_id='consum_boors_data_daily',
                                    value_deserializer=lambda m: json.loads(m.decode('utf-8')),
                                    security_protocol= 'PLAINTEXT'
                                    )
        all_data = []
        for massage in consumer:
            data = massage.value
            all_data.append(data)
        set_log.info_logger.info(f"All data was properly consumed from Kafka")
        return all_data
    except Exception as e:
        set_log.error_logger.error(f"Unfortunately, we could not consum the data from Kafka: {str(e)}")


def clean_data(all_data):
    try:
        df = pd.DataFrame(all_data)
        if df.shape[0] < 2:
            set_log.info_logger.info("This data is empty and was removed")
            return None
        else:
            set_log.info_logger.info("The data was cleared")
            return df
    except Exception as e:
        set_log.error_logger.error(f"There is a problem in clearing the data: {str(e)}")


def save_data_to_hdfs(df, hdfs_path):
    try:
        client = InsecureClient('hdfs://namenode:50070', user='hadoop')
        with client.write(hdfs_path, encoding='utf-8', overwrite=True) as writer:
            df.to_csv(writer)
        set_log.info_logger.info(f"Data successfully saved to HDFS at {hdfs_path}")
    except Exception as e:
        set_log.error_logger.error(f"Error saving data to HDFS: {str(e)}")


def main():
    all_data = consum_data_from_kafka()
    if all_data is not None:
        df = clean_data(all_data)
        if df is not None:
            date_str = df['تاریخ'].iloc[0]
            hdfs_path = f"/user/boors_data_csv/{str(date_str)}.csv"
            save_data_to_hdfs(df, hdfs_path)


if __name__ == '__main__':
    main()

