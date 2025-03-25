# Use Python 3.9 as base image
FROM python:3.12

# Set working directory
WORKDIR /app

# Install system dependencies and curl
RUN apt-get update && apt-get install -y \
    gcc \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv 
ENV VIRTUAL_ENV=/usr/local

ADD --chmod=755 https://astral.sh/uv/install.sh /install.sh
RUN echo "=== Installing uv ===" && \
    /install.sh && \
    echo "=== Installation complete ===" && \
    echo "=== Checking cargo bin ===" && \
    ls -la /root/.local/bin && \
    echo "=== Current PATH ===" && \
    echo $PATH && \
    rm /install.sh

# install requirements via uv
RUN /root/.local/bin/uv pip install --system --no-cache langflow

CMD ["uv", "run", "langflow", "run", "--host", "0.0.0.0", "--port", "7860"]
