from typing import Dict

from opensearchpy import AWSV4SignerAuth, OpenSearch, RequestsHttpConnection

from constants import HOST, OSS_AWS_REGION, PORT
from utils import get_aws_credentials, logger


class OpenSearchServerlessCollection:
    """
    Wrapper class for OpenSearch Serverless operations
    """

    def __init__(
        self,
        host: str = HOST,
        port: int = PORT,
        aws_region: str = OSS_AWS_REGION,
        use_ssl: bool = True,
        verify_certs: bool = True,
        timeout: int = 30,
    ):
        """
        Initialize the OpenSearch Serverless collection with connection parameters.

        Args:
            host: OpenSearch host endpoint
            port: OpenSearch port
            aws_region: AWS region where OpenSearch is deployed
            use_ssl: Whether to use SSL for connections
            verify_certs: Whether to verify SSL certificates
            timeout: Connection timeout in seconds
        """
        self._aws_region = aws_region
        self._host = host
        self._port = port if port else PORT
        self._configs = {
            "use_ssl": use_ssl,
            "verify_certs": verify_certs,
            "timeout": timeout,
        }
        self._client = None

        logger.debug(
            "Initializing OpenSearchServerlessCollection",
            extra={
                "host": self._host,
                "port": self._port,
                "region": self._aws_region,
            },
        )

    @property
    def host(self) -> str:
        return self._host

    @property
    def port(self) -> int:
        return self._port

    @property
    def aws_region(self) -> str:
        return self._aws_region

    @property
    def configs(self) -> Dict:
        return self._configs

    @property
    def auth(self) -> AWSV4SignerAuth:
        """
        Create AWS V4 authentication for OpenSearch requests.

        Returns:
            AWSV4SignerAuth instance
        """
        aws_credentials = get_aws_credentials()
        return AWSV4SignerAuth(
            credentials=aws_credentials, region=self._aws_region, service="aoss"
        )

    @property
    def client(self) -> OpenSearch:
        """
        Lazy-loaded OpenSearch client property.

        Returns:
            OpenSearch client instance
        """
        if not self._client:
            logger.debug("Creating new OpenSearch client")
            self._client = OpenSearch(
                hosts=[{"host": self._host, "port": self._port}],
                connection_class=RequestsHttpConnection,
                http_auth=self.auth,
                **self._configs,
            )
        return self._client

    def check_if_index_exists(self, name: str) -> bool:
        """
        Check if an index exists in OpenSearch.

        Args:
            name: Name of the index to check

        Returns:
            True if index exists, False otherwise
        """
        logger.debug(f"Checking if index {name} exists")
        resp = self.client.indices.exists(index=name)
        logger.info(f"Index {name} exists: {resp}")
        return resp

    def create_index(self, name: str, body: Dict) -> Dict:
        """
        Create a new index in OpenSearch.

        Args:
            name: Name of the index to create
            body: Index configuration and mappings

        Returns:
            OpenSearch API response
        """
        logger.debug(f"Creating index {name}")
        resp = self.client.indices.create(index=name, body=body)
        logger.info(f"Index {name} created successfully", extra={"response": resp})
        return resp

    def delete_index(self, name: str) -> Dict:
        """
        Delete an index from OpenSearch.

        Args:
            name: Name of the index to delete

        Returns:
            OpenSearch API response
        """
        logger.debug(f"Deleting index {name}")
        resp = self.client.indices.delete(index=name)
        logger.info(f"Index {name} deleted successfully", extra={"response": resp})
        return resp

    def update_index_settings(self, name: str, settings: Dict) -> Dict:
        """
        Update settings for an existing index.

        Args:
            name: Name of the index to update
            settings: New settings to apply

        Returns:
            OpenSearch API response
        """
        logger.debug(f"Updating settings for index {name}")
        resp = self.client.indices.put_settings(index=name, body=settings)
        logger.info(f"Settings updated for index {name}", extra={"response": resp})
        return resp
