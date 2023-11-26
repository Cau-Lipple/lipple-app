import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lipple/interfaces/sentence_practice_interface.dart';

class PracticeDoVidPage extends StatefulWidget {
  const PracticeDoVidPage({super.key});

  @override
  State<PracticeDoVidPage> createState() => _PracticeDoVidPageState();
}

class _PracticeDoVidPageState extends State<PracticeDoVidPage> {
  final sentence =
  const SentencePractice(id: '0', title: '어제 힘들게 작성한 보고서를\n컴퓨터 오류로 날렸어.');

  CameraController? _controller;
  bool _isCameraInitialized = false;
  late final List<CameraDescription> _cameras;
  bool _isRecording = false;

  Future<void> initCamera() async {
    _cameras = await availableCameras();
    late CameraDescription frontCamera;
    try {
      frontCamera = _cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
      );
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium, // 선택한 해상도 설정
    );

    await _controller?.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  Future<void> _recordVideo() async {
    if (_isRecording) {
      final file = await _controller?.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });
    } else {
      await _controller?.prepareForVideoRecording();
      await _controller?.startVideoRecording();
      setState(() {
        _isRecording = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '문장 연습',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF1FC368),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45),
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text(
                '다음 문장을 따라 읽어보세요.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 15),
              child: Container(
                height: 80,
                width: 340,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    sentence.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 15),
                      child: Container(
                        height: 5.0,
                        width: 50.0,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1FC368),
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          ),
                        ),
                      ),
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            ClipRRect(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(35)),
                              child: SizedBox(
                                width: 370,
                                height: 380,
                                child: _isCameraInitialized
                                    ? CameraPreview(_controller!)
                                    : const CircularProgressIndicator(),
                              ),
                            ),
                            CustomPaint(
                              foregroundPainter: BorderPainter(),
                              child: const SizedBox(
                                width: 340,
                                height: 350,
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: -50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(5),
                                  backgroundColor: const Color(0xFFF9FAF4),
                                  surfaceTintColor: Colors.white,
                                  shadowColor: const Color(0xFF22BB66),
                                  elevation: 5,
                                ),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Color(0xFF22BB66),
                                  size: 40,
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 10),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await _recordVideo();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    padding: const EdgeInsets.all(15),
                                    backgroundColor: const Color(0xFF008040),
                                    foregroundColor: const Color(0xFF11AA55),
                                    shadowColor: const Color(0xFF9BF599),
                                    elevation: 7,
                                  ),
                                  child: _isRecording
                                      ? const Icon(
                                    Icons.mic,
                                    color: Colors.white,
                                    size: 60,
                                  )
                                      : const Icon(
                                    Icons.mic_none,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(5),
                                  backgroundColor: const Color(0xFFF9FAF4),
                                  surfaceTintColor: Colors.white,
                                  shadowColor: const Color(0xFF22BB66),
                                  elevation: 5,
                                ),
                                child: const Icon(
                                  Icons.refresh,
                                  color: Color(0xFF22BB66),
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height; // for convenient shortage
    double sw = size.width; // for convenient shortage
    double cornerSide = sh * 0.1; // desirable value for corners side

    Paint paint = Paint()
      ..color = const Color(0xFF1FC368)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Path path = Path()
      ..moveTo(cornerSide, 0)
      ..quadraticBezierTo(0, 0, 0, cornerSide)
      ..moveTo(0, sh - cornerSide)
      ..quadraticBezierTo(0, sh, cornerSide, sh)
      ..moveTo(sw - cornerSide, sh)
      ..quadraticBezierTo(sw, sh, sw, sh - cornerSide)
      ..moveTo(sw, cornerSide)
      ..quadraticBezierTo(sw, 0, sw - cornerSide, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BorderPainter oldDelegate) => false;
}
