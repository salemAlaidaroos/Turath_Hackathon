import 'package:flutter/material.dart';
// استيراد الشاشات الأربعة
import 'leaderboard_screen.dart';
import 'home_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Color bgColor = const Color(0xFFF1F3F4);
  int currentIndex = 1; // نبدأ من شاشة الهوم (الرئيسية)

  // القائمة النهائية للشاشات المربوطة
  final List<Widget> screens = [
    const LeaderboardScreen(), // شاشة المتصدرين (بدل نص قريباً)
    const HomeScreen(), // شاشة اللعب/الخريطة
    const StatsScreen(), // شاشة الإحصائيات (الجريدينت)
    const SettingsScreen(), // شاشة الإعدادات
  ];

  @override
  Widget build(BuildContext context) {
    // دعم اللغة العربية والاتجاه من اليمين لليسار
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          children: [
            // منطقة عرض الشاشات
            Expanded(
              flex: 17,
              child: IndexedStack(index: currentIndex, children: screens),
            ),

            // البار السفلي بستايل النيوبتروتاليست المعتمد
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
                      isActive: currentIndex == 0,
                      onTap: () => setState(() => currentIndex = 0),
                    ),
                    InteractiveBottomButton(
                      icon: Icons.play_arrow_rounded,
                      label: "الرئيسية",
                      isActive: currentIndex == 1,
                      onTap: () => setState(() => currentIndex = 1),
                    ),
                    InteractiveBottomButton(
                      icon: Icons.bar_chart_rounded,
                      label: "الإحصائيات",
                      isActive: currentIndex == 2,
                      onTap: () => setState(() => currentIndex = 2),
                    ),
                    InteractiveBottomButton(
                      icon: Icons.settings_outlined,
                      label: "الإعدادات",
                      isActive: currentIndex == 3,
                      onTap: () => setState(() => currentIndex = 3),
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
}

// ---------------------------------------------------------
// ودجت الأزرار التفاعلية للبار السفلي
// ---------------------------------------------------------
class InteractiveBottomButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const InteractiveBottomButton({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
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
    bool activeState = widget.isActive || isHovered;
    final Color buttonBgColor = activeState
        ? const Color(0xFF1E1E1E)
        : Colors.white;
    final Color contentColor = activeState
        ? Colors.white
        : const Color(0xFF1E1E1E);

    return GestureDetector(
      onTapDown: (_) {
        if (!widget.isActive) setState(() => isHovered = true);
      },
      onTapUp: (_) {
        if (!widget.isActive) setState(() => isHovered = false);
        widget.onTap();
      },
      onTapCancel: () {
        if (!widget.isActive) setState(() => isHovered = false);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 70, // صغرنا الحجم شوي عشان يضبط في كل الشاشات
            height: 70,
            decoration: BoxDecoration(
              color: buttonBgColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF1E1E1E), width: 2.5),
              // تأثير الظل المعتمد في اللعبة
              boxShadow: activeState
                  ? []
                  : const [
                      BoxShadow(color: Color(0xFF1E1E1E), offset: Offset(3, 3)),
                    ],
            ),
            padding: const EdgeInsets.all(4),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: activeState
                      ? Colors.white.withOpacity(0.3)
                      : const Color(0xFF1E1E1E),
                  width: 2,
                ),
              ),
              child: Icon(widget.icon, color: contentColor, size: 30),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: widget.isActive
                  ? const Color(0xFF1E1E1E)
                  : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
