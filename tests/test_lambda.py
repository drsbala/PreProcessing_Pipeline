
import pytest
import pandas as pd
from lambda_function import lambda_handler

def test_lambda_handler():
    event = {
        'Records': [{
            's3': {
                'object': {'key': 'housing.csv'},
                'bucket': {'name': 'housing-data-bucket-dev'}
            }
        }]
    }
    result = lambda_handler(event, None)
    assert result['statusCode'] == 200
    