# Mockup macOS PKG

Mockup project containing experiments with packaging and installing custom
jobs or deamons on macOS. Tasks are performed with standard macOS tools
`pkgbuild` and `installer`.

## Usefull commands

### Load/unload LauncDaemon job

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

- [https://scriptingosx.com/](Scripting OSX)
