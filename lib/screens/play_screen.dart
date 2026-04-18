import 'package:flutter/material.dart';
import 'dart:math'; // نحتاجه عشان نولد نسبة عشوائية

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  final Color primaryYellow = const Color(0xFFFFC828);
  final Color textColor = const Color(0xFF1E1E1E);
  final TextEditingController _wordController = TextEditingController();

  // ==========================================
  // متغيرات اللعبة واللوجك
  // ==========================================
  int attempts = 0;
  List<Map<String, dynamic>> guesses = [];

  // الكلمة المخفية ومعناها
  final String targetWord = "خيمة";
  final String targetMeaning =
      "بيت من الشَّعر أو القماش، يُنصب في الصحراء للوقاية من الشمس والبرد.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. خلفية البورد
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

          // 2. المحتوى الأساسي
          Positioned.fill(
            child: SafeArea(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: [
                    // --- زر الرجوع ---
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

                    // --- بانر الكلمة الهدف (الجديد) ---
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
                              "كلمتك هيا: ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              targetWord,
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

                    // --- منطقة الإدخال (التيكست فيلد والكاونتر) ---
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

                    // --- قائمة التخمينات ---
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
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // --- منطقة الأزرار (الهنت والسبمنت) ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // زر الهنت
                          actionSquareButton(
                            icon: Icons.lightbulb_outline,
                            isHint: true,
                            onTap: () {
                              print("Hint clicked");
                              // هنا ممكن نبرمج التلميح بعدين
                            },
                          ),
                          const SizedBox(width: 20),
                          // زر السبمنت (برمجنا فيه اللوجك)
                          actionSquareButton(
                            icon: Icons.arrow_back_rounded,
                            isHint: false,
                            isLarge: true,
                            onTap: () {
                              String typedWord = _wordController.text.trim();
                              if (typedWord.isNotEmpty) {
                                // هل الكلمة صحيحة؟
                                if (typedWord == targetWord) {
                                  _showTVWinDialog(context); // شغل التلفزيون!
                                } else {
                                  // إذا غلط، احسب نسبة وهمية وضيفها للستة
                                  setState(() {
                                    attempts++;

                                    // توليد نسبة عشوائية (كمثال)
                                    double randomScore =
                                        (10 + Random().nextInt(85)) / 100.0;

                                    // تحديد اللون بناءً على النسبة
                                    Color barColor;
                                    if (randomScore >= 0.70) {
                                      barColor = const Color(
                                        0xFF4CAF50,
                                      ); // أخضر
                                    } else if (randomScore >= 0.40) {
                                      barColor = const Color(
                                        0xFFFF9800,
                                      ); // برتقالي
                                    } else {
                                      barColor = const Color(
                                        0xFFFF1744,
                                      ); // أحمر
                                    }

                                    // إضافة الكلمة في بداية اللستة (عشان تطلع فوق)
                                    guesses.insert(0, {
                                      'word': typedWord,
                                      'score': randomScore,
                                      'color': barColor,
                                    });

                                    _wordController.clear();
                                  });
                                }
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

  // ==========================================
  // نافذة الفوز (التلفزيون 📺)
  // ==========================================
  // ==========================================
  // دالة شاشة الفوز (التلفزيون 📺) المحدثة
  // ==========================================
  // ==========================================
  // دالة شاشة الفوز (التلفزيون 📺) المحدثة
  // ==========================================
  void _showTVWinDialog(BuildContext context) {
    // تعريف مفصل للكلمة الهدف "خيمة"
    final String definitionText =
        "$targetWord هي مسكن تقليدي يعود تاريخه إلى العصور النبطية في شبه الجزيرة العربية. يصنع من شَعْر الحيوانات أو القماش، ويُنصب ليكون ملاذاً مؤقتاً يحمي ساكنيه من قسوة الصحراء، بين شمسها المحرقة وبردها القارس.";

    showDialog(
      context: context,
      barrierDismissible: false, // يمنع إغلاق الشاشة لو ضغط برا
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent, // شفاف عشان التلفزيون يبرز
          elevation: 0,
          child: SizedBox(
            height: 400,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 1. صورة التلفزيون (الإطار)
                Image.asset(
                  'assets/images/tv.png', // تأكد من المسار
                  fit: BoxFit.contain,
                ),

                // 2. طبقة سوداء خلفية تحاكي الشاشة الحقيقية
                Positioned(
                  top: 50, // نوزنها لتكون داخل الشاشة
                  bottom: 110, // نبعد عن الأزرار
                  left: 30,
                  right: 30,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(
                        0.85,
                      ), // طبقة سوداء شبه شفافة
                      borderRadius: BorderRadius.circular(
                        5,
                      ), // انحناء بسيط ليطابق الشاشة
                    ),
                  ),
                ),

                // 3. المحتوى فوق الطبقة السوداء
                Positioned(
                  top: 50,
                  bottom: 110,
                  left: 30,
                  right: 30,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "مبرووك! ",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors
                                .white, // نص أبيض ليتناسب مع الخلفية السوداء
                          ),
                        ),
                        Text(
                          targetWord,
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          definitionText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 15),
                        // زر العب مرة أخرى
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                primaryYellow, // نستخدم اللون الأصفر المعتمد
                            side: BorderSide(color: textColor, width: 2.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            // تصفير اللعبة وإغلاق التلفزيون
                            setState(() {
                              attempts = 0;
                              guesses.clear();
                              _wordController.clear();
                            });
                            Navigator.pop(context);
                          },
                          child: Text(
                            "العب مرة أخرى",
                            style: TextStyle(
                              fontSize: 16,
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

  // نافذة الخروج
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

// ---------------------------------------------------------
// الودجتس الفرعية
// ---------------------------------------------------------

class NeobrutalistGuessCard extends StatelessWidget {
  final String word;
  final double score;
  final Color barColor;

  const NeobrutalistGuessCard({
    super.key,
    required this.word,
    required this.score,
    required this.barColor,
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
        // =====================================
        // الأسطر الثلاثة الجديدة لحل مشكلة العربي
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        keyboardType: TextInputType.text,
        // =====================================
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
