### STAGE 1: Build ###
FROM node:16.19-alpine3.16 AS build
WORKDIR /usr/src/app
COPY package.json ./
RUN npm install
COPY . .
RUN npm run build
### STAGE 2: Run ###
FROM nginx:1.17.9-alpine
COPY --from=build /usr/src/app/dist /usr/share/nginx/html
