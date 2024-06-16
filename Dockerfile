FROM swift:latest as builder
WORKDIR /app
COPY . .
RUN swift build -c release --static-swift-stdlib

FROM ubuntu:latest
WORKDIR /app
COPY --from=builder /app/.build/release/Taylor .
CMD ["./Taylor"]
