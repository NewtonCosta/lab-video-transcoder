import json
import boto3
import os


def handler(event, context):
    mc = boto3.client("mediaconvert")
    endpoints = mc.describe_endpoints()
    mc = boto3.client(
        "mediaconvert", endpoint_url=endpoints["Endpoints"][0]["Url"])

    for record in event["Records"]:
        body = json.loads(record["body"])
        key = body["detail"]["object"]["key"]

        mc.create_job(
            Role=os.environ["MC_ROLE"],
            JobTemplate=os.environ["JOB_TEMPLATE"],
            Settings={
                "Inputs": [{
                    "FileInput": f"s3://{os.environ['BUCKET']}/{key}"
                }]
            }
        )
