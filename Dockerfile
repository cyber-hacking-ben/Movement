# Start from a base image
FROM ubuntu:22.04

# Install essential packages
RUN apt-get update && \
    apt-get install -y curl build-essential git sudo && \
    rm -rf /var/lib/apt/lists/*

# Install Rust and Cargo
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

# Make Rust/Cargo available in PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Movement CLI (Linux x86_64 precompiled binary)
RUN curl -LO https://github.com/movementlabsxyz/homebrew-movement-cli/releases/download/bypass-homebrew/movement-move2-testnet-linux-x86_64.tar.gz && \
    mkdir -p temp_extract && \
    tar -xzf movement-move2-testnet-linux-x86_64.tar.gz -C temp_extract && \
    chmod +x temp_extract/movement && \
    mv temp_extract/movement /usr/local/bin/movement && \
    rm -rf temp_extract movement-move2-testnet-linux-x86_64.tar.gz

# Verify installation
RUN movement --version

# Set working directory for your app
WORKDIR /app

# Copy your project files
COPY . .

# Expose port (if your app runs on a port)
EXPOSE 3000

# Start command (adjust for your app)
CMD ["bash"]
