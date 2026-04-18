import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final Color primaryYellow = const Color(0xFFFFC828);
  final Color bgColor = const Color(0xFFF1F3F4);
  final Color textColor = const Color(0xFF1E1E1E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // 1. القسم العلوي الأصفر (تم زيادة الـ flex من 8 إلى 17 لزيادة الطول)
          Expanded(
            flex: 17,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryYellow,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
                child: Stack(
                  children: [
                    // طبقة الزخرفة (يمين)
                    // Positioned(
                    //   right: -35,
                    //   top: 0,
                    //   bottom: 0,
                    //   child: Opacity(
                    //     opacity: 0.7,
                    //     child: Image.asset(
                    //       'assets/images/side_border_r.png',
                    //       fit: BoxFit.fitHeight,
                    //     ),
                    //   ),
                    // ),
                    // طبقة الزخرفة (يسار)
                    Positioned(
                      left: -25,
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

                    // طبقة المحتوى الأساسي (اللوجو والأزرار)
                    SafeArea(
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          // اللوجو (س ي ا ق)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildLetterBlock(
                                'س',
                                Colors.white,
                                textColor,
                                -0.05,
                              ),
                              _buildLetterBlock(
                                'ي',
                                Colors.white,
                                textColor,
                                0.0,
                              ),
                              _buildLetterBlock(
                                'ا',
                                const Color(0xFFF05133),
                                Colors.white,
                                0.05,
                              ),
                              _buildLetterBlock(
                                'ق',
                                const Color(0xFFF38118),
                                Colors.white,
                                -0.02,
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),
                          Text(
                            "أطوار اللعب",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: textColor,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 30),
                          // أزرار أطوار اللعب
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                              ),
                              child: ListView(
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  NeobrutalistCard(
                                    title: "التحدي اليومي",
                                    onTap: () {},
                                  ),
                                  const SizedBox(height: 25),
                                  NeobrutalistCard(
                                    title: "مبارزة 1vs1",
                                    onTap: () {},
                                  ),
                                  const SizedBox(height: 25),
                                  NeobrutalistCard(
                                    title: "اللعب الحر",
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. القسم السفلي الأبيض (تم تعديل الـ flex من 2 إلى 3 ليتناسب مع التغيير)
          Expanded(
            flex: 3,
            child: Container(
              color: bgColor,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InteractiveBottomButton(
                    icon: Icons.leaderboard_rounded,
                    label: "المتصدرين",
                    onTap: () {},
                  ),
                  InteractiveBottomButton(
                    icon: Icons.play_arrow_rounded,
                    label: "الرئيسية",
                    onTap: () {},
                  ),
                  InteractiveBottomButton(
                    icon: Icons.bar_chart_rounded,
                    label: "الإحصائيات",
                    onTap: () {},
                  ),
                  InteractiveBottomButton(
                    icon: Icons.settings_outlined,
                    label: "الإعدادات",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLetterBlock(
    String letter,
    Color bgColor,
    Color blockTextColor,
    double rotation,
  ) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        width: 55,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFF1E1E1E), width: 2),
          boxShadow: const [
            BoxShadow(color: Color(0xFF1E1E1E), offset: Offset(4, 4)),
          ],
        ),
        child: Text(
          letter,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: blockTextColor,
          ),
        ),
      ),
    );
  }
}

class NeobrutalistCard extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const NeobrutalistCard({super.key, required this.title, required this.onTap});

  @override
  State<NeobrutalistCard> createState() => _NeobrutalistCardState();
}

class _NeobrutalistCardState extends State<NeobrutalistCard> {
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
        transform: Matrix4.translationValues(
          isPressed ? 5 : 0,
          isPressed ? 5 : 0,
          0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF1E1E1E), width: 3),
          boxShadow: isPressed
              ? []
              : const [
                  BoxShadow(color: Color(0xFF1E1E1E), offset: Offset(6, 6)),
                ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          alignment: Alignment.center,
          child: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E1E1E),
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}

class InteractiveBottomButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const InteractiveBottomButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<InteractiveBottomButton> createState() =>
      _InteractiveBottomButtonState();
}

class _InteractiveBottomButtonState extends State<InteractiveBottomButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final Color activeColor = isHovered
        ? const Color(0xFF1E1E1E)
        : Colors.white;
    final Color contentColor = isHovered
        ? Colors.white
        : const Color(0xFF1E1E1E);

    return GestureDetector(
      onTapDown: (_) => setState(() => isHovered = true),
      onTapUp: (_) {
        setState(() => isHovered = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => isHovered = false),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: activeColor,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFF1E1E1E), width: 2.5),
            ),
            padding: const EdgeInsets.all(4),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF1E1E1E), width: 2.5),
              ),
              child: Icon(widget.icon, color: contentColor, size: 35),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}
