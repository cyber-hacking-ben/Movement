# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/go/dockerfile-reference/

# Want to help us make this template better? Share your feedback here: https://forms.gle/ybq9Krt8jtBL3iCk7

ARG PYTHON_VERSION=3.12.0
ARG NODE_VERSION=20

# -----------------------------------------------------------------------------
# Frontend build (Next.js)
# -----------------------------------------------------------------------------
FROM node:${NODE_VERSION}-bookworm-slim AS frontend-deps
WORKDIR /client
COPY client/package.json client/package-lock.json ./
RUN npm ci

FROM node:${NODE_VERSION}-bookworm-slim AS frontend-build
WORKDIR /client
COPY --from=frontend-deps /client/node_modules ./node_modules
COPY client/ ./
RUN npm run build

FROM node:${NODE_VERSION}-bookworm-slim AS frontend
ENV NODE_ENV=production
WORKDIR /client
COPY client/package.json client/package-lock.json ./
RUN npm ci --omit=dev
COPY --from=frontend-build /client/.next ./.next
COPY --from=frontend-build /client/public ./public
COPY --from=frontend-build /client/next.config.ts ./next.config.ts
EXPOSE 3000
CMD ["npm", "run", "start"]

# -----------------------------------------------------------------------------
# Backend (FastAPI + Movement CLI)
# -----------------------------------------------------------------------------
FROM python:${PYTHON_VERSION}-slim AS backend

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    build-essential \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Install Rust (needed by Movement toolchain)
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:$PATH"

# Install Movement CLI
RUN curl -LO https://github.com/movementlabsxyz/homebrew-movement-cli/releases/download/bypass-homebrew/movement-move2-testnet-linux-x86_64.tar.gz \
 && mkdir temp_extract \
 && tar -xzf movement-move2-testnet-linux-x86_64.tar.gz -C temp_extract \
 && chmod +x temp_extract/movement \
 && mv temp_extract/movement /usr/local/bin/movement \
 && rm -rf temp_extract movement-move2-testnet-linux-x86_64.tar.gz
 
# Bake Aptos stdlib once at build time (NO GIT AT RUNTIME)
WORKDIR /frameworks
RUN curl -L https://github.com/aptos-labs/aptos-core/archive/refs/heads/main.tar.gz \
    | tar -xz \
 && mv aptos-core-main aptos-core
 
WORKDIR /app
COPY requirements.txt ./
RUN --mount=type=cache,target=/root/.cache/pip \
    python -m pip install -r requirements.txt

COPY app.py formatter.py Move.toml ./

EXPOSE 8000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
