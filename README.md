# MoveMentor 💃🏻

> #### When Movement Meets Motication!

### Setup

Pre-Requisites: Flutter >= 3.7

1. Install TFLite dependencies for Android

> Linux / MacOS

```sh
sh install.sh -d
```

> Windows

```sh
install.bat -d
```

2. Install TFLite dependencies for iOS

- Download this file: [TensorFlowLiteC.framework](https://github.com/am15h/tflite_flutter_plugin/releases/download/v0.5.0/TensorFlowLiteC.framework.zip)
- Place the `TensorFlowLiteC.framework` file in the `pub-cache` folder of the `tflite_flutter` package

> - Linux/ Mac => ~/.pub-cache/hosted/pub.dev/tflite_flutter-<version>/ios/
> - Windows => %LOCALAPPDATA%\Pub\Cache\hosted\pub.dev\tflite_flutter-<version>\ios\

> ** To use Metal on iOS: Download the file from this PR: https://github.com/am15h/tflite_flutter_plugin/pull/200/files and follow the instructions here: https://github.com/am15h/tflite_flutter_plugin/wiki/Build-iOS-binaries-with-GPU-delegate

3. Install Flutter Dependencies

```sh
flutter pub get
```

4. Run

```
flutter run
```
