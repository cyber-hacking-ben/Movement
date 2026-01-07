# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/go/dockerfile-reference/

# Want to help us make this template better? Share your feedback here: https://forms.gle/ybq9Krt8jtBL3iCk7

ARG PYTHON_VERSION=3.12.0

# -----------------------------------------------------------------------------
# Backend (FastAPI + Movement CLI)
# -----------------------------------------------------------------------------
FROM python:${PYTHON_VERSION}-slim AS backend

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive

# 1. Install System Dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    build-essential \
    bash \
    git \
    && rm -rf /var/lib/apt/lists/*

# 2. Install Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:$PATH"

# 3. Install Movement CLI
RUN curl -LO https://github.com/movementlabsxyz/homebrew-movement-cli/releases/download/bypass-homebrew/movement-move2-testnet-linux-x86_64.tar.gz \
 && mkdir temp_extract \
 && tar -xzf movement-move2-testnet-linux-x86_64.tar.gz -C temp_extract \
 && chmod +x temp_extract/movement \
 && mv temp_extract/movement /usr/local/bin/movement \
 && rm -rf temp_extract movement-move2-testnet-linux-x86_64.tar.gz

# 4. OPTIMIZED FRAMEWORK SETUP
WORKDIR /frameworks

# A) Extract ONLY move-stdlib from aptos-core (Discard the rest to save space/RAM)
RUN curl -L https://github.com/aptos-labs/aptos-core/archive/refs/heads/main.tar.gz \
    | tar -xz \
 && mkdir -p /frameworks/move-stdlib \
 && mv aptos-core-main/aptos-move/framework/move-stdlib/* /frameworks/move-stdlib/ \
 && rm -rf aptos-core-main

# B) Copy your LOCAL Stubbed Framework
COPY frameworks/stubbed-aptos-framework /frameworks/stubbed-aptos-framework

# C) FORCE-PATCH the Stub's dependency path
# We rewrite the Stub's Move.toml to point to our clean /frameworks/move-stdlib
# This ensures it finds the dependency regardless of what you had locally.
RUN sed -i 's|MoveStdlib = .*|MoveStdlib = { local = "/frameworks/move-stdlib" }|' /frameworks/stubbed-aptos-framework/aptos-framework/Move.toml

# 5. Setup Python App
WORKDIR /app
COPY requirements.txt ./
RUN --mount=type=cache,target=/root/.cache/pip \
    python -m pip install -r requirements.txt

COPY app.py formatter.py ./

EXPOSE 8000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]