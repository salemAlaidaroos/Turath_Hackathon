// نافذة الخروج
import 'package:flutter/material.dart';
import 'dart:math';

import '../models/heritage_word.dart';
import '../data/words_data.dart';
import '../services/api_service.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  final Color primaryYellow = const Color(0xFFFFC828);
  final Color textColor = const Color(0xFF1E1E1E);
  final TextEditingController _wordController = TextEditingController();

  int attempts = 0;
  List<Map<String, dynamic>> guesses = [];
  bool isLoading = false;

  late HeritageWord currentWord;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    currentWord = WordsData.randomWord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Transform.scale(
              scale: 1.15,
              child: Opacity(
                opacity: 0.85,
                child: Image.asset(
                  'assets/images/board_game2.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 15,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: NeobrutalistBackButton(
                            onTap: () => _showExitConfirmation(context),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: textColor, width: 3),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFF1E1E1E),
                              offset: Offset(4, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              "أوجد مرادف أو معنى كلمة: ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentWord.word,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF800000),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Expanded(child: InputTextField(_wordController)),
                          const SizedBox(width: 15),
                          attemptsCounterCard(attempts),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: guesses.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 15),
                          itemBuilder: (context, index) {
                            final guess = guesses[index];
                            return NeobrutalistGuessCard(
                              word: guess['word'],
                              score: guess['score'],
                              barColor: guess['color'],
                              feedback: guess['feedback'],
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // تم تحويله لزر استسلام 🏳️
                          actionSquareButton(
                            icon: Icons.flag_outlined,
                            isHint: false,
                            onTap: () {
                              _showTVWinDialog(context, isSurrender: true);
                            },
                          ),
                          const SizedBox(width: 20),
                          isLoading
                              ? const CircularProgressIndicator(
                                  color: Color(0xFF1E1E1E),
                                )
                              : actionSquareButton(
                                  icon: Icons.arrow_back_rounded,
                                  isHint: false,
                                  isLarge: true,
                                  onTap: () async {
                                    String typedWord = _wordController.text
                                        .trim();
                                    if (typedWord.isNotEmpty) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      final aiResponse = await _apiService
                                          .analyzeExplanation(
                                            wordData: currentWord,
                                            userExplanation: typedWord,
                                          );
                                      setState(() {
                                        isLoading = false;
                                        attempts++;
                                        int percentage =
                                            aiResponse['percentage'] ?? 0;
                                        String feedback =
                                            aiResponse['feedback'] ??
                                            "كفو حاول ثاني";

                                        if (percentage == 100) {
                                          _showTVWinDialog(
                                            context,
                                            isSurrender: false,
                                          );
                                        } else {
                                          double score = percentage / 100.0;
                                          Color barColor;
                                          if (score >= 0.70) {
                                            barColor = const Color(0xFF4CAF50);
                                          } else if (score >= 0.40) {
                                            barColor = const Color(0xFFFF9800);
                                          } else {
                                            barColor = const Color(0xFFFF1744);
                                          }
                                          guesses.insert(0, {
                                            'word': typedWord,
                                            'score': score,
                                            'color': barColor,
                                            'feedback': feedback,
                                          });
                                          _wordController.clear();
                                        }
                                      });
                                    }
                                  },
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // دالة التلفزيون المعدلة (ضبط الوزن والشفافية والاستسلام)
  void _showTVWinDialog(BuildContext context, {required bool isSurrender}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: SizedBox(
            height: 400,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset('assets/images/tv.png', fit: BoxFit.contain),
                // تعديل الوزنية والشفافية للشاشة السوداء
                Positioned(
                  top: 60, // تم تنزيله قليلاً ليطابق الإطار
                  bottom: 125, // تم رفعه قليلاً
                  left: 35,
                  right: 35,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.65), // جعلها شفافة أكثر
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  bottom: 125,
                  left: 35,
                  right: 35,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isSurrender ? "تعوّضها الجايات! 🏳️" : "مبرووك! 🎉",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          currentWord.word,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            currentWord.description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12, // تصغير بسيط ليناسب المساحة الجديدة
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryYellow,
                            side: BorderSide(color: textColor, width: 2.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 5,
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            setState(() {
                              attempts = 0;
                              guesses.clear();
                              _wordController.clear();
                              currentWord = WordsData.randomWord();
                            });
                            Navigator.pop(context);
                          },
                          child: Text(
                            "كلمة جديدة",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: textColor,
                            ),
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
      },
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: textColor, width: 3),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "خروج",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
          content: Text(
            "هل أنت متأكد من إنهاء اللعبة؟",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "لا",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor.withOpacity(0.6),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF1744),
                elevation: 0,
                side: BorderSide(color: textColor, width: 2.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                "نعم، خروج",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// الباقي من الودجتس (NeobrutalistGuessCard, InputTextField, إلخ) يبقى كما هو دون تغيير.

// ---------------------------------------------------------
// الودجتس الفرعية المحدثة
// ---------------------------------------------------------

class NeobrutalistGuessCard extends StatelessWidget {
  final String word;
  final double score;
  final Color barColor;
  final String feedback; // التعليق الجديد من الذكاء الاصطناعي

  const NeobrutalistGuessCard({
    super.key,
    required this.word,
    required this.score,
    required this.barColor,
    required this.feedback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E1E1E), width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0xFF1E1E1E), offset: Offset(5, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                word,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              Text(
                "${(score * 100).toInt()}%",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E1E1E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 20,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF1E1E1E), width: 2.5),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerRight,
              widthFactor: score,
              child: Container(
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // عرض تعليق جيمناي تحت البار
          Text(
            feedback,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}

Widget attemptsCounterCard(int count) {
  return Container(
    width: 60,
    height: 60,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: const Color(0xFF1E1E1E), width: 2.5),
      boxShadow: const [
        BoxShadow(color: Color(0xFF1E1E1E), offset: Offset(4, 4)),
      ],
    ),
    child: Center(
      child: Text(
        "$count",
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w900,
          color: Color(0xFF1E1E1E),
        ),
      ),
    ),
  );
}

class InputTextField extends StatelessWidget {
  final TextEditingController controller;
  const InputTextField(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF1E1E1E), width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0xFF1E1E1E), offset: Offset(4, 4)),
        ],
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        keyboardType: TextInputType.text,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        decoration: InputDecoration(
          hintText: "اكتب كلمتك...",
          hintStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E1E1E).withOpacity(0.5),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

class actionSquareButton extends StatefulWidget {
  final IconData icon;
  final bool isHint;
  final bool isLarge;
  final VoidCallback onTap;
  const actionSquareButton({
    super.key,
    required this.icon,
    required this.isHint,
    this.isLarge = false,
    required this.onTap,
  });
  @override
  State<actionSquareButton> createState() => _actionSquareButtonState();
}

class _actionSquareButtonState extends State<actionSquareButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    final double size = widget.isLarge ? 80 : 60;
    final Color bgColor = isPressed ? const Color(0xFF1E1E1E) : Colors.white;
    final Color iconColor = isPressed ? Colors.white : const Color(0xFF1E1E1E);

    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
        setState(() => isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: size,
        height: size,
        transform: Matrix4.translationValues(
          isPressed ? 4 : 0,
          isPressed ? 4 : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(widget.isLarge ? 20 : 15),
          border: Border.all(color: const Color(0xFF1E1E1E), width: 3),
          boxShadow: isPressed
              ? []
              : [
                  BoxShadow(
                    color: const Color(0xFF1E1E1E),
                    offset: Offset(
                      widget.isLarge ? 6 : 4,
                      widget.isLarge ? 6 : 4,
                    ),
                  ),
                ],
        ),
        child: Center(
          child: Icon(
            widget.icon,
            size: widget.isLarge ? 40 : 28,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}

class NeobrutalistBackButton extends StatefulWidget {
  final VoidCallback onTap;
  const NeobrutalistBackButton({super.key, required this.onTap});
  @override
  State<NeobrutalistBackButton> createState() => _NeobrutalistBackButtonState();
}

class _NeobrutalistBackButtonState extends State<NeobrutalistBackButton> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
        setState(() => isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 50,
        height: 50,
        transform: Matrix4.translationValues(
          isPressed ? 3 : 0,
          isPressed ? 3 : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFC828),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFF1E1E1E), width: 2.5),
          boxShadow: isPressed
              ? []
              : const [
                  BoxShadow(color: Color(0xFF1E1E1E), offset: Offset(3, 3)),
                ],
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: Color(0xFF1E1E1E),
          size: 28,
        ),
      ),
    );
  }
}
