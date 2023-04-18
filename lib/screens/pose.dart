import 'dart:isolate';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../tensorflow/interpreter.dart';
import '../tensorflow/isolate_util.dart';

class PoseScreen extends StatefulWidget {
  const PoseScreen({Key? key}) : super(key: key);

  @override
  PoseScreenState createState() => PoseScreenState();
}

class PoseScreenState extends State<PoseScreen> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  late Classifier classifier;
  late IsolateUtils isolate;

  bool predicting = false;
  bool initialized = false;
  late List<dynamic> inferences;
  double paddingX = 0;
  double paddingY = 0;

  @override
  void initState() {
    super.initState();
    initAsync();
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  void initAsync() async {
    List<CameraDescription> cameras = await availableCameras();
    isolate = IsolateUtils();
    await isolate.start();
    classifier = Classifier();
    classifier.loadModel();
    loadCamera(cameras);
  }

  void loadCamera(List<CameraDescription> cameras) {
    setState(() {
      cameraController = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.bgra8888,
      );
    });
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      } else {
        cameraController!.startImageStream((imageStream) {
          createIsolate(imageStream);
        });
      }
    });
  }

  void createIsolate(CameraImage imageStream) async {
    if (predicting == true) {
      return;
    }

    setState(() {
      predicting = true;
    });

    var isolateData = IsolateData(imageStream, classifier.interpreter.address);
    List<dynamic> inferenceResults = await inference(isolateData);

    setState(() {
      inferences = inferenceResults;
      predicting = false;
      initialized = true;
    });
  }

  Future<List<dynamic>> inference(IsolateData isolateData) async {
    ReceivePort responsePort = ReceivePort();
    isolate.sendPort.send(isolateData..responsePort = responsePort.sendPort);
    var results = await responsePort.first;
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: paddingX,
              vertical: paddingY,
            ),
            child: initialized
                ? SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: CustomPaint(
                      foregroundPainter: RenderLandmarks(inferences),
                      child: !cameraController!.value.isInitialized
                          ? Container()
                          : AspectRatio(
                              aspectRatio: cameraController!.value.aspectRatio,
                              child: CameraPreview(cameraController!),
                            ),
                    ),
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}

class RenderLandmarks extends CustomPainter {
  late List<dynamic> inferenceList;
  late PointMode pointMode;
  final double showPointConfidence = 0.2;
  final double correctPointConfidence = 0.4;
  double paddingX = 0;
  double paddingY = 10;

  var pointGreen = Paint()
    ..color = Colors.green
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 6;

  var edgeGreen = Paint()
    ..color = Colors.lightGreen
    ..strokeWidth = 3;

  // INCORRECT POSTURE COLOR PROFILE
  var pointRed = Paint()
    ..color = Colors.red.shade900
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 6;

  var edgeRed = Paint()
    ..color = Colors.red.shade300
    ..strokeWidth = 3;

  List<Offset> pointsGreen = [];
  List<Offset> pointsRed = [];

  List<dynamic> edges = [
    [0, 1], // nose to left_eye
    [0, 2], // nose to right_eye
    [1, 3], // left_eye to left_ear
    [2, 4], // right_eye to right_ear
    [0, 5], // nose to left_shoulder
    [0, 6], // nose to right_shoulder
    [5, 7], // left_shoulder to left_elbow
    [7, 9], // left_elbow to left_wrist
    [6, 8], // right_shoulder to right_elbow
    [8, 10], // right_elbow to right_wrist
    [5, 6], // left_shoulder to right_shoulder
    [5, 11], // left_shoulder to left_hip
    [6, 12], // right_shoulder to right_hip
    [11, 12], // left_hip to right_hip
    [11, 13], // left_hip to left_knee
    [13, 15], // left_knee to left_ankle
    [12, 14], // right_hip to right_knee
    [14, 16] // right_knee to right_ankle
  ];
  RenderLandmarks(List<dynamic> inferences) {
    inferenceList = inferences;
  }
  @override
  void paint(Canvas canvas, Size size) {
    renderEdge(canvas, true);
    canvas.drawPoints(PointMode.points, pointsGreen, pointGreen);
    canvas.drawPoints(PointMode.points, pointsRed, pointRed);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void renderEdge(Canvas canvas, bool isCorrect) {
    for (List<dynamic> point in inferenceList) {
      if (point[2] > showPointConfidence) {
        if (point[2] < correctPointConfidence) {
          pointsRed.add(
            Offset(
              point[0].toDouble() - (paddingX + 40),
              point[1].toDouble() - (paddingY - 70),
            ),
          );
        } else {
          pointsGreen.add(
            Offset(
              point[0].toDouble() - (paddingX + 40),
              point[1].toDouble() - (paddingY - 70),
            ),
          );
        }
      }
    }

    for (List<int> edge in edges) {
      if (inferenceList[edge[0]][2] > showPointConfidence &&
          inferenceList[edge[1]][2] > showPointConfidence) {
        double vertex1X = inferenceList[edge[0]][0].toDouble() - (paddingX + 40);
        double vertex1Y = inferenceList[edge[0]][1].toDouble() - (paddingY - 70);
        double vertex2X = inferenceList[edge[1]][0].toDouble() - (paddingX + 40);
        double vertex2Y = inferenceList[edge[1]][1].toDouble() - (paddingY - 70);
        final point1Confidence = inferenceList[edge[0]][2];
        final point2Confidence = inferenceList[edge[1]][2];
        // debugPrint("p1: $point1Confidence, p2: $point2Confidence");
        if (point1Confidence > correctPointConfidence &&
            point2Confidence > correctPointConfidence) {
          canvas.drawLine(
              Offset(vertex1X, vertex1Y), Offset(vertex2X, vertex2Y), edgeGreen);
        } else {
          canvas.drawLine(
              Offset(vertex1X, vertex1Y), Offset(vertex2X, vertex2Y), edgeRed);
        }
      }
    }
  }
}
