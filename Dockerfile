#########################
# Development Container #
#########################

# Defining the base image
FROM node:14-bullseye as dev

# Setting the variables for development
ARG NODE_ENV=development
ENV NODE_ENV $NODE_ENV

# Define the application location
RUN mkdir /opt/app && chown node:node /opt/app
WORKDIR /opt/app

# Install the dependencies in a non-default location to avoid clashing
USER node
COPY package.json package-lock.json* ./
RUN npm install --no-optional 
RUN npm cache clean --force
ENV PATH /opt/app/node_modules/.bin:$PATH

# Exposing the web & debug ports for the application
ARG PORT=3000
ARG HOST=0
ENV PORT $PORT
ENV HOST=$HOST
EXPOSE $PORT 9229 9230

# Run the application
WORKDIR /opt/app
CMD [ "npm", "run", "dev" ]

###############
# Build Phase #
###############

# Use the development image as a base
FROM dev as build

# Reset the environment for production
ARG NODE_ENV=production
ENV NODE_ENV $NODE_ENV

# Run the build command
WORKDIR /opt/app
COPY . .
RUN npm run build

########################
# Production container #
########################

# Define the base image
FROM node:14-alpine3.15 as prod

# Copy the package management files from the development container
WORKDIR /opt/app
COPY --from=build /opt/app/package.json /opt/app/package-lock.json* /opt/app/nuxt.config.js ./

# Install the non-development dependencies
RUN npm install --only=prod --no-optional

# Copy the build directory from the build container
COPY --from=build /opt/app/.nuxt/dist /opt/app/.nuxt/dist

# Exposing the web ports for the application
ARG PORT=3000
ARG HOST=0
ENV PORT $PORT
ENV HOST=$HOST
EXPOSE $PORT

# Run the build command
WORKDIR /opt/app
CMD ["npm", "start"]
