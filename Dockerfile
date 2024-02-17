# --[ Stage 0
FROM ubuntu:focal as base
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/* && \
    python3 -m pip install "poetry==1.3.2"

# --[ Stage 1
FROM base as build
WORKDIR /app
COPY . /app
RUN poetry config virtualenvs.in-project true
RUN poetry install --only main

# --[ Stage 2
FROM base
COPY --from=build /app /app
VOLUME /app/_irc-logs
WORKDIR /app
ENV PATH="/app/.venv/bin:$PATH"
ENTRYPOINT ["python", "run.py", "-p", "80"]
EXPOSE 80
