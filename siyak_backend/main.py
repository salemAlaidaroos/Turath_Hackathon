import os
import json
import google.generativeai as genai
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from dotenv import load_dotenv

load_dotenv()
app = FastAPI()

# إعدادات Gemini
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
genai.configure(api_key=GEMINI_API_KEY)

generation_config = {
    "temperature": 0.7,
    "response_mime_type": "application/json", 
}

# =========================================================
# التعديل هنا: استخدمنا gemini-1.5-flash-latest لضمان الاستجابة
# =========================================================
# استبدل سطر الـ model بهذا الكود
model = genai.GenerativeModel(
    # استخدمنا النسخة الخفيفة (الطلقة) عشان السرعة وما يعطيك 429
    model_name="models/gemini-flash-lite-latest", 
    generation_config=generation_config,
    system_instruction="أنت حكم لغوي وصعب الإرضاء في لعبة تراثية سعودية..." # خلك على نفس البرومبت الأخير
)

class GuessRequest(BaseModel):
    user_explanation: str
    target_word: str
    correct_meaning: str

@app.post("/analyze")
async def analyze_meaning(request: GuessRequest):
    
    # ==========================================
    # التعديل الجوهري هنا: هندسة الأوامر (Prompt Engineering) لضبط الحكم
    # ==========================================
   # ==========================================
    # التعديل الصارم جداً لمنع "الحرق" نهائياً
    # ==========================================
    # ==========================================
    # التعديل الجديد: رفع مستوى الصعوبة ومنع التلميح السهل
    # ==========================================
    # ==========================================
    # البرومبت المعضل: قوانين صارمة للتقييم، الإملاء، والكلمات العامة
    # ==========================================
    prompt = f"""
أنت محرك تقييم ذكي وسريع للعبة كلمات تعتمد على الترابط السياقي (مثل Contexto).
الهدف: "{request.correct_meaning}"
تخمين اللاعب: "{request.user_explanation}"

احسب نسبة الترابط (0-100) بناءً على الوظيفة، البيئة، والاستخدام المتبادل، وليس المترادفات فقط! (مثال: "غلاية" و"ماء" ترابطهما عالي 60-70% لارتباطهما الوظيفي المباشر).

قواعد صارمة:
1. تطابق أو خطأ إملائي بسيط = 100.
2. ترابط وظيفي/بيئي (يستخدمان معاً) = 40 إلى 75.
3. مرادف شبه دقيق = 80 إلى 99.
4. لا تكتب الكلمة الهدف في التعليق أبداً إلا إذا جاب 100.

أرجع JSON فقط وحصرياً بهذا الشكل، وبدون أي نصوص قبله أو بعده:
{{"percentage": 85, "feedback": "تعليق سعودي قصير جداً ومناسب للنسبة"}}
"""

    try:
        response = model.generate_content(prompt)
        # تحويل الرد لنص ثم لـ JSON
        return json.loads(response.text)

    except Exception as e:
        print(f"Error: {str(e)}")
        raise HTTPException(status_code=500, detail="فشل الاتصال بـ Gemini")

if __name__ == "__main__":
    import uvicorn
    # تأكد إنك شغال على localhost عشان المحاكي يلقط السيرفر
    uvicorn.run(app, host="127.0.0.1", port=8000)