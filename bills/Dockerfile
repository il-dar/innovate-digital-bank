FROM node:8.15.0 as build
LABEL maintainer="moficodes@gmail.com"

#RUN apt-get install -y nodejs npm

WORKDIR /app
# Install app dependencies
COPY . /app
RUN cd /app; npm install; npm prune --production

FROM node:8.15.0-alpine
COPY --from=build /app /

ENV NODE_ENV production
ENV PORT 3800

EXPOSE 3800
CMD [ "npm","start" ]
