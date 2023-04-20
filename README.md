# MoveMentor 💃🏻

> #### When Movement Meets Motication!

<p align="center">
    <img src="./assets/icon.png" width="200" height="200"/>
</p>

### Setup 🛠️

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

> \*\* To use Metal on iOS: Download the file from this PR: https://github.com/am15h/tflite_flutter_plugin/pull/200/files and follow the instructions here: https://github.com/am15h/tflite_flutter_plugin/wiki/Build-iOS-binaries-with-GPU-delegate

3. Install Flutter Dependencies

```sh
flutter pub get
```

4. Run

```
flutter run
```

### Model Specifications 👨🏻‍💻

- Using the MoveNet Lightning Single Pose Model
- Uses a 640x480 RGB image as input (Medium Resolution Preset for Android and iOS)
- Outputs an array with [x, y, confidence] (x, y are scaled according to the input image size)

### Similarity Calulcation

Angle Between Two Lines: [https://www.nagwa.com/en/explainers/407162748438/](https://www.nagwa.com/en/explainers/407162748438/)
