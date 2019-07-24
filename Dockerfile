# ---- Base Node ----
FROM node:alpine AS base
# set working directory
WORKDIR /home/node
# copy project file
COPY --chown=node:node package*.json ./

#
# ---- Dependencies ----
FROM base AS dependencies
# drop root privs
#USER node
# install production node_modules only
RUN npm install --only=production
# copy production node_modules aside
RUN cp -R node_modules .node_modules
# install ALL node_modules, including 'devDependencies'
RUN npm install

#
# ---- Build ----
# build client and server packages
FROM dependencies AS build
# copy source files
COPY . .
# build bundles
ARG NODE_ENV=production
RUN npm run build

#
# ---- Test ----
# run linters, setup and tests
#FROM dependencies AS test
#COPY . .
#RUN  npm run lint && npm run setup && npm run test

#
# ---- Init ----
# add init and entry point
FROM base AS init
# Install tini
RUN apk add --no-cache tini
# Set tini as entrypoint
ENTRYPOINT ["/sbin/tini", "--"]

#
# ---- Release ----
FROM init AS release
# drop root privs
USER node
# copy production node_modules
COPY --from=dependencies /home/node/.node_modules ./node_modules
# copy build output
COPY --from=build /home/node/www ./www
# copy server.js
COPY server.js ./
# set NODE_ENV
ARG NODE_ENV=production
# expose port and define CMD
ARG PORT=5000
EXPOSE ${PORT}
CMD ["npm", "run", "start:server"]
