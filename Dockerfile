FROM ubuntu:22.04

RUN apt-get update && apt-get install -y curl ca-certificates

CMD ["bash", "-c", "echo Docker detected && sleep infinity"]
