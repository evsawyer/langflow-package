# Use Python 3.9-slim-bookworm as base image
FROM python:3.12-slim-bookworm

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    curl \
    ca-certificates \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Download and install uv
ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh

# Ensure uv is on PATH
ENV PATH="/root/.local/bin/:$PATH"

# Install langflow using uv
RUN uv pip install --system --no-cache langflow
RUN uv pip install --system --no-cache slack-sdk

# # Cloud Run will set PORT environment variable
# ENV PORT=7860

CMD ["uv", "run", "langflow", "run", "--host", "0.0.0.0", "--port", "7860"]
