class GuessRequest {
  final String userExplanation; // اللي كتبه اليوزر في التيكست فيلد
  final String targetWord; // الكلمة التراثية المعروضة
  final String
  correctMeaning; // نمرر له هنا الـ targetMeaning (عشان جيمناي يقارن بينهم)

  GuessRequest({
    required this.userExplanation,
    required this.targetWord,
    required this.correctMeaning,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_explanation': userExplanation,
      'target_word': targetWord,
      'correct_meaning': correctMeaning,
    };
  }
}
