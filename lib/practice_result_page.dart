import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lipple/interfaces/sentence_practice_interface.dart';
import 'package:video_player/video_player.dart';

class PracticeResultPage extends StatefulWidget {
  const PracticeResultPage({
    required this.sentence,
    required this.file,
    super.key,
  });

  final SentencePractice sentence;
  final XFile file;

  @override
  State<PracticeResultPage> createState() => _PracticeResultPageState();
}

class _PracticeResultPageState extends State<PracticeResultPage> {
  // final sentence =
  //     const SentencePractice(id: 0, name: '어제 힘들게 작성한 보고서를\n컴퓨터 오류로 날렸어.');

  var isBookmark = false; //TODO: db와 연결작업
  late SentencePractice sentence;
  late XFile file;
  late VideoPlayerController _controller;
  final practiceDoPath = '/bookmark/practice-do';

  @override
  void initState() {
    super.initState();
    sentence = widget.sentence;
    file = widget.file;
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
          _controller.addListener(() {
            if (_controller.value.position == _controller.value.duration) {
              _controller.seekTo(const Duration(seconds: 0));
              _controller.pause();
              setState(() {});
            }
          });
        });
      });
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
      body: Builder(builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 10),
              margin:
                  const EdgeInsets.symmetric(vertical: 160.0, horizontal: 25),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Color(0xFF7AB4FD),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: const Color(0xFFD2E9FE),
              content: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: const Color(0xFF2271F9),
                          borderRadius: BorderRadius.circular(15)),
                      child: const Icon(
                        Icons.sentiment_satisfied_alt_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  const Text(
                    "80점, 좋은 발음입니다!",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
        return Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF1FC368),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 230,
                  width: 330,
                  child: _controller.value.isInitialized
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (_controller.value.isPlaying) {
                                  _controller.pause();
                                } else {
                                  _controller.play();
                                }
                                setState(() {});
                              },
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(25)),
                                child: AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: Stack(
                                    children: [
                                      VideoPlayer(_controller),
                                      if (!_controller.value.isPlaying)
                                        Container(
                                          color: Colors.black.withOpacity(0.4),
                                          child: const Center(
                                            child: Icon(
                                              Icons.play_arrow_rounded,
                                              color: Color(0xFFE0E0E0),
                                              size: 80,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 16.0,
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(50),
                                  right: Radius.circular(50),
                                ),
                                child: VideoProgressIndicator(
                                  _controller,
                                  allowScrubbing: true,
                                  colors: const VideoProgressColors(
                                    playedColor: Colors.white,
                                    backgroundColor: Color(0x37C6ECC6),
                                    bufferedColor: Color(0x5FC6ECC6),
                                  ),
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ],
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                          color: Colors.white,
                        )),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 40.0, bottom: 20.0),
                  child: SizedBox(
                    width: 340,
                    child: AspectRatio(
                      aspectRatio: 3.3,
                      child: LineChart(
                        LineChartData(
                          backgroundColor: const Color(0x33008040),
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            horizontalInterval: 20,
                            getDrawingHorizontalLine: (value) {
                              return const FlLine(
                                color: const Color(0x55008040),
                                strokeWidth: 1,
                              );
                            },
                            getDrawingVerticalLine: (value) {
                              return const FlLine(
                                color: Colors.transparent,
                                strokeWidth: 1,
                              );
                            },
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: const AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget:
                                    (double value, TitleMeta meta) {
                                  const style = TextStyle(
                                    color: Colors.white,
                                  );
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    child: Text(value.toInt().toString(),
                                        style: style),
                                  );
                                },
                                interval: 20,
                                reservedSize: 42,
                              ),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: false,
                            border: Border.all(color: const Color(0x0037434d)),
                          ),
                          minX: 0,
                          maxX: 10,
                          minY: 0,
                          maxY: 100,
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 80),
                                FlSpot(2, 90),
                                FlSpot(4, 60),
                                FlSpot(6, 30),
                                FlSpot(8, 85),
                                FlSpot(10, 79),
                              ],
                              isCurved: true,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) {
                                  Color dotColor = spot.y > 70
                                      ? const Color(0xFF5FBA32)
                                      : (spot.y > 40
                                          ? const Color(0xFFF2D309)
                                          : const Color(0xFFE96265));

                                  return FlDotCirclePainter(
                                    color: dotColor,
                                    strokeColor: const Color(0xFF008040),
                                    strokeWidth: 2.5,
                                  );
                                },
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                color: const Color(0x66008040),
                              ),
                              color: const Color(0xFF008040),
                            ),
                          ],
                          lineTouchData: const LineTouchData(
                            touchTooltipData: LineTouchTooltipData(
                              tooltipBgColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 110,
                  width: 340,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      sentence.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Opacity(
                          opacity: 0.0,
                          child: ElevatedButton(
                            onPressed: null,
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
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                            context.pop();
                          },
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 7,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: SizedBox(
                              height: 120,
                              width: 120,
                              child: UnconstrainedBox(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0x889BF599),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  height: 100,
                                  width: 100,
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 5.0, sigmaY: 5.0),
                                    child: FractionallySizedBox(
                                      widthFactor: 0.9,
                                      heightFactor: 0.9,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_controller.value.isPlaying) {
                                            _controller.pause();
                                          } else {
                                            _controller.play();
                                          }
                                          setState(() {});
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: const CircleBorder(),
                                          padding: const EdgeInsets.all(15),
                                          backgroundColor:
                                              const Color(0xFF008040),
                                          foregroundColor:
                                              const Color(0xFF11AA55),
                                          shadowColor: const Color(0xFF9BF599),
                                          elevation: 7,
                                        ),
                                        child: _controller.value.isPlaying
                                            ? const Icon(
                                                Icons.pause,
                                                color: Colors.white,
                                                size: 60,
                                              )
                                            : const Icon(
                                                Icons.play_arrow,
                                                color: Colors.white,
                                                size: 60,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            isBookmark = !isBookmark;
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(5),
                            backgroundColor: const Color(0xFFF9FAF4),
                            surfaceTintColor: Colors.white,
                            shadowColor: const Color(0xFF22BB66),
                            elevation: 5,
                          ),
                          child: Icon(
                            Icons.star,
                            color: isBookmark
                                ? const Color(0xFFF4D509)
                                : Colors.grey,
                            size: 40,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                            // context.go(practiceDoPath);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(5),
                            backgroundColor: const Color(0xFFF9FAF4),
                            surfaceTintColor: Colors.white,
                            shadowColor: const Color(0xFF22BB66),
                            elevation: 5,
                          ),
                          child: const Icon(
                            Icons.double_arrow,
                            color: Color(0xFF22BB66),
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
