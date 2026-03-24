fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios build

```sh
[bundle exec] fastlane ios build
```

Build the app to check for compilation errors

### ios unit_tests

```sh
[bundle exec] fastlane ios unit_tests
```

Run unit tests

### ios ui_tests

```sh
[bundle exec] fastlane ios ui_tests
```

Run UI tests

### ios all_tests

```sh
[bundle exec] fastlane ios all_tests
```

Run all tests (unit + UI)

### ios ci

```sh
[bundle exec] fastlane ios ci
```

Full CI pipeline: build + all tests

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
