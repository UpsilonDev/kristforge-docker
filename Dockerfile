FROM rust:bullseye AS build

RUN apt update && apt install -y git && mkdir -p /tmp/build \
    && cd /tmp/build && git clone https://github.com/tmpim/kristforge /tmp/build \
    && cargo build --release && strip ./target/release/kristforge

FROM debian:11
WORKDIR /usr/bin

COPY --from=build /tmp/build/target/release/kristforge /usr/bin
RUN apt update && apt install -y ca-certificates
ENTRYPOINT ["kristforge", "mine", "--no-gpu"]
