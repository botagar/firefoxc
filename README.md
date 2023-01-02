# FireFoxC

## Host Setup and Configuration

NOTE: Only tested Ubuntu flavours 22.04 and above.

### Graphics and Windows

We need to ensure that the root user is allowed to open windows.
To do this, run the following command

```shell
xhost +si:localuser:root
```

Note, the above command needs to be execute each time the host is power cycled.

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

TODO: Explore modifying `/etc/pulse/default.pa` to load the network module instead of using paprefs - [Arch docs on PA](https://wiki.archlinux.org/title/PulseAudio/Examples#PulseAudio_over_network) | [Gist](https://gist.github.com/xarinatan/c415341ff34eab445cfb073988dcf6c1).

### Backups

TODO: Instructions on setting up the initial bootstrap AWS user.

Run the script `./setup-backups.sh`, input your sudo password when prompted.

This will setup an AWS S3 bucket, IAM user and cron job to backup your firefox profile every day.


## Firefox Profile(s) and Addons

The directory `.mozilla` contains 2 subdirectories: `firefox` and `extensions`.

`firefox` is the directory where firefox will store all profile data.

Any valid extensions in the `.xpi` format found in the `extensions` direcotry will be automatically installed on firefox startup.

## Downloads

Any files you download through this containerised firefox will be found in the `downloads` directory.

## Running the container

```shell
docker-compose build
```

```shell
docker-compose up -d
```

Enjoy~!

Suggestions and Feedback welcome.