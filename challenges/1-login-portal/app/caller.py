import json
import re
import requests
from urllib.parse import urljoin

from flask import Blueprint
from twilio.rest import Client
from twilio.twiml.voice_response import Play, VoiceResponse

NUMBER_REGEX = re.compile(r'(\+44|0)\d+')

server = "http://" + requests.get("https://api.ipify.org?format=text").text
print("server: " + server)

with open('config.json') as config_file:
    config = json.load(config_file)

    account_sid = config['account_sid']
    auth_token  = config['auth_token']
    number      = config['number']

client = Client(account_sid, auth_token)

def call(destination):
    if not NUMBER_REGEX.match(destination):
        raise CallError('invalid phone number')

    call = client.calls.create(
        url=urljoin(server, '/twilio/voice.xml'),
        to=destination,
        from_=number
    )

    print("calling you now from " + number)

caller = Blueprint('caller', __name__)

@caller.route("/twilio/voice.xml", methods=['POST'])
def voice():
    print('received voice call!!!')
    response = VoiceResponse()
    response.play('/static/voice-service.mp3')
    return str(response)

class CallError(RuntimeError):
    pass
