import 'dart:math';
import '../models/heritage_word.dart';

class WordsData {
  static List<HeritageWord> allWords = [
    // ==========================================
    // --- منطقة نجد ---
    // ==========================================
    HeritageWord(
      word: "الزولية",
      targetMeaning: "سجادة", // أو فرشة
      description: "فراش منسوج يفرش على الأرض للجلوس عليه في المجالس والبيوت.",
      region: Region.najd,
      difficulty: Difficulty.easy,
    ),
    HeritageWord(
      word: "السحارة",
      targetMeaning: "صندوق", // صندوق الحفظ
      description:
          "صندوق خشبي أو معدني قديم يُستخدم لحفظ الملابس والأشياء الثمينة.",
      region: Region.najd,
      difficulty: Difficulty.medium,
    ),
    HeritageWord(
      word: "المحقن",
      targetMeaning: "قمع", // القمع البلاستيكي أو الحديدي
      description:
          "أداة مخروطية الشكل تُستخدم لصب السوائل مثل السمن واللبن في الأوعية الضيقة بدون ما تنكب.",
      region: Region.najd,
      difficulty: Difficulty.hard,
    ),

    // ==========================================
    // --- منطقة الحجاز ---
    // ==========================================
    HeritageWord(
      word: "السموار",
      targetMeaning: "غلاية", // غلاية الموية
      description:
          "وعاء معدني مزخرف يُستخدم لغلي الماء وتحضير الشاي في الجلسات الحجازية العائلية.",
      region: Region.hejaz,
      difficulty: Difficulty.easy,
    ),
    HeritageWord(
      word: "الكرويتة",
      targetMeaning: "كنبة", // أو مقعد
      description:
          "مقعد خشبي طويل ومريح يوضع في صدر المجلس لاستقبال الضيوف بكرامة.",
      region: Region.hejaz,
      difficulty: Difficulty.medium,
    ),
    HeritageWord(
      word: "البقشة",
      targetMeaning: "حقيبة", // أو شنطة / كيس
      description:
          "قطعة قماش مربعة تُجمع فيها الملابس وتُربط من أطرافها لتُحمل على الظهر أثناء السفر والتنقل.",
      region: Region.hejaz,
      difficulty: Difficulty.hard,
    ),

    // ==========================================
    // --- منطقة الجنوب ---
    // ==========================================
    HeritageWord(
      word: "القطيفة",
      targetMeaning: "بطانية", // أو لحاف
      description:
          "غطاء صوفي ثقيل ودافئ يُصنع يدوياً للوقاية من برد الشتاء القارس في المناطق الجبلية.",
      region: Region.south,
      difficulty: Difficulty.easy,
    ),
    HeritageWord(
      word: "الجونة",
      targetMeaning: "سلة", // سلة الخبز
      description:
          "وعاء دائري يُصنع ببراعة وإتقان من سعف النخيل لحفظ الخبز والأطعمة وتغطيتها.",
      region: Region.south,
      difficulty: Difficulty.medium,
    ),
    HeritageWord(
      word: "المسحاة",
      targetMeaning: "مجرفة", // أو شيول / مسحاة زراعية
      description:
          "أداة زراعية حديدية ذات مقبض خشبي تُستخدم لتقليب التربة وحفر الأرض للزراعة.",
      region: Region.south,
      difficulty: Difficulty.hard,
    ),
  ];

  static HeritageWord? getNextWord({
    required Region selectedRegion,
    required Difficulty selectedDifficulty,
  }) {
    List<HeritageWord> filtered = allWords.where((word) {
      return word.region == selectedRegion &&
          word.difficulty == selectedDifficulty;
    }).toList();

    if (filtered.isEmpty) {
      return allWords[Random().nextInt(allWords.length)];
    }

    filtered.shuffle();
    return filtered.first;
  }

  static HeritageWord randomWord() {
    var list = List<HeritageWord>.from(allWords);
    list.shuffle();
    return list.first;
  }
}
