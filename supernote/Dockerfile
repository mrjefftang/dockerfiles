# Build stage: Chainguard's -dev variant ships pip, apk and a shell so we can
# build a self-contained virtualenv with supernote and its server extras.
FROM cgr.dev/chainguard/python:latest-dev AS builder

ENV SUPERNOTE_VERSION=0.14.8

USER root

# Create the virtualenv that we copy into the distroless runtime stage.
RUN python -m venv /venv
ENV PATH="/venv/bin:$PATH"

RUN pip install --no-cache-dir "supernote[all]==${SUPERNOTE_VERSION}" "starlette==0.52.1"

# Pre-create the data/config directories owned by the nonroot user (uid 65532)
# so the distroless runtime, which has no shell to mkdir/chown, can use them.
RUN mkdir -p /data/config && chown -R 65532:65532 /data


# Runtime stage: Chainguard's distroless Python image (no shell, no package
# manager, runs as the nonroot user 65532 by default).
FROM cgr.dev/chainguard/python:latest

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    SUPERNOTE_STORAGE_DIR=/data \
    SUPERNOTE_CONFIG_DIR=/data/config \
    SUPERNOTE_HOST=0.0.0.0 \
    SUPERNOTE_PORT=8080 \
    PATH="/venv/bin:$PATH"

COPY --from=builder /venv /venv
COPY --from=builder --chown=65532:65532 /data /data

USER 65532

EXPOSE 8080

VOLUME ["/data"]

ENTRYPOINT ["/venv/bin/supernote-server"]
CMD ["serve"]
