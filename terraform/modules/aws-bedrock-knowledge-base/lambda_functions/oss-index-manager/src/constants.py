import os

from dotenv import load_dotenv

load_dotenv()

OSS_AWS_REGION = os.environ.get("OSS_AWS_REGION")
HOST = os.environ.get("HOST")
PORT = int(os.environ.get("PORT", 443))
REQUIRED_EVENT_PARAMS = ["operation", "index_name"]
