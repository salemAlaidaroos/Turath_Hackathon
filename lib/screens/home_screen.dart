import 'package:flutter/material.dart';
import 'package:turath_hackathon/screens/free_play_screen.dart';
// import 'free_play_screen.dart'; // تأكد من فك الكومنت لو الملف موجود

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final Color primaryYellow = const Color(0xFFFFC828);
  final Color textColor = const Color(0xFF1E1E1E);

  @override
  Widget build(BuildContext context) {
    // استخدمنا الـ Scaffold والـ Column هنا عشان نضمن إن المحتوى ما يضيع
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F4), // لون الخلفية الرمادي تحت
      body: Column(
        children: [
          Expanded(
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
                    // السدو (يسار)
                    Positioned(
                      left: -30,
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
                    // المحتوى
                    SafeArea(
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          // اللوجو
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
                            ),
                          ),
                          const SizedBox(height: 30),
                          // القائمة
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
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const FreePlayScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(height: 20),
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
          // تركنا مساحة وهمية هنا عشان ما يغطي عليها البار السفلي في الـ MainScreen
          const SizedBox(height: 0),
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
