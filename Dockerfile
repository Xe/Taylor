FROM swift:latest as builder
WORKDIR /app
COPY . .
RUN swift build -c release --static-swift-stdlib

FROM swift:slim
WORKDIR /app
COPY --from=builder /app/.build/release/Taylor .
CMD ["./Taylor"]
