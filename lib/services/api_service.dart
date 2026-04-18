import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/heritage_word.dart';

class ApiService {
  
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
          "correct_meaning": wordData.meaning,
          "region": wordData.region.nameArabic, // نرسل اسم المنطقة بالعربي للذكاء الاصطناعي
        }),
      );

      if (response.statusCode == 200) {
        // نرجع الـ JSON اللي فيه percentage و feedback
        return jsonDecode(response.body);
      } else {
        return {
          "percentage": 0, 
          "feedback": "السيرفر زعلان شوي، تأكد إنك مشغل كود البايثون!"
        };
      }
    } catch (e) {
      print("Error calling API: $e");
      return {
        "percentage": 0, 
        "feedback": "ما قدرت أوصل للسيرفر. تأكد إن الجوال والكمبيوتر على نفس الشبكة."
      };
    }
  }
}