import datetime
from apnsclient import *
from apns2.client import APNsClient
from apns2.payload import Payload
def send_Notification( message, key):

    token_hex = 'e4d3e8cb6e8c29d0dd6af4926e698c69632e2a8965cd17d66ed2d0cdd7869269'
    payload = Payload(alert="Hello World!", sound="default", badge=1)
    topic = 'ASU.SeatsFinderBot'
    client = APNsClient(key, use_sandbox=True, use_alternative_port=False)
    client.send_notification(token_hex, payload, topic)

send_Notification("helo","pushKey.pem")
