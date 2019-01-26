FROM node:8.15.0 as build
LABEL maintainer="moficodes@gmail.com"

#RUN apt-get install -y nodejs npm

WORKDIR /app
# Install app dependencies
COPY . /app
RUN cd /app; npm install; npm prune --production

FROM iron/node
COPY --from=build /app /

ENV NODE_ENV production
ENV PORT 3100

EXPOSE 3100
CMD [ "npm","start" ]