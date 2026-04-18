import 'dart:math';

import '../models/heritage_word.dart';

class WordsData {
  static List<HeritageWord> allWords = [
    // --- منطقة نجد ---
    HeritageWord(
      word: "الميقعة",
      meaning: "وعاء خشبي متين يُستخدم لدق وهرس الحبوب واللحم وتجهيز الأكل الشعبي",
      region: Region.najd,
      difficulty: Difficulty.easy,
    ),
    HeritageWord(
      word: "المحماس",
      meaning: "أداة معدنية طويلة تستخدم لتقليب القهوة أثناء تحميصها على النار",
      region: Region.najd,
      difficulty: Difficulty.medium,
    ),
    HeritageWord(
      word: "الكمار",
      meaning: "رفوف خشبية أو حجرية في صدر المجلس توضع عليها دلال القهوة وأدواتها",
      region: Region.najd,
      difficulty: Difficulty.hard,
    ),

    // --- منطقة الحجاز ---
    HeritageWord(
      word: "الزير",
      meaning: "وعاء فخاري كبير يستخدم لتبريد وتنقية مياه الشرب",
      region: Region.hejaz,
      difficulty: Difficulty.easy,
    ),
    HeritageWord(
      word: "الروشن",
      meaning: "نافذة خشبية بارزة ومزخرفة تطل على الشارع وتسمح بدخول الهواء والخصوصية",
      region: Region.hejaz,
      difficulty: Difficulty.medium,
    ),
    HeritageWord(
      word: "المنقور",
      meaning: "طبل حجازي قديم يستخدم في الفنون الشعبية مثل المجرور والينبعاوي",
      region: Region.hejaz,
      difficulty: Difficulty.hard,
    ),

    // --- منطقة الجنوب ---
    HeritageWord(
      word: "الموفا",
      meaning: "فرن طيني تقليدي (تنور) يستخدم لخبز الخبز الجنوبي وتحضير الحنيذ",
      region: Region.south,
      difficulty: Difficulty.easy,
    ),
    HeritageWord(
      word: "المهباش",
      meaning: "أداة خشبية لطحن القهوة وتصدر صوتاً إيقاعياً يرحب بالضيوف",
      region: Region.south,
      difficulty: Difficulty.medium,
    ),
    HeritageWord(
      word: "الجفنة",
      meaning: "وعاء خشبي كبير وعميق يقدم فيه العيش والسمن والرضيفة في المناسبات",
      region: Region.south,
      difficulty: Difficulty.hard,
    ),

    // --- إضافات منوعة لزيادة التحدي ---
    HeritageWord(
      word: "الخرج",
      meaning: "حقيبة من الصوف توضع على ظهر الراحلة (الجمل أو الحصان) لحفظ الأمتعة",
      region: Region.najd,
      difficulty: Difficulty.medium,
    ),
    HeritageWord(
      word: "المصلحة",
      meaning: "سجادة صغيرة مصنوعة من الجلد أو الصوف تستخدم للجلوس أو الصلاة",
      region: Region.south,
      difficulty: Difficulty.hard,
    ),
    HeritageWord(
      word: "المرش",
      meaning: "قنينة معدنية ذات عنق طويل تستخدم لتعطير الضيوف بماء الورد",
      region: Region.hejaz,
      difficulty: Difficulty.easy,
    ),
  ];


  static HeritageWord? getNextWord({required Region selectedRegion, required Difficulty selectedDifficulty}) {
    
    List<HeritageWord> filtered = allWords.where((word) {
      return word.region == selectedRegion && word.difficulty == selectedDifficulty;
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