import boto3
from aws_lambda_powertools import Logger, Metrics, Tracer

logger = Logger(service="oss-index-manager")
tracer = Tracer(service="oss-index-manager")
metrics = Metrics(namespace="OSSIndexManager", service="oss-index-manager")


@tracer.capture_method
def get_aws_credentials():
    return boto3.Session().get_credentials()
