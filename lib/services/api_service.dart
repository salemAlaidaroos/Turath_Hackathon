import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/heritage_word.dart'; // تأكد من مسار الملف

class ApiService {
  // الرابط صحيح 100% لمحاكي الأندرويد
  static const String baseUrl = "http://10.0.2.2:8000/analyze";

  Future<Map<String, dynamic>> analyzeExplanation({
    required HeritageWord wordData,
    required String userExplanation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "user_explanation": userExplanation,
          "target_word": wordData.word,
          // ==========================================
          // التعديل هنا: استخدمنا targetMeaning بدال meaning
          // وشلنا الـ region عشان ما يزعل سيرفر البايثون
          // ==========================================
          "correct_meaning": wordData.targetMeaning,
        }),
      );

      if (response.statusCode == 200) {
        // نرجع الـ JSON اللي فيه percentage و feedback من جيمناي
        return jsonDecode(
          utf8.decode(response.bodyBytes),
        ); // استخدمنا utf8 عشان العربي يوصل صافي بدون رموز غريبة
      } else {
        return {
          "percentage": 0,
          "feedback": "السيرفر زعلان شوي، تأكد إنك مشغل كود البايثون!",
        };
      }
    } catch (e) {
      print("Error calling API: $e");
      return {
        "percentage": 0,
        "feedback":
            "ما قدرت أوصل للسيرفر. تأكد إن الجوال والكمبيوتر مشبوكين صح.",
      };
    }
  }
}
