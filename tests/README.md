<a href="https://elest.io">
  <img src="https://elest.io/images/elestio.svg" alt="elest.io" width="150" height="75">
</a>

[![Discord](https://img.shields.io/static/v1.svg?logo=discord&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=Discord&message=community)](https://discord.gg/4T4JGaMYrD "Get instant assistance and engage in live discussions with both the community and team through our chat feature.")
[![Elestio examples](https://img.shields.io/static/v1.svg?logo=github&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=github&message=open%20source)](https://github.com/elestio-examples "Access the source code for all our repositories by viewing them.")
[![Blog](https://img.shields.io/static/v1.svg?color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=elest.io&message=Blog)](https://blog.elest.io "Latest news about elestio, open source software, and DevOps techniques.")

# Authentik, verified and packaged by Elestio

[Authentik](https://goauthentik.io/) is an open-source Identity Provider that emphasizes flexibility and versatility. It can be seamlessly integrated into existing environments to support new protocols. authentik is also a great solution for implementing sign-up, recovery, and other similar features in your application, saving you the hassle of dealing with them.

<img src="https://github.com/elestio-examples/authentik/raw/main/authentik.jpg" alt="Authentik" width="800">

Deploy a <a target="_blank" href="https://elest.io/open-source/authentik">fully managed Authentik</a> on <a target="_blank" href="https://elest.io/">elest.io</a> if you want automated backups, reverse proxy with SSL termination, firewall, automated OS & Software updates, and a team of Linux experts and open source enthusiasts to ensure your services are always safe, and functional.

[![deploy](https://github.com/elestio-examples/authentik/raw/main/deploy-on-elestio.png)](https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/authentik)

# Why use Elestio images?

- Elestio stays in sync with updates from the original source and quickly releases new versions of this image through our automated processes.
- Elestio images provide timely access to the most recent bug fixes and features.
- Our team performs quality control checks to ensure the products we release meet our high standards.

# Usage

## Git clone

You can deploy it easily with the following command:

    git clone https://github.com/elestio-examples/authentik.git

Copy the .env file from tests folder to the project directory

    cp ./tests/.env ./.env

Edit the .env file with your own values.

Create data folders with correct permissions

    mkdir -p ./pgdata
    chown -R 1000:1000 ./pgdata

Run the project with the following command

    docker-compose up -d
    ./scripts/postInstall.sh

You can access the Web UI at: `http://your-domain:9000`

## Docker-compose

Here are some example snippets to help you get started creating a container.

        ---
        version: "3.4"

        services:
        postgresql:
            image: elestio/postgres:15
            restart: always
            volumes:
            - ./pgsql:/var/lib/postgresql/data
            environment:
            POSTGRES_PASSWORD: ${PG_PASS}
            POSTGRES_USER: ${PG_USER}
            POSTGRES_DB: ${PG_DB}
            env_file:
            - .env
            ports:
            - 172.17.0.1:47601:5432
        redis:
            image: elestio/redis:6.0
            command: --save 60 1 --loglevel warning
            restart: always
            volumes:
            - ./redis:/data
        server:
            image: elestio4test/authentik-server:${SOFTWARE_VERSION_TAG}
            restart: always
            command: server
            environment:
            AUTHENTIK_REDIS__HOST: redis
            AUTHENTIK_POSTGRESQL__HOST: postgresql
            AUTHENTIK_POSTGRESQL__USER: ${PG_USER}
            AUTHENTIK_POSTGRESQL__NAME: ${PG_DB}
            AUTHENTIK_POSTGRESQL__PASSWORD: ${PG_PASS}
            volumes:
            - ./media:/media
            - ./custom-templates:/templates
            env_file:
            - .env
            ports:
            - "172.17.0.1:9000:9000"
            depends_on:
            - postgresql
            - redis
        worker:
            image: elestio4test/authentik-server:${SOFTWARE_VERSION_TAG}
            restart: always
            command: worker
            environment:
            AUTHENTIK_REDIS__HOST: redis
            AUTHENTIK_POSTGRESQL__HOST: postgresql
            AUTHENTIK_POSTGRESQL__USER: ${PG_USER}
            AUTHENTIK_POSTGRESQL__NAME: ${PG_DB}
            AUTHENTIK_POSTGRESQL__PASSWORD: ${PG_PASS}
            user: root
            volumes:
            - /var/run/docker.sock:/var/run/docker.sock
            - ./media:/media
            - ./certs:/certs
            - ./backups:/backups
            - ./custom-templates:/templates
            env_file:
            - .env
            depends_on:
            - postgresql
            - redis

        pgadmin:
            image: elestio/pgadmin:latest
            restart: always
            environment:
            PGADMIN_DEFAULT_EMAIL: ${ADMIN_EMAIL}
            PGADMIN_DEFAULT_PASSWORD: ${ADMIN_PASSWORD}
            PGADMIN_LISTEN_PORT: 8080
            ports:
            - "172.17.0.1:27287:8080"
            volumes:
            - ./servers.json:/pgadmin4/servers.json


### Environment variables

|           Variable           |         Value (example)            |
| :--------------------------: | :--------------------------------: |
|     SOFTWARE_VERSION_TAG     |            latest                  |
|        ADMIN_PASSWORD        |         your-password              |
|     AUTHENTIK_SECRET_KEY     |         your-secret                |

# Maintenance

## Logging

The Elestio Authentik Docker image sends the container logs to stdout. To view the logs, you can use the following command:

    docker-compose logs -f

To stop the stack you can use the following command:

    docker-compose down

## Backup and Restore with Docker Compose

To make backup and restore operations easier, we are using folder volume mounts. You can simply stop your stack with docker-compose down, then backup all the files and subfolders in the folder near the docker-compose.yml file.

Creating a ZIP Archive
For example, if you want to create a ZIP archive, navigate to the folder where you have your docker-compose.yml file and use this command:

    zip -r myarchive.zip .

Restoring from ZIP Archive
To restore from a ZIP archive, unzip the archive into the original folder using the following command:

    unzip myarchive.zip -d /path/to/original/folder

Starting Your Stack
Once your backup is complete, you can start your stack again with the following command:

    docker-compose up -d

That's it! With these simple steps, you can easily backup and restore your data volumes using Docker Compose.

# Links

- <a target="_blank" href="https://goauthentik.io/docs/">Authentik documentation</a>

- <a target="_blank" href="https://github.com/goauthentik/authentik">Authentik Github repository</a>

- <a target="_blank" href="https://github.com/elestio-examples/authentik">Elestio/Authentik Github repository</a>
