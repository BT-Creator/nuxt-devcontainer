# Nuxt Devcontainer

This repo is a template repo that allows you to create a Nuxt project and develop it within a container. :confetti_ball:

## Features
- :building_construction: Container-based developer environment.
- :key: Environment variables injection with separate `.env.docker` file.
- :computer: Devcontainer support!
- :chart_with_upwards_trend: Multi-stage `Dockerfile` that allows for creating a developer image & production image.
- :handshake: Local or Container-based development? This repo supports both of them!
- :classical_building: Able to be used as a basis to build your Nuxt app on.
  
## Getting started
### Requirements
- NPM
- Docker

### How to
#### Manually
1. Use the template button in order to create your own version of this repo
2. Clone your repo to your machine
3. Within the root of the project, run the following command:
    ```bash
    $ npx create-nuxt-app --overwrite-dir
    ```
    > :tada: Don't worry, the templates files won't disappear
4. Select the feature that you want in your project
5. In the `nuxt.config.js`, add the polling functionality:
   ```js
   module.exports = {
       // ...
        watchers: {
            webpack: {
            poll: true
            }
        }
    }
   ```
6. Run the following command
    ```bash
    $ docker-compose up -d nuxt-dev
    ```

> :heavy_check_mark: Done, you should now have a Nuxt project up & running on Docker and reachable at [`localhost:3000`](http://localhost:3000)

#### VS code
In order to make use of the devcontainer functionality, follow the steps above and below:

1. Make sure that you have the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension installed in VS code.
2. In VS code, press **F1** and select the option **Remote-Containers: Rebuild Container**

Done, your VScode should now have installed the needed plugins and configured a development environment for you.

## Adding environmental variables
- If developing locally, place your environment variables within a file called `.env` in a `<key>=<value>` format.
- If developing within a container, place your environment variables within a file called `.env.docker` in a `<key>=<value>` format.

> :bulb: Environmental variables for local & container-based development are separated to reduce confusion.

## Commands
### Docker

> The service name can be:
> - `nuxt-dev` (Development container)
> - `nux-prod` (Production container)

|Command|Effect|
|---|---|
|`docker-compose up <service_name>`|Construct & runs the container.|
|`docker-compose build <service_name>`|Builds the image for the container.|
|`docker-compose stop <service_name>`| Stops the running container.|
|`docker-compose down <service_name>`| Stops and removes the running container

### NPM
|Command|Effect|
|---|---|
|`npm install`|Installs dependencies|
|`npm run dev`|Runs a hot-reload development server on [`localhost:3000`](http://localhost:3000)|
|`npm run build`|Builds a production version of the project|
|`npm run start`|Runs the production build of the project|

## Frequently Asked Questions

**Q:** How do I install new packages when working in a container? <br>
**A:** 
- **When working manually**, install the package on your host machine, bring the container offline using `docker-compose down <service_name>`, rebuild the image using `docker-compose build --no-cache <service_name>` and bring it back online using `docker-compose up -d <service_name>`.
- **When using VS code**, you can rebuild the container by pressing **F1** -> **Remote-Containers: Rebuild Container**.

**Q:** How does the multi-stage build work? <br>
**A:** The production image is created based upon the developer image, by building it within the developer container and transporting the files to an Alpine image. In my testing, image size went from 1,42 GB to about 600MB.
> :bulb: If this is still to big, you can try reducing it with [Dockerslim](https://dockersl.im/). My image size went from 600 MB to 495.06 MB, but your results may vary.
> ```bash
> $ docker-slim build --target <image_name_or_image_id> --include-path /opt/app --include-path /bin
> ```
