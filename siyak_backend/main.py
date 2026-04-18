import os
import json
import re
import requests
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from dotenv import load_dotenv

load_dotenv()
app = FastAPI()

# إعدادات Groq
GROQ_API_KEY = os.getenv("GROQ_API_KEY")
URL = "https://api.groq.com/openai/v1/chat/completions"

class GuessRequest(BaseModel):
    user_explanation: str
    target_word: str
    correct_meaning: str

@app.post("/analyze")
async def analyze_meaning(request: GuessRequest):
    
    # البرومبت المحدث لتعزيز اللهجة السعودية والروح الشعبية
    prompt = f"""
    يا خبيرنا، نبيك تقيم شرح خوينا للكلمة التراثية هذي.
    الكلمة: {request.target_word}
    المعنى الحقيقي: {request.correct_meaning}
    شرح المستخدم: {request.user_explanation}
    
    المطلوب منك:
    1- تقيم النسبة المئوية لقرب الشرح من المعنى الحقيقي.
    2- تكتب تعليق (feedback) بلهجة سعودية بيضاء وشعبية (مثلاً: "جبتها يا ذيب"، "حولها وحواليها"، "ما غبت عنها يا شقردي"، "يبيلك شوية تركيز").
    
    ردك لازم يكون JSON فقط بهذا الشكل:
    {{"percentage": 85, "feedback": "نص التعليق باللهجة السعودية"}}
    """

    headers = {
        "Authorization": f"Bearer {GROQ_API_KEY}",
        "Content-Type": "application/json"
    }

    payload = {
        "model": "llama-3.3-70b-versatile",
        "messages": [
            {
                "role": "system", 
                "content": "أنت خبير لغوي في اللهجات السعودية والتراث الشعبي السعودي. كلامك دايم شعبي، مشجع، ومليان بالعبارات السعودية المعروفة."
            },
            {"role": "user", "content": prompt}
        ],
        "response_format": {"type": "json_object"},
        "temperature": 0.7 # رفعنا الـ temperature شوي عشان يعطي تنوع في الكلمات السعودية وما يكرر نفسه
    }

    try:
        response = requests.post(URL, headers=headers, json=payload)
        
        if response.status_code != 200:
            return {"percentage": 0, "feedback": "علق السيرفر يا غالي، جرب مرة ثانية."}

        res_data = response.json()
        content = res_data['choices'][0]['message']['content']
        
        return json.loads(content)

    except Exception as e:
        print(f"Error: {str(e)}")
        raise HTTPException(status_code=500, detail="فشل الاتصال بـ Groq")

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)