[![style: lint](https://img.shields.io/badge/style-lint-4BC0F5.svg)](https://pub.dev/packages/lint)

# UNICE

Unice is a Mobile app for video/audio calling and translation.

## Installation

First you need to setup flutter on your system. This link will guide you how to do
that. [Install Flutter](https://flutter.dev/docs/get-started/install)

After install check if your installation is successful or not by running this command in terminal /
cmd.

```bash
flutter doctor -v
```

After setting up the environment clone this project to your desired location.

```bash
git clone https://bitbucket.org/rnssol/unice-app.git
```

After cloning move to the installation folder and run

```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

Code setup is compleded at this stage.

## Usage

For building the android and iOS builds for each one of them is given below

```bash
flutter build apk  --release   // For android
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would
like to change.
