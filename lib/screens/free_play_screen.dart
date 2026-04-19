import 'package:flutter/material.dart';
import 'package:turath_hackathon/data/words_data.dart';
import 'package:turath_hackathon/models/heritage_word.dart';
import 'package:turath_hackathon/screens/play_screen.dart';

class FreePlayScreen extends StatefulWidget {
  const FreePlayScreen({super.key});

  @override
  State<FreePlayScreen> createState() => _FreePlayScreenState();
}

class _FreePlayScreenState extends State<FreePlayScreen> {
  final Color primaryYellow = const Color(0xFFFFC828);
  final Color textColor = const Color(0xFF1E1E1E);

  // المتغيرات لحفظ اختيارات اللاعب
  String? selectedRegion;
  String? selectedDifficulty;
  bool isRandomSelected = false;

  // دالة تتحقق هل زر "العب الآن" مفعل أو لا؟
  bool get canPlay =>
      isRandomSelected ||
      (selectedRegion != null && selectedDifficulty != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryYellow,
      // نستخدم Directionality هنا لضمان أن النصوص تتبع منطق اللغة العربية
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            // 1. طبقة زخرفة السدو (ثابتة في اليسار)
            Positioned(
              left: -37,
              top: 0,
              bottom: 0,
              child: Opacity(
                opacity: 0.8,
                child: Image.asset(
                  'assets/images/side_border_l.png',
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),

            // 2. طبقة المحتوى الأساسي
            Positioned.fill(
              child: SafeArea(
                child: Column(
                  children: [
                    // الهيدر - أجبرنا زر الرجوع يروح يسار مهما كان اتجاه الجوال
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 15,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Directionality(
                          textDirection:
                              TextDirection.ltr, // عشان السهم ما ينقلب
                          child: NeobrutalistBackButton(
                            onTap: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // منطقة الاختيارات والأزرار
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            // --- قسم المناطق ---
                            Text(
                              "اختر منطقة كلمتك:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 15),
                            InteractiveSelectorCard(
                              title: "نجد",
                              isSelected: selectedRegion == "نجد",
                              onTap: () => setState(() {
                                selectedRegion = "نجد";
                                isRandomSelected = false;
                              }),
                            ),
                            const SizedBox(height: 12),
                            InteractiveSelectorCard(
                              title: "الحجاز",
                              isSelected: selectedRegion == "الحجاز",
                              onTap: () => setState(() {
                                selectedRegion = "الحجاز";
                                isRandomSelected = false;
                              }),
                            ),
                            const SizedBox(height: 12),
                            InteractiveSelectorCard(
                              title: "الجنوب",
                              isSelected: selectedRegion == "الجنوب",
                              onTap: () => setState(() {
                                selectedRegion = "الجنوب";
                                isRandomSelected = false;
                              }),
                            ),

                            const SizedBox(height: 35),

                            // --- قسم الصعوبة ---
                            Text(
                              "مستوى الصعوبة:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(
                                  child: InteractiveDifficultyCard(
                                    title: "سهل",
                                    isSelected: selectedDifficulty == "سهل",
                                    activeColor: const Color(0xFF4CAF50),
                                    onTap: () => setState(() {
                                      selectedDifficulty = "سهل";
                                      isRandomSelected = false;
                                    }),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: InteractiveDifficultyCard(
                                    title: "متوسط",
                                    isSelected: selectedDifficulty == "متوسط",
                                    activeColor: const Color(0xFFFF9800),
                                    onTap: () => setState(() {
                                      selectedDifficulty = "متوسط";
                                      isRandomSelected = false;
                                    }),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: InteractiveDifficultyCard(
                                    title: "صعب",
                                    isSelected: selectedDifficulty == "صعب",
                                    activeColor: const Color(0xFFFF1744),
                                    onTap: () => setState(() {
                                      selectedDifficulty = "صعب";
                                      isRandomSelected = false;
                                    }),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 35),

                            // --- قسم العشوائي ---
                            InteractiveSelectorCard(
                              title: "عشوائي",
                              isSelected: isRandomSelected,
                              onTap: () => setState(() {
                                isRandomSelected = true;
                                selectedRegion = null;
                                selectedDifficulty = null;
                              }),
                            ),

                            const SizedBox(height: 45),

                            // --- زر العب الآن ---
                            Center(
                              child: PlaySquareButton(
                                isEnabled: canPlay,
                                onTap: () {
                                  if (canPlay) {
                                    HeritageWord? selectedWord;

                                    if (isRandomSelected) {
                                      selectedWord = WordsData.randomWord();
                                    } else {
                                      Region region = _mapStringToRegion(
                                        selectedRegion!,
                                      );
                                      Difficulty difficulty =
                                          _mapStringToDifficulty(
                                            selectedDifficulty!,
                                          );

                                      selectedWord = WordsData.getNextWord(
                                        selectedRegion: region,
                                        selectedDifficulty: difficulty,
                                      );
                                    }

                                    // 3. الانتقال لشاشة اللعب الفعلية مع الكلمة المختارة
                                    if (selectedWord != null) {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => GamePlayScreen(
                                      //       word: selectedWord!,
                                      //     ),
                                      //   ),
                                      // );
                                    }
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 50),
                          ],
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
  }

  Region _mapStringToRegion(String regionStr) {
    switch (regionStr) {
      case "نجد":
        return Region.najd;
      case "الحجاز":
        return Region.hejaz;
      case "الجنوب":
        return Region.south;
      default:
        return Region.najd;
    }
  }

  Difficulty _mapStringToDifficulty(String diffStr) {
    switch (diffStr) {
      case "سهل":
        return Difficulty.easy;
      case "متوسط":
        return Difficulty.medium;
      case "صعب":
        return Difficulty.hard;
      default:
        return Difficulty.easy;
    }
  }
}

// الودجتس المساعدة (الكرت، كرت الصعوبة، زر الرجوع، زر اللعب) تبقى كما هي في كودك
// لأنها كانت ممتازة وما فيها مشاكل برمجية، بس تأكد إنها موجودة تحت في نفس الملف.

// [هنا تكملة الودجتس الفرعية من كودك السابق...]
class InteractiveSelectorCard extends StatefulWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  const InteractiveSelectorCard({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });
  @override
  State<InteractiveSelectorCard> createState() =>
      _InteractiveSelectorCardState();
}

class _InteractiveSelectorCardState extends State<InteractiveSelectorCard> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    bool isActive = isPressed || widget.isSelected;
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
        setState(() => isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(
          isActive ? 4 : 0,
          isActive ? 4 : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1E1E1E), width: 2.5),
          boxShadow: isActive
              ? []
              : const [
                  BoxShadow(color: Color(0xFF1E1E1E), offset: Offset(4, 4)),
                ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: isActive ? Colors.white : const Color(0xFF1E1E1E),
            ),
          ),
        ),
      ),
    );
  }
}

class InteractiveDifficultyCard extends StatefulWidget {
  final String title;
  final bool isSelected;
  final Color activeColor;
  final VoidCallback onTap;
  const InteractiveDifficultyCard({
    super.key,
    required this.title,
    required this.isSelected,
    required this.activeColor,
    required this.onTap,
  });
  @override
  State<InteractiveDifficultyCard> createState() =>
      _InteractiveDifficultyCardState();
}

class _InteractiveDifficultyCardState extends State<InteractiveDifficultyCard> {
  bool isPressed = false;
  @override
  Widget build(BuildContext context) {
    bool isActive = isPressed || widget.isSelected;
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) {
        setState(() => isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(
          isActive ? 4 : 0,
          isActive ? 4 : 0,
          0,
        ),
        height: 65,
        decoration: BoxDecoration(
          color: isActive ? widget.activeColor : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFF1E1E1E), width: 2.5),
          boxShadow: isActive
              ? []
              : const [
                  BoxShadow(color: Color(0xFF1E1E1E), offset: Offset(4, 4)),
                ],
        ),
        child: Center(
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: isActive ? Colors.white : const Color(0xFF1E1E1E),
            ),
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

class PlaySquareButton extends StatefulWidget {
  final bool isEnabled;
  final VoidCallback onTap;

  const PlaySquareButton({
    super.key,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  State<PlaySquareButton> createState() => _PlaySquareButtonState();
}

class _PlaySquareButtonState extends State<PlaySquareButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    // الزر يصبح "مسطح" (بدون ظل) إذا كان مضغوطاً أو معطلاً
    bool isFlat = isPressed || !widget.isEnabled;

    return GestureDetector(
      onTapDown: (_) {
        if (widget.isEnabled) setState(() => isPressed = true);
      },
      onTapUp: (_) {
        if (widget.isEnabled) {
          setState(() => isPressed = false);

          // 1. تنفيذ أي أكواد إضافية مررناها للزر
          widget.onTap();

          // 2. الانتقال العادي لشاشة اللعب
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PlayScreen()),
          );
        }
      },
      onTapCancel: () {
        if (widget.isEnabled) setState(() => isPressed = false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 140,
        height: 140,
        // تحريك الزر للأسفل قليلاً عند الضغط لمحاكاة الضغطة الحقيقية
        transform: Matrix4.translationValues(isFlat ? 6 : 0, isFlat ? 6 : 0, 0),
        decoration: BoxDecoration(
          color: const Color(0xFF800000), // اللون العنابي الفخم
          borderRadius: BorderRadius.circular(35),
          border: Border.all(color: const Color(0xFF1E1E1E), width: 3.5),
          boxShadow: isFlat
              ? []
              : const [
                  BoxShadow(color: Color(0xFF1E1E1E), offset: Offset(8, 8)),
                ],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "العب",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2.0,
              ),
            ),
            Text(
              "الآن",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
