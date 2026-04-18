class GuessRequest {
  final String userExplanation;
  final String targetWord;
  final String correctMeaning;

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