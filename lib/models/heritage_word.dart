enum Region { 
  najd, hejaz, south;

  // إضافة ميزة لتحويل الـ enum لنص عربي مباشرة
  String get nameArabic {
    switch (this) {
      case Region.najd: return "نجد";
      case Region.hejaz: return "الحجاز";
      case Region.south: return "الجنوب";
    }
  }
}

enum Difficulty { 
  easy, medium, hard;

  String get nameArabic {
    switch (this) {
      case Difficulty.easy: return "سهل";
      case Difficulty.medium: return "متوسط";
      case Difficulty.hard: return "صعب";
    }
  }
}

class HeritageWord {
  final String word;
  final String meaning;
  final Region region;
  final Difficulty difficulty;

  HeritageWord({
    required this.word,
    required this.meaning,
    required this.region,
    required this.difficulty,
  });
}