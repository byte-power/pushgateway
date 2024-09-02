# Build
FROM golang:1.22.6-alpine AS builder

WORKDIR /app
COPY . .
RUN go build -o pushgateway

# Deploy
ARG TARGETOS
ARG TARGETARCH

FROM quay.io/prometheus/busybox-${TARGETOS}-${TARGETARCH}:latest
LABEL maintainer="The Prometheus Authors <prometheus-developers@googlegroups.com>"

WORKDIR /app
COPY --from=builder --chown=nobody:nobody /app/pushgateway /bin/pushgateway

EXPOSE 9091
RUN mkdir -p /pushgateway && chown nobody:nobody /pushgateway
WORKDIR /pushgateway

USER 65534

ENTRYPOINT [ "/bin/pushgateway" ]
