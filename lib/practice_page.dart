import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lipple/interfaces/sentence_practice_interface.dart';
import 'package:video_player/video_player.dart';

class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  final sentence =
      const SentencePractice(id: '0', title: '어제 힘들게 작성한 보고서를\n컴퓨터 오류로 날렸어.');
  var isBookmark = false; //TODO: db와 연결작업
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
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
      body: Container(
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
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
                          color: isBookmark ? Color(0xFFF4D509) : Colors.grey,
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
                          Icons.arrow_forward,
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
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
