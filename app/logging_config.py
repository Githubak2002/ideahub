"""
Centralized logging setup.

Two env vars control it:
    LOG_LEVEL   default "INFO" - level for the app's OWN logger (ideahub.*)
    LOG_FORMAT  "text" (default, readable for local dev) or "json"
                (one JSON object per line - use this in AKS so Container
                Insights / Log Analytics can query on status_code,
                duration_ms, etc. as actual fields instead of grepping text)

Why this exists: `logging.basicConfig(level=INFO)` sets the ROOT logger to
INFO, which means every third-party library's logger inherits INFO too -
including azure-identity, which logs a line for every credential type
DefaultAzureCredential tries (and expectedly fails) before it finds the one
that works. None of that is actionable noise in normal operation; it just
buries the one line you actually care about. Here, only loggers we
explicitly name below get anything other than WARNING+.
"""

import json
import logging
import logging.config
import os

LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO").upper()
LOG_FORMAT = os.getenv("LOG_FORMAT", "text").lower()


class JsonFormatter(logging.Formatter):
    def format(self, record: logging.LogRecord) -> str:
        payload = {
            "timestamp": self.formatTime(record, "%Y-%m-%dT%H:%M:%S%z"),
            "level": record.levelname,
            "logger": record.name,
            "message": record.getMessage(),
        }
        # Structured fields the request-logging middleware attaches via
        # `extra={...}` - only present on access-log records, not every line.
        for key in ("method", "path", "status_code", "duration_ms"):
            value = getattr(record, key, None)
            if value is not None:
                payload[key] = value
        if record.exc_info:
            payload["exc_info"] = self.formatException(record.exc_info)
        return json.dumps(payload)


def _config() -> dict:
    formatter = "json" if LOG_FORMAT == "json" else "default"
    return {
        "version": 1,
        "disable_existing_loggers": False,
        "formatters": {
            "default": {
                "format": "%(asctime)s %(levelname)-8s %(name)s: %(message)s",
                "datefmt": "%Y-%m-%dT%H:%M:%S%z",
            },
            "json": {"()": JsonFormatter},
        },
        "handlers": {
            "console": {
                "class": "logging.StreamHandler",
                "formatter": formatter,
            },
        },
        "root": {
            "handlers": ["console"],
            "level": "WARNING",  # safe default for anything not named below
        },
        "loggers": {
            # Your app's own logs.
            "ideahub": {
                "level": LOG_LEVEL,
                "handlers": ["console"],
                "propagate": False,
            },
            # uvicorn's own startup/shutdown/error messages - keep these.
            "uvicorn.error": {
                "level": "INFO",
                "handlers": ["console"],
                "propagate": False,
            },
            # uvicorn's default per-request access log - silenced, because
            # the request-logging middleware in main.py replaces it with a
            # line we control the format of (and that also logs the
            # duration, which uvicorn's default line doesn't).
            "uvicorn.access": {
                "level": "WARNING",
                "handlers": ["console"],
                "propagate": False,
            },
            # azure-identity / azure-core: WARNING+ still surfaces a genuine
            # auth failure, it just stops narrating every expected miss in
            # the DefaultAzureCredential chain.
            "azure": {
                "level": "WARNING",
                "handlers": ["console"],
                "propagate": False,
            },
            "aiohttp": {
                "level": "WARNING",
                "handlers": ["console"],
                "propagate": False,
            },
        },
    }


def setup_logging() -> None:
    logging.config.dictConfig(_config())