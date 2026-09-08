import base64
import json
from typing import Any


def _request_payload(event: dict[str, Any]) -> Any:
    """Return a decoded JSON body when supplied by a Function URL caller."""
    body = event.get("body")
    if not body:
        return None

    if event.get("isBase64Encoded"):
        body = base64.b64decode(body).decode("utf-8")

    try:
        return json.loads(body)
    except (TypeError, UnicodeDecodeError, json.JSONDecodeError):
        return body


def handler(event: dict[str, Any], context: Any) -> dict[str, Any]:
    """Acknowledge CTASK-shaped requests without requiring Port credentials."""
    payload = _request_payload(event)

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(
            {
                "message": "CTASK handler is ready",
                "request_received": payload is not None,
            }
        ),
    }
