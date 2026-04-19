enum Region {
  najd,
  hejaz,
  south;

  // ميزة ممتازة من خويك لتحويل الـ enum لنص عربي مباشرة بالواجهات
  String get nameArabic {
    switch (this) {
      case Region.najd:
        return "نجد";
      case Region.hejaz:
        return "الحجاز";
      case Region.south:
        return "الجنوب";
    }
  }
}

enum Difficulty {
  easy,
  medium,
  hard;

  String get nameArabic {
    switch (this) {
      case Difficulty.easy:
        return "سهل";
      case Difficulty.medium:
        return "متوسط";
      case Difficulty.hard:
        return "صعب";
    }
  }
}

// ---------------------------------------------------------
// 1. كلاس الكلمة التراثية (تعدل حسب اللوجك الجديد)
// ---------------------------------------------------------
class HeritageWord {
  final String word; // الكلمة التراثية اللي تطلع فوق (مثال: الميقعة)
  final String targetMeaning; // الكلمة اللي اليوزر يحاول يحزرها (مثال: هاون)
  final String description; // الشرح الطويل اللي يطلع بالتلفزيون بعد الفوز
  final Region region;
  final Difficulty difficulty;

  HeritageWord({
    required this.word,
    required this.targetMeaning, // تم التعديل هنا
    required this.description, // تم الإضافة هنا
    required this.region,
    required this.difficulty,
  });
}
