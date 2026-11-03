# Reqmir

A tool that shows the URLSession traffic of apps running in the iOS Simulator on your Mac, live, as a list with details.

- **Reqmir**: the Mac app that receives and displays the traffic
- **ReqmirKit**: a library loaded into the target app at runtime that captures its traffic and sends it to Reqmir. The target app's project is left unchanged

> [!NOTE]
> Development has just started, and nothing works yet.

## Requirements

- Xcode 27.1 (installed under `/Applications`; the app name does not matter)
- An iOS 27 simulator runtime with an "iPhone 18 Pro" device (the default for `make test-ios`)

You don't need to change your `xcode-select` setting. `make` looks up the Xcode whose version matches `.xcode-version` and passes it via `DEVELOPER_DIR`. To use an Xcode installed elsewhere, set `DEVELOPER_DIR` yourself.

## Usage

```sh
make help     # list the targets
make doctor   # show the Xcode, Swift, and simulators in use
make build    # build the Swift package
make test     # run the tests on macOS
make test-ios # run the tests on the iOS simulator (override with IOS_DEVICE / IOS_OS)
```

## License

[MIT](LICENSE)
