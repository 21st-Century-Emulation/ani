FROM rust:1.51 as builder

RUN USER=root cargo new --bin ani
WORKDIR ./ani
COPY ./Cargo.lock ./Cargo.toml ./
RUN cargo build --release
RUN rm src/*.rs
COPY ./src ./src
RUN rm ./target/release/deps/ani*
RUN cargo build --release

FROM ubuntu:20.04

RUN apt update && apt install -y libssl-dev

COPY --from=builder /ani/target/release/ani .
EXPOSE 8080
ENTRYPOINT ["./ani"]