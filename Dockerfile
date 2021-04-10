FROM node:14-alpine AS builder

ADD . /app
WORKDIR /app
RUN npm install && npm run build

FROM node:14-alpine
ENV NODE_ENV="production"
RUN npm install -g nodemon && \
  addgroup nonroot --gid 1100 && \
  adduser nonroot --ingroup nonroot --uid 1100 --home /home/nonroot --disabled-password

COPY --from=builder /app/build /app

USER 1100:1100
EXPOSE 8080
ENTRYPOINT [ "node", "build", "8080", "/app" ]
