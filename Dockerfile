FROM node:alpine as cache
WORKDIR /tmp
ADD package.json package-lock.json ./
RUN npm install

FROM node:alpine as builder
WORKDIR /home/node/app
COPY --from=cache /tmp/node_modules ./node_modules
COPY . .
RUN npm run build

FROM node:alpine
WORKDIR /home/app
COPY --from=builder /home/node/app/dist ./dist
EXPOSE 3000

ENTRYPOINT ["node", "./dist/main.js"]