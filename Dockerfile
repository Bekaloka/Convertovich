FROM oven/bun AS builder

WORKDIR /app

ARG PUB_ENV
ARG PUB_HOSTNAME
ARG PUB_PLAUSIBLE_URL
ARG PUB_DONATION_URL
ARG PUB_STRIPE_KEY

ENV PUB_ENV=${PUB_ENV}
ENV PUB_HOSTNAME=${PUB_HOSTNAME}
ENV PUB_PLAUSIBLE_URL=${PUB_PLAUSIBLE_URL}
ENV PUB_DONATION_URL=${PUB_DONATION_URL}
ENV PUB_STRIPE_KEY=${PUB_STRIPE_KEY}

COPY package.json ./

RUN bun install

COPY . ./

RUN bun run build

FROM nginx:stable-alpine

COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf

COPY --from=builder /app/build /usr/share/nginx/html