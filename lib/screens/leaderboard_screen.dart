import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  final Color textColor = const Color(0xFF1E1E1E);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        // نفس القريدينت العسلي حق شاشة الإحصائيات
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
        // الدائرة المقصوصة من تحت
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(100),
          bottomRight: Radius.circular(100),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40), // مساحة علوية بدل العنوان المحذوف
            // --- منصة الثلاثة الأوائل (Podium) مكبّرة للصور ---
            _buildLargePodium(),

            const SizedBox(height: 30),

            // --- قائمة باقي المتصدرين (4 - 10) ---
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: 7,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _buildLeaderboardItem(index + 4);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // منصة الثلاثة الأوائل مكبرة وجاهزة للصور
  Widget _buildLargePodium() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // المركز الثاني (يمين)
        _buildPodiumItem(
          name: "راكان المطيري",
          streak: "42",
          rank: "2",
          height: 140,
          color: Colors.grey.shade300,
          imagePath: "assets/images/racan.png", // حط مسار صورتك هنا
        ),
        // المركز الأول (النص) - الأكبر
        _buildPodiumItem(
          name: "محمد العواشز",
          streak: "55",
          rank: "1",
          height: 190,
          color: const Color(0xFFFFC828),
          imagePath: "assets/images/alawashiz.png", // حط مسار صورتك هنا
          isFirst: true,
        ),
        // المركز الثالث (يسار)
        _buildPodiumItem(
          name: "انس الشهري",
          streak: "38",
          rank: "3",
          height: 120,
          color: const Color(0xFFCD7F32),
          imagePath: "assets/images/anas.png", // حط مسار صورتك هنا
        ),
      ],
    );
  }

  Widget _buildPodiumItem({
    required String name,
    required String streak,
    required String rank,
    required double height,
    required Color color,
    required String imagePath,
    bool isFirst = false,
  }) {
    return Column(
      children: [
        if (isFirst)
          const Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 45),
        const SizedBox(height: 8),
        // الدائرة المكبّرة للصور
        Container(
          width: isFirst ? 90 : 75,
          height: isFirst ? 90 : 75,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: textColor, width: 3),
            boxShadow: [
              BoxShadow(color: textColor, offset: const Offset(3, 3)),
            ],
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 10),
        // قاعدة المنصة
        Container(
          width: 90,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white, // خليناها بيضاء عشان تبرز الصور فوقها
            border: Border.all(color: textColor, width: 3),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: textColor, offset: const Offset(4, 0)),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                rank,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    streak,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: textColor,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardItem(int rank) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: textColor, width: 2.5),
        boxShadow: [BoxShadow(color: textColor, offset: const Offset(3, 3))],
      ),
      child: Row(
        children: [
          Text(
            "#$rank",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
          const SizedBox(width: 15),
          CircleAvatar(
            backgroundColor: const Color(0xFFF1F3F4),
            radius: 20,
            backgroundImage: const AssetImage(
              "assets/images/default_user.png",
            ), // صورة افتراضية
          ),
          const SizedBox(width: 15),
          Text(
            "لاعب محترف",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                "${25 - rank} يوم",
                style: TextStyle(fontWeight: FontWeight.w900, color: textColor),
              ),
              const Icon(
                Icons.local_fire_department,
                color: Colors.orange,
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
