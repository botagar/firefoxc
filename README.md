# FireFoxC

## Host Setup and Configuration

NOTE: Only tested on Kubuntu 20.04

### Graphics and Windows

We need to ensure that the root user is allowed to open windows.
To do this, run the following command

```shell
xhost +si:localuser:root
```

### Audio

We need to ensure that pulse audio network mode is enabled and allows connections over localhost.

The simplest way to do this is to install `paprefs` and enable the network server through it.

```shell
sudo apt-get install paprefs
```

Run `paprefs` and select the "Network Server" tab.

Enable:
* Network access to local sound devices
  * Allow other machines on the LAN to discover local sound devices
  * Don't require authentication

### Firefox Profile(s)

Create a directory at the same level as the `docker-compose.yml` file called `.mozilla`.

When the container starts up, it will use that directory for all it's profile needs.

## Running the container

```shell
docker-compose build
```

```shell
docker-compose up
```