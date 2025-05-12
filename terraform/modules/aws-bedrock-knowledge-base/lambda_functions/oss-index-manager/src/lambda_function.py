from urllib.parse import urlparse

from aws_lambda_powertools.utilities.typing import LambdaContext

from OpenSearchServerlessCollection import OpenSearchServerlessCollection
from utils import logger, tracer


@tracer.capture_lambda_handler
def lambda_handler(event, context: LambdaContext):
    """
    Lambda function that manages OpenSearch Serverless indexes

    Args:
        event: Lambda event containing operation details
        context: Lambda runtime context

    Returns:
        Standardized API response
    """
    logger.info(event)
    operation = event.get("operation")
    index_name = event.get("index_name")
    index_body = event.get("index_body")
    host = urlparse(event.get("host")).netloc
    port = event.get("port")
    aws_region = event.get("aws_region")
    try:
        oss = OpenSearchServerlessCollection(
            host=host,
            port=port,
            aws_region=aws_region,
        )

        index_exists = oss.check_if_index_exists(name=index_name)

        if operation == "create":
            if index_exists:
                logger.info(f"Index {index_name} already exists, skipping creation")
                return {
                    "status_code": 409,
                    "index_name": index_name,
                    "status": "already_exists",
                    "message": f"Index {index_name} already exists",
                }
            resp = oss.create_index(name=index_name, body=index_body)
            logger.info(
                f"Index {index_name} created successfully", extra={"response": resp}
            )
            return {
                "status_code": 201,
                "index_name": index_name,
                "status": "success",
                "message": f"Index {index_name} created successfully",
            }

        if operation == "update":
            if not index_exists:
                logger.info(f"Index {index_name} does not exist, creating instead")
                resp = oss.create_index(name=index_name, body=index_body)
                logger.info(
                    f"Index {index_name} created successfully", extra={"response": resp}
                )
                return {
                    "status_code": 201,
                    "index_name": index_name,
                    "status": "success",
                    "message": f"Index {index_name} created successfully",
                }
            resp = oss.update_index_settings(name=index_name, settings=index_body)
            logger.info(
                f"Index {index_name} created successfully", extra={"response": resp}
            )
            return {
                "status_code": 200,
                "index_name": index_name,
                "status": "success",
                "message": f"Index {index_name} updated successfully",
            }

        if operation == "delete":
            if not index_exists:
                logger.info(f"Index {index_name} does not exist, cannot delete")
                return {
                    "status_code": 404,
                    "index_name": index_name,
                    "status": "not_found",
                    "message": f"Index {index_name} not found",
                }
            resp = oss.delete_index(name=index_name)
            logger.info(
                f"Index {index_name} deleted successfully", extra={"response": resp}
            )
            return {
                "status_code": 200,
                "index_name": index_name,
                "status": "success",
                "message": f"Index {index_name} deleted successfully",
            }

        return {
            "status_code": 500,
            "status": "failed",
            "message": f"Operation not found",
        }

    except Exception as e:
        logger.exception(f"Error in lambda_handler: {str(e)}")
        error_details = {
            "type": e.__class__.__name__,
            "reason": str(e),
        }
        return {
            "status_code": 500,
            "status": "failed",
            "message": f"Error processing request: {str(e)}",
            "error_details": error_details,
        }
