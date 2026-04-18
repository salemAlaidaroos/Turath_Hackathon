import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  final Color textColor = const Color(0xFF1E1E1E);

  @override
  Widget build(BuildContext context) {
    // نرجع حاوي (Container) مباشرة بدال الـ Scaffold والـ Column المعقدة
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0xFFFFFDE7), // المركز فاتح
            Color(0xFFFFC828), // الوسط أصفر
            Color(0xFFF57F17), // الأطراف عسلي للعمق
          ],
          stops: [0.1, 0.6, 1.0],
          center: Alignment.center,
          radius: 1.0,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(100),
          bottomRight: Radius.circular(100),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 50),

              // محتوى الإحصائيات داخل قائمة قابلة للتمرير
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // --- القسم الأول: الخلاصة السريعة ---
                    const Text(
                      "خلاصة الأداء:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const OverviewCard(),

                    const SizedBox(height: 25),

                    // --- القسم الثاني: إتقان المناطق ---
                    const Text(
                      "إتقان المناطق:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: textColor, width: 2.5),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFF1E1E1E),
                            offset: Offset(4, 4),
                          ),
                        ],
                      ),
                      child: const Column(
                        children: [
                          NeobrutalistProgressBar(
                            label: "نجد",
                            percentage: 0.85,
                            barColor: Color(0xFF4CAF50),
                          ),
                          SizedBox(height: 15),
                          NeobrutalistProgressBar(
                            label: "الحجاز",
                            percentage: 0.50,
                            barColor: Color(0xFFFF9800),
                          ),
                          SizedBox(height: 15),
                          NeobrutalistProgressBar(
                            label: "الجنوب",
                            percentage: 0.30,
                            barColor: Color(0xFFFF1744),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // --- القسم الثالث: الانتصارات حسب الصعوبة ---
                    const Text(
                      "الانتصارات حسب الصعوبة:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        Expanded(
                          child: DifficultyStatCard(
                            title: "سهل",
                            count: "42",
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: DifficultyStatCard(
                            title: "متوسط",
                            count: "15",
                            color: Color(0xFFFF9800),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: DifficultyStatCard(
                            title: "صعب",
                            count: "3",
                            color: Color(0xFFFF1744),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- الودجتس المساعدة ( OverviewCard, StatItem, DifficultyStatCard, NeobrutalistProgressBar ) ---

class OverviewCard extends StatelessWidget {
  const OverviewCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E1E1E), width: 2.5),
        boxShadow: const [
          BoxShadow(color: Color(0xFF1E1E1E), offset: Offset(5, 5)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const StatItem(label: "لعبت", value: "128"),
          Container(width: 2.5, height: 40, color: const Color(0xFF1E1E1E)),
          const StatItem(label: "الفوز", value: "75%"),
          Container(width: 2.5, height: 40, color: const Color(0xFF1E1E1E)),
          const StatItem(label: "سلسلة", value: "8🔥"),
        ],
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final String label;
  final String value;
  const StatItem({super.key, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E1E1E),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class DifficultyStatCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;
  const DifficultyStatCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF1E1E1E), width: 2.5),
        boxShadow: const [
          BoxShadow(color: Color(0xFF1E1E1E), offset: Offset(4, 4)),
        ],
      ),
      child: Column(
        children: [
          Text(
            count,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class NeobrutalistProgressBar extends StatelessWidget {
  final String label;
  final double percentage;
  final Color barColor;
  const NeobrutalistProgressBar({
    super.key,
    required this.label,
    required this.percentage,
    required this.barColor,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
            Text(
              "${(percentage * 100).toInt()}%",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 20,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3F4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF1E1E1E), width: 2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerRight,
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
