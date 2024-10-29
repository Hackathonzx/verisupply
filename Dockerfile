ARG VARIANT="nightly-bookworm-slim"
FROM rustlang/rust:${VARIANT}
ENV DEBIAN_FRONTEND noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq install build-essential libwebkit2gtk-4.1-dev libgtk-3-dev libayatana-appindicator3-dev

RUN apt update
RUN apt install -y \
    libglib2.0-dev \
    libgtk-3-dev \
    libsoup2.4-dev \
    libappindicator3-dev \
    libwebkit2gtk-4.0-dev \
    firefox-esr \
    # for Tarpaulin code coverage
    liblzma-dev binutils-dev libcurl4-openssl-dev libdw-dev libelf-dev


RUN rustup target add wasm32-unknown-unknown

RUN cargo install dioxus-cli --version 0.5

WORKDIR /usr/src/verisupply

COPY . .

RUN dx build --features fullstack --platform fullstack --release

# RUN cargo build --release
# RUN cargo install --path .
# RUN cargo install --path . --features web
# RUN cargo install --path . --features web --target wasm32-unknown-unknown
# RUN cargo install --path . --features web --target wasm32-unknown-unknown --release

EXPOSE 8080

CMD ["/usr/src/verisupply/target/release/verisupply"]







# FROM rust:1.73-buster AS builder

# WORKDIR /usr/src/cochrane

# RUN rustup target add wasm32-unknown-unknown \
#     && cargo install dioxus-cli --version 0.4.1
# COPY . .
# RUN cd frontend \
#     && dx build --features web --platform web --release

# FROM caddy:2.7.5-alpine

# COPY --from=builder /usr/src/cochrane/frontend/dist /usr/share/caddy
