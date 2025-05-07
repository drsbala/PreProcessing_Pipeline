import psycopg2
import logging
import os
import pandas as pd
import boto3
import csv
from io import StringIO
from io import BytesIO

# Set up logging
logger = logging.getLogger()
logger.setLevel("INFO")

# Initialize the S3 client
s3_client = boto3.client('s3')

def lambda_handler(event, context):
    print("Lambda function started")
    print(event)
    # Retrieve database connection parameters from environment variables
    # Get the S3 bucket name and file name from the event
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    file_key = event['Records'][0]['s3']['object']['key']
    
    # Download the CSV file from S3
    try:
        #response = s3_client.get_object(Bucket=bucket_name, Key=file_key)
        response = s3_client.get_object(Bucket=bucket_name, Key=file_key)
        df = pd.read_csv(BytesIO(response['Body'].read()))
        df.dropna(inplace=True)
        summary = df.groupby('ocean_proximity')['median_house_value'].mean().reset_index()

        insert_into_rds(summary)
        logger.info("Successfully processed and inserted data.")
        return {"statusCode": 200, "body": "Success"}
    except Exception as e:
        logger.error(f"Error: {str(e)}")
        return {"statusCode": 500, "body": str(e)}


def insert_into_rds(df):
    conn = psycopg2.connect(
        dbname=os.environ['DB_NAME'],
        user=os.environ['DB_USER'],
        password=os.environ['DB_PASSWORD'],
        host=os.environ['DB_HOST'],
        port=os.environ['DB_PORT']
    )
    cursor = conn.cursor()

    cursor.execute("CREATE TABLE IF NOT EXISTS ocean_summary (ocean_proximity TEXT, avg_median_value FLOAT);")
    cursor.execute("DELETE FROM ocean_summary;")

    for _, row in df.iterrows():
        cursor.execute(
            "INSERT INTO ocean_summary (ocean_proximity, avg_median_value) VALUES (%s, %s);",
            (row['ocean_proximity'], row['median_house_value'])
        )

     # Step 3: Fetch and print all data from the table
    cursor.execute("SELECT * FROM ocean_summary;")
    all_records = cursor.fetchall()  # Fetch all rows from the result
    logger.info("Data from ocean_summary table:")
    for record in all_records:
        logger.info(f"Row: {record}")

    conn.commit()
    cursor.close()
    conn.close()




  
       