import 'package:flutter/material.dart';
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
  int currentIndex = 1;

  final List<Widget> screens = [
    const Center(
      child: Text(
        "شاشة المتصدرين (قريباً)",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ),
    const HomeScreen(),
    const StatsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // رجعناه RTL عشان اللوجو واللغة يضبطون (سياق تنقرأ من اليمين)
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          children: [
            Expanded(
              flex: 17,
              child: IndexedStack(index: currentIndex, children: screens),
            ),

            // البار السفلي - الحين بيترتب صح (المصدرين يمين والإعدادات يسار)
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
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: buttonBgColor,
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
            style: TextStyle(
              fontSize: 14,
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
