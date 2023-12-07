import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lipple/interfaces/result_interface.dart';
import 'package:lipple/interfaces/sentence_practice_interface.dart';
import 'package:lipple/providers/bookmark_provider.dart';
import 'package:lipple/widgets/snack_bar_good.dart';
import 'package:lipple/widgets/snack_bar_great.dart';
import 'package:lipple/widgets/snack_bar_ok.dart';
import 'package:provider/provider.dart';
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

class _PracticeResultPageState extends State<PracticeResultPage>
    with TickerProviderStateMixin {
  // final sentence =
  //     const SentencePractice(id: 0, name: '어제 힘들게 작성한 보고서를\n컴퓨터 오류로 날렸어.');
  final dio = Dio();
  final practiceDoPath = '/bookmark/practice-do';
  final homePagePath = '/';
  final messages = [
    ["자음을 첫소리로 가지고 있는 음절의 'ㅢ'는 [ㅣ]로 발음한다.", "무늬[무니] 띄어쓰기[띠어쓰기] 희망[히망]"],
    [
      "단어의 첫음절 이외의 '의'는 [ㅣ]로, 조사 '의'는 [ㅔ]로 발음함도 허용한다.",
      "주의[주의/주이] 우리의[우리의/우리에]"
    ],
    ["받침소리로는 'ㄱ, ㄴ, ㄷ, ㄹ, ㅁ, ㅂ, ㅇ'의 7개 자음만 발음한다.", ""],
    [
      "받침 'ㄲ, ㅋ', 'ㅅ, ㅆ, ㅈ, ㅊ, ㅌ', 'ㅍ'은 어말 또는 자음 앞에서 각각 대표음 [ㄱ, ㄷ, ㅂ]으로 발음한다.",
      "키읔[키윽] 옷[옫] 꽃[꼳]"
    ],
    [
      "홑받침이나 쌍받침이 모음으로 시작된 조사나 어미, 접미사와 결합되는 경우에는, 제 음가대로 뒤 음절 첫소리로 옮겨 발음한다.",
      "깎아[까까] 꽃을[꼬츨] 밭에[바테]"
    ],
    [
      "겹받침이 모음으로 시작된 조사나 어미, 접미사와 결합되는 경우에는, 뒤엣것만을 뒤 음절 첫소리로 옮겨 발음한다. (이 경우, 'ㅅ'은 된소리로 발음함.)",
      "넋이[넉씨] 닭을[달글] 앉아[안자]"
    ],
    [
      "받침 'ㄷ, ㅌ(ㄾ)'이 조사나 접미사의 모음 'ㅣ'와 결합되는 경우에는, [ㅈ, ㅊ]으로 바꾸어서 뒤 음절 첫소리로 옮겨 발음한다.",
      "굳이[구지] 밭이[바치] 미닫이[미다지]"
    ],
    [
      "받침 'ㄱ(ㄲ, ㅋ, ㄳ, ㄺ), ㄷ(ㅅ, ㅆ, ㅈ, ㅊ, ㅌ, ㅎ), ㅂ(ㅍ, ㄼ, ㄿ, ㅄ)'은 'ㄴ, ㅁ' 앞에서 [ㅇ, ㄴ, ㅁ]으로 발음한다.",
      "국물[궁물] 닫는[단는] 밟는[밤는]"
    ],
    [
      "받침 'ㅁ, ㅇ' 뒤에 연결되는 'ㄹ'은 [ㄴ]으로 발음한다.\n 받침 'ㄱ, ㅂ' 뒤에 연결되는 'ㄹ'도 [ㄴ]으로 발음한다.",
      "담력[담녁] 강릉[강능] 협력[혐녁]"
    ],
    ["'ㄴ'은 'ㄹ'의 앞이나 뒤에서 [ㄹ]로 발음한다.", "난로[날로] 칼날[칼랄] 줄넘기[줄럼끼]"],
    [
      "받침 'ㄱ(ㄲ, ㅋ, ㄳ, ㄺ), ㄷ(ㅅ, ㅆ, ㅈ, ㅊ, ㅌ), ㅂ(ㅍ, ㄼ, ㄿ, ㅄ)' 뒤에 연결되는 'ㄱ, ㄷ, ㅂ, ㅅ, ㅈ'은 된소리로 발음한다.",
      "국밥[국빱] 깎다[깎따] 꽃다발[꼳따발]"
    ],
    [
      "합성어 및 파생어에서, 앞 단어나 접두사의 끝이 자음이고 뒤 단어나 접미사의 첫 음절이 '이, 야, 여, 요, 유'인 경우에는, 'ㄴ'소리를 첨가하여 [니, 냐, 녀, 뇨, 뉴]로 발음한다.",
      "솜이불[솜니불] 한여름[한녀름] 담요[담뇨]"
    ]
  ];

  bool isBookmark = false;
  late SentencePractice sentence;
  late XFile file;
  late VideoPlayerController _controller;
  late Future<Result> practiceResult;
  bool initialized = false;
  bool snackbarExecuted = false;
  late AnimationController loadingController;
  String randomMessage = "자음을 첫소리로 가지고 있는 음절의 'ㅢ'는 [ㅣ]로 발음한다.";
  String randomExample = "무늬[무니] 띄어쓰기[띠어쓰기] 희망[히망]";

  Future<bool> setBookmark() async {
    return context.read<BookmarkProvider>().bookmarks.contains(sentence.id);
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    //
    // List<String> dbList = (prefs.getStringList('bookmark') ?? []);
    // List<int> originalList = dbList.map((i) => int.parse(i)).toList();
    // return originalList.contains(sentence.id);
  }

  Future<Result> fetchResult() async {
    var url = 'http://10.210.60.160:8080/evaluate';

    File vidFile = File(file.path);
    FormData formData = FormData.fromMap({
      "videoId": sentence.id.toString(),
      "body": await MultipartFile.fromFile(vidFile.path),
    });

    final response = await dio.post(url, data: formData);
    if (response.statusCode == 200) {
      return Result.fromJson(response.data);
    } else {
      throw Exception('Cannot get results.');
    }
  }

  @override
  void initState() {
    super.initState();
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {});
      });
    loadingController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        int randNum = Random().nextInt(messages.length);
        randomMessage = messages[randNum][0];
        randomExample = messages[randNum][1];
        loadingController.reset();
        loadingController.forward();
      }
    });
    loadingController.forward();
    sentence = widget.sentence;
    file = widget.file;
    setBookmark().then((value) => isBookmark = value);
    _controller = VideoPlayerController.file(File(widget.file.path))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.addListener(() {
            if (_controller.value.position == _controller.value.duration) {
              _controller.seekTo(const Duration(seconds: 0));
              _controller.pause();
              setState(() {});
            }
          });
        });
      });
    practiceResult = fetchResult();
    initialized = true;
    setState(() {});
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
        child: initialized
            ? FutureBuilder<Result>(
                future: practiceResult,
                builder:
                    (BuildContext context, AsyncSnapshot<Result> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '데이터 분석중입니다.',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: LinearProgressIndicator(
                              value: loadingController.value,
                              semanticsLabel: 'Linear progress indicator',
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              "<한국어 표준 발음법> 함께 공부해보아요!",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 40.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                width: 400,
                                height: 100,
                                color: Colors.white,
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    randomMessage,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15)),
                            child: Container(
                              width: 300,
                              height: 50,
                              color: Colors.black45,
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  randomExample,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    Result result = snapshot.data!;
                    if (result.isFace == false) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.sentiment_very_dissatisfied_rounded,
                              color: Colors.white,
                              size: 70,
                            ),
                            const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                '얼굴이 인식되지 않았습니다. 다시 시도해보세요.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => context.pop(),
                              child: const Icon(Icons.refresh),
                            )
                          ],
                        ),
                      );
                    }
                    if (snackbarExecuted == false) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          snackbarExecuted = true;
                          double score = result.totalScore;
                          ScaffoldMessenger.of(context).showSnackBar(score > 70
                              ? SnackBarGreat(score)
                              : (score > 40
                                  ? SnackBarGood(score)
                                  : SnackBarOk(score)));
                        },
                      );
                    }
                    return Padding(
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
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(25)),
                                          child: SizedBox(
                                            width: 330,
                                            height: 200,
                                            child: OverflowBox(
                                              alignment: Alignment.center,
                                              maxHeight: double.infinity,
                                              child: AspectRatio(
                                                aspectRatio: _controller
                                                    .value.aspectRatio,
                                                child: Stack(
                                                  children: [
                                                    Transform.scale(
                                                        scaleX: -1,
                                                        child: VideoPlayer(
                                                            _controller)),
                                                    if (!_controller
                                                        .value.isPlaying)
                                                      Container(
                                                        color: Colors.black
                                                            .withOpacity(0.4),
                                                        child: const Center(
                                                          child: Icon(
                                                            Icons
                                                                .play_arrow_rounded,
                                                            color: Color(
                                                                0xFFE0E0E0),
                                                            size: 80,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
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
                                          borderRadius:
                                              const BorderRadius.horizontal(
                                            left: Radius.circular(50),
                                            right: Radius.circular(50),
                                          ),
                                          child: VideoProgressIndicator(
                                            _controller,
                                            allowScrubbing: true,
                                            colors: const VideoProgressColors(
                                              playedColor: Colors.white,
                                              backgroundColor:
                                                  Color(0x37C6ECC6),
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
                            padding: const EdgeInsets.only(right: 40.0),
                            child: SizedBox(
                              width: 340,
                              child: AspectRatio(
                                aspectRatio: 3.3,
                                child: LineChart(
                                  LineChartData(
                                    gridData: FlGridData(
                                      show: true,
                                      drawVerticalLine: true,
                                      horizontalInterval: 20,
                                      getDrawingHorizontalLine: (value) {
                                        return const FlLine(
                                          color: Color(0x77008040),
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
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                      topTitles: const AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false),
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
                                              child: Text(
                                                  value.toInt().toString(),
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
                                      border: Border.all(
                                          color: const Color(0x0037434d)),
                                    ),
                                    minX: 0,
                                    maxX: 10,
                                    minY: 0,
                                    maxY: 100,
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: [
                                          FlSpot(0, result.soundScore[0]),
                                          FlSpot(5, result.soundScore[1]),
                                          FlSpot(10, result.soundScore[2]),
                                        ],
                                        isCurved: true,
                                        barWidth: 3,
                                        isStrokeCapRound: true,
                                        dotData: FlDotData(
                                          show: true,
                                          getDotPainter:
                                              (spot, percent, barData, index) {
                                            Color dotColor = spot.y > 70
                                                ? const Color(0xFF589AFB)
                                                : (spot.y > 40
                                                    ? const Color(0xFFF7E144)
                                                    : const Color(0xFFFF7190));

                                            return FlDotCirclePainter(
                                              color: dotColor,
                                              strokeColor:
                                                  const Color(0xFF008040),
                                              strokeWidth: 2.5,
                                            );
                                          },
                                        ),
                                        belowBarData: BarAreaData(
                                          show: true,
                                          color: const Color(0x66A4F9C8),
                                        ),
                                        color: const Color(0xFFA4F9C8),
                                      ),
                                      LineChartBarData(
                                        spots: [
                                          FlSpot(0, result.videoScore[0]),
                                          FlSpot(5, result.videoScore[1]),
                                          FlSpot(10, result.videoScore[2]),
                                        ],
                                        isCurved: true,
                                        barWidth: 3,
                                        isStrokeCapRound: true,
                                        dotData: FlDotData(
                                          show: true,
                                          getDotPainter:
                                              (spot, percent, barData, index) {
                                            Color dotColor = spot.y > 70
                                                ? const Color(0xFF589AFB)
                                                : (spot.y > 40
                                                    ? const Color(0xFFF7E144)
                                                    : const Color(0xFFFF7190));

                                            return FlDotCirclePainter(
                                              color: dotColor,
                                              strokeColor:
                                                  const Color(0xFF008040),
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
                                    lineTouchData: LineTouchData(
                                      touchTooltipData: LineTouchTooltipData(
                                        tooltipBgColor: Colors.black54,
                                        getTooltipItems: (List<LineBarSpot>
                                            touchedBarSpots) {
                                          return touchedBarSpots.map((barSpot) {
                                            return LineTooltipItem(
                                                barSpot.y.toStringAsFixed(2),
                                              TextStyle(
                                                color: barSpot.bar.color,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          }).toList();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 50.0, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Icon(
                                    Icons.circle,
                                    color: Color(0xFFA4F9C8),
                                    size: 12,
                                  ),
                                ),
                                Text('Voice'),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Icon(
                                    Icons.circle,
                                    color: Color(0xFF008040),
                                    size: 12,
                                  ),
                                ),
                                Text('Video')
                              ],
                            ),
                          ),
                          Container(
                            height: 110,
                            width: 340,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
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
                                        backgroundColor:
                                            const Color(0xFFF9FAF4),
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
                                              borderRadius:
                                                  BorderRadius.circular(50),
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
                                                    if (_controller
                                                        .value.isPlaying) {
                                                      _controller.pause();
                                                    } else {
                                                      _controller.play();
                                                    }
                                                    setState(() {});
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape: const CircleBorder(),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    backgroundColor:
                                                        const Color(0xFF008040),
                                                    foregroundColor:
                                                        const Color(0xFF11AA55),
                                                    shadowColor:
                                                        const Color(0xFF9BF599),
                                                    elevation: 7,
                                                  ),
                                                  child: _controller
                                                          .value.isPlaying
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
                                      if (isBookmark) {
                                        context
                                            .read<BookmarkProvider>()
                                            .addBookmark(sentence.id);
                                      } else {
                                        context
                                            .read<BookmarkProvider>()
                                            .removeBookmark(sentence.id);
                                      }
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
                                      context.go(homePagePath);
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
                    );
                  }
                },
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '데이터 분석중입니다.',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: LinearProgressIndicator(
                        value: loadingController.value,
                        semanticsLabel: 'Linear progress indicator',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        randomMessage,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

        // Padding(
        //   padding: const EdgeInsets.only(top: 20),
        //   child: Column(
        //     children: [
        //       SizedBox(
        //         height: 230,
        //         width: 330,
        //         child: _controller.value.isInitialized
        //             ? Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   GestureDetector(
        //                     onTap: () {
        //                       if (_controller.value.isPlaying) {
        //                         _controller.pause();
        //                       } else {
        //                         _controller.play();
        //                       }
        //                       setState(() {});
        //                     },
        //                     child: ClipRRect(
        //                       borderRadius:
        //                           const BorderRadius.all(Radius.circular(25)),
        //                       child: AspectRatio(
        //                         aspectRatio: _controller.value.aspectRatio,
        //                         child: Stack(
        //                           children: [
        //                             VideoPlayer(_controller),
        //                             if (!_controller.value.isPlaying)
        //                               Container(
        //                                 color: Colors.black.withOpacity(0.4),
        //                                 child: const Center(
        //                                   child: Icon(
        //                                     Icons.play_arrow_rounded,
        //                                     color: Color(0xFFE0E0E0),
        //                                     size: 80,
        //                                   ),
        //                                 ),
        //                               ),
        //                           ],
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                   Padding(
        //                     padding: const EdgeInsets.symmetric(
        //                       vertical: 10.0,
        //                       horizontal: 16.0,
        //                     ),
        //                     child: ClipRRect(
        //                       borderRadius: const BorderRadius.horizontal(
        //                         left: Radius.circular(50),
        //                         right: Radius.circular(50),
        //                       ),
        //                       child: VideoProgressIndicator(
        //                         _controller,
        //                         allowScrubbing: true,
        //                         colors: const VideoProgressColors(
        //                           playedColor: Colors.white,
        //                           backgroundColor: Color(0x37C6ECC6),
        //                           bufferedColor: Color(0x5FC6ECC6),
        //                         ),
        //                         padding: EdgeInsets.zero,
        //                       ),
        //                     ),
        //                   ),
        //                 ],
        //               )
        //             : const Center(
        //                 child: CircularProgressIndicator(
        //                 color: Colors.white,
        //               )),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.only(right: 40.0, bottom: 20.0),
        //         child: SizedBox(
        //           width: 340,
        //           child: AspectRatio(
        //             aspectRatio: 3.3,
        //             child: LineChart(
        //               LineChartData(
        //                 backgroundColor: const Color(0x33008040),
        //                 gridData: FlGridData(
        //                   show: true,
        //                   drawVerticalLine: true,
        //                   horizontalInterval: 20,
        //                   getDrawingHorizontalLine: (value) {
        //                     return const FlLine(
        //                       color: Color(0x55008040),
        //                       strokeWidth: 1,
        //                     );
        //                   },
        //                   getDrawingVerticalLine: (value) {
        //                     return const FlLine(
        //                       color: Colors.transparent,
        //                       strokeWidth: 1,
        //                     );
        //                   },
        //                 ),
        //                 titlesData: FlTitlesData(
        //                   show: true,
        //                   rightTitles: const AxisTitles(
        //                     sideTitles: SideTitles(showTitles: false),
        //                   ),
        //                   topTitles: const AxisTitles(
        //                     sideTitles: SideTitles(showTitles: false),
        //                   ),
        //                   bottomTitles: const AxisTitles(
        //                     sideTitles: SideTitles(
        //                       showTitles: false,
        //                     ),
        //                   ),
        //                   leftTitles: AxisTitles(
        //                     sideTitles: SideTitles(
        //                       showTitles: true,
        //                       getTitlesWidget:
        //                           (double value, TitleMeta meta) {
        //                         const style = TextStyle(
        //                           color: Colors.white,
        //                         );
        //                         return SideTitleWidget(
        //                           axisSide: meta.axisSide,
        //                           child: Text(value.toInt().toString(),
        //                               style: style),
        //                         );
        //                       },
        //                       interval: 20,
        //                       reservedSize: 42,
        //                     ),
        //                   ),
        //                 ),
        //                 borderData: FlBorderData(
        //                   show: false,
        //                   border: Border.all(color: const Color(0x0037434d)),
        //                 ),
        //                 minX: 0,
        //                 maxX: 10,
        //                 minY: 0,
        //                 maxY: 100,
        //                 lineBarsData: [
        //                   LineChartBarData(
        //                     spots: const [
        //                       FlSpot(0, 80),
        //                       FlSpot(2, 90),
        //                       FlSpot(4, 60),
        //                       FlSpot(6, 30),
        //                       FlSpot(8, 85),
        //                       FlSpot(10, 79),
        //                     ],
        //                     isCurved: true,
        //                     barWidth: 3,
        //                     isStrokeCapRound: true,
        //                     dotData: FlDotData(
        //                       show: true,
        //                       getDotPainter: (spot, percent, barData, index) {
        //                         Color dotColor = spot.y > 70
        //                             ? const Color(0xFF589AFB)
        //                             : (spot.y > 40
        //                                 ? const Color(0xFFF7E144)
        //                                 : const Color(0xFFFF7190));
        //
        //                         return FlDotCirclePainter(
        //                           color: dotColor,
        //                           strokeColor: const Color(0xFF008040),
        //                           strokeWidth: 2.5,
        //                         );
        //                       },
        //                     ),
        //                     belowBarData: BarAreaData(
        //                       show: true,
        //                       color: const Color(0x66008040),
        //                     ),
        //                     color: const Color(0xFF008040),
        //                   ),
        //                 ],
        //                 lineTouchData: const LineTouchData(
        //                   touchTooltipData: LineTouchTooltipData(
        //                     tooltipBgColor: Colors.white,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //       Container(
        //         height: 110,
        //         width: 340,
        //         alignment: Alignment.center,
        //         decoration: const BoxDecoration(
        //           borderRadius: BorderRadius.all(Radius.circular(20)),
        //           color: Colors.white,
        //         ),
        //         child: Padding(
        //           padding: const EdgeInsets.symmetric(horizontal: 10.0),
        //           child: Text(
        //             sentence.name,
        //             style: const TextStyle(
        //               fontSize: 18,
        //               fontWeight: FontWeight.bold,
        //             ),
        //             textAlign: TextAlign.center,
        //             softWrap: true,
        //           ),
        //         ),
        //       ),
        //       Expanded(
        //         child: Padding(
        //           padding: const EdgeInsets.only(bottom: 30),
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             crossAxisAlignment: CrossAxisAlignment.end,
        //             children: [
        //               Opacity(
        //                 opacity: 0.0,
        //                 child: ElevatedButton(
        //                   onPressed: null,
        //                   style: ElevatedButton.styleFrom(
        //                     shape: const CircleBorder(),
        //                     padding: const EdgeInsets.all(5),
        //                     backgroundColor: const Color(0xFFF9FAF4),
        //                     surfaceTintColor: Colors.white,
        //                     shadowColor: const Color(0xFF22BB66),
        //                     elevation: 5,
        //                   ),
        //                   child: const Icon(
        //                     Icons.refresh,
        //                     color: Color(0xFF22BB66),
        //                     size: 40,
        //                   ),
        //                 ),
        //               ),
        //               ElevatedButton(
        //                 onPressed: () {
        //                   ScaffoldMessenger.of(context)
        //                       .removeCurrentSnackBar();
        //                   context.pop();
        //                 },
        //                 style: ElevatedButton.styleFrom(
        //                   shape: const CircleBorder(),
        //                   padding: const EdgeInsets.all(5),
        //                   backgroundColor: const Color(0xFFF9FAF4),
        //                   surfaceTintColor: Colors.white,
        //                   shadowColor: const Color(0xFF22BB66),
        //                   elevation: 5,
        //                 ),
        //                 child: const Icon(
        //                   Icons.refresh,
        //                   color: Color(0xFF22BB66),
        //                   size: 40,
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.symmetric(
        //                   vertical: 7,
        //                 ),
        //                 child: ClipRRect(
        //                   borderRadius: BorderRadius.circular(50.0),
        //                   child: SizedBox(
        //                     height: 120,
        //                     width: 120,
        //                     child: UnconstrainedBox(
        //                       child: Container(
        //                         decoration: BoxDecoration(
        //                           color: const Color(0x889BF599),
        //                           borderRadius: BorderRadius.circular(50),
        //                         ),
        //                         height: 100,
        //                         width: 100,
        //                         child: BackdropFilter(
        //                           filter: ImageFilter.blur(
        //                               sigmaX: 5.0, sigmaY: 5.0),
        //                           child: FractionallySizedBox(
        //                             widthFactor: 0.9,
        //                             heightFactor: 0.9,
        //                             child: ElevatedButton(
        //                               onPressed: () {
        //                                 if (_controller.value.isPlaying) {
        //                                   _controller.pause();
        //                                 } else {
        //                                   _controller.play();
        //                                 }
        //                                 setState(() {});
        //                               },
        //                               style: ElevatedButton.styleFrom(
        //                                 shape: const CircleBorder(),
        //                                 padding: const EdgeInsets.all(15),
        //                                 backgroundColor:
        //                                     const Color(0xFF008040),
        //                                 foregroundColor:
        //                                     const Color(0xFF11AA55),
        //                                 shadowColor: const Color(0xFF9BF599),
        //                                 elevation: 7,
        //                               ),
        //                               child: _controller.value.isPlaying
        //                                   ? const Icon(
        //                                       Icons.pause,
        //                                       color: Colors.white,
        //                                       size: 60,
        //                                     )
        //                                   : const Icon(
        //                                       Icons.play_arrow,
        //                                       color: Colors.white,
        //                                       size: 60,
        //                                     ),
        //                             ),
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //               ElevatedButton(
        //                 onPressed: () {
        //                   isBookmark = !isBookmark;
        //                   if (isBookmark) {
        //                     context
        //                         .read<BookmarkProvider>()
        //                         .addBookmark(sentence.id);
        //                   } else {
        //                     context
        //                         .read<BookmarkProvider>()
        //                         .removeBookmark(sentence.id);
        //                   }
        //                   setState(() {});
        //                 },
        //                 style: ElevatedButton.styleFrom(
        //                   shape: const CircleBorder(),
        //                   padding: const EdgeInsets.all(5),
        //                   backgroundColor: const Color(0xFFF9FAF4),
        //                   surfaceTintColor: Colors.white,
        //                   shadowColor: const Color(0xFF22BB66),
        //                   elevation: 5,
        //                 ),
        //                 child: Icon(
        //                   Icons.star,
        //                   color: isBookmark
        //                       ? const Color(0xFFF4D509)
        //                       : Colors.grey,
        //                   size: 40,
        //                 ),
        //               ),
        //               ElevatedButton(
        //                 onPressed: () {
        //                   ScaffoldMessenger.of(context)
        //                       .removeCurrentSnackBar();
        //                   // context.go(practiceDoPath);
        //                 },
        //                 style: ElevatedButton.styleFrom(
        //                   shape: const CircleBorder(),
        //                   padding: const EdgeInsets.all(5),
        //                   backgroundColor: const Color(0xFFF9FAF4),
        //                   surfaceTintColor: Colors.white,
        //                   shadowColor: const Color(0xFF22BB66),
        //                   elevation: 5,
        //                 ),
        //                 child: const Icon(
        //                   Icons.double_arrow,
        //                   color: Color(0xFF22BB66),
        //                   size: 40,
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  @override
  void dispose() {
    loadingController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
