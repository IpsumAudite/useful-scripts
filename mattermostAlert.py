import json
import boto3
import urllib3

print('Loading function')

s3 = boto3.resource('s3')
MATTERMOST_KEY = 'test'
MATTERMOST_ENDPOINT = 'https://chat.test.url'
CONFIG_BUCKET = 'alert-bucket'

def call_mattermost(msg):
    headers = {}
    encoded_body = json.dumps({
        "username": "backup-bot",
        "text": f':rotating_light: {msg}'
    })
    http = urllib3.PoolManager()
    response = http.request('POST', f'{MATTERMOST_ENDPOINT}/hooks/{MATTERMOST_KEY}',headers=headers, body=encoded_body)
    print(f'Sent data: {msg} with response {response.status}, {response.data}')

def lambda_handler(event, context):
    return call_mattermost(event)
