FROM nginx:1.27.4-alpine3.21-slim AS base
COPY nginx.conf /etc/nginx/nginx.conf

FROM oven/bun:1.2.4-alpine AS builder
WORKDIR /app
COPY package.json .
COPY bun.lock .
RUN bun install --silent
COPY . .
RUN bun run generate

FROM base AS final
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 8080
CMD [ "nginx", "-g", "daemon off;" ]