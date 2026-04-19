import os
import google.generativeai as genai
from dotenv import load_dotenv

load_dotenv()
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

print("--- جاري البحث عن الموديلات المتاحة لمفتاحك ---")
try:
    for m in genai.list_models():
        if 'generateContent' in m.supported_generation_methods:
            print(f"الموديل الشغال: {m.name}")
except Exception as e:
    print(f"صار خطأ: {e}")