# Creating and installing .pkg packages on macOS

Mockup project containing experiments with packaging and installing custom
jobs or deamons on macOS. Tasks are performed with standard macOS tools:
`pkgbuild` and `installer`.

## Usage

Build and install a mockup job which runs every minute and prints a timestamp
in a log file.

```sh
make build
make install
```

Build a script-only (no *payload*) package which can be used to unload the
LaunchDaemon and uninstall the job script and corresponding files (logs ecc.)

```sh
make build-uninstal
make uninstall
```

## Compatibility

These tools are expeted to work fine on macOS 11.x.

## Usefull commands

### Load/unload LaunchDaemon job

Bootstraps a service or directory of services and respectively unloads a
service or directory of services.

```sh
launchctl load /Library/LaunchDaemons/d76.mockup-job.plist
launchctl unload /Library/LaunchDaemons/d76.mockup-job.plist
```

### Forget an installed package

Discard receipt data for the specified package.

```sh
pkgutil --forget d76.mockup-job
```

### Force the execution of job/deamon

```sh
sudo launchctl kickstart system/d76.mockup-job
```

## Resources

### Manual pages

- man `pkgbuild`
- man `installer`
- man `pkgutil`
- man `launchctl`

### Links

- [Scripting OSX](https://scriptingosx.com/)
