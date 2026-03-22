import os
import PyPDF2
import json
import shutil
import uvicorn
from fastapi import FastAPI, UploadFile, File, Form, Request
from fastapi.middleware.cors import CORSMiddleware
from groq import Groq

app = FastAPI()

# --- 🔑 CONFIG ---
GROQ_API_KEY = "YOUR_GROQ_API_KEY_HERE"
client = Groq(api_key=GROQ_API_KEY)
MODEL_NAME = "llama-3.3-70b-versatile"

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
UPLOAD_PATH = os.path.join(BASE_DIR, "uploads")

CATEGORIES = ["syllabus", "notes", "pyqs", "history"]
for cat in CATEGORIES:
    os.makedirs(os.path.join(UPLOAD_PATH, cat), exist_ok=True)

app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"])

# --- 📁 HELPER: PDF READER ---
def get_context():
    full_text = ""
    for folder in ["notes", "syllabus"]:
        path = os.path.join(UPLOAD_PATH, folder)
        if not os.path.exists(path): continue
        files = [f for f in os.listdir(path) if f.lower().endswith(".pdf")]
        for f in files:
            try:
                with open(os.path.join(path, f), "rb") as pdf_file:
                    reader = PyPDF2.PdfReader(pdf_file)
                    for page in reader.pages:
                        full_text += (page.extract_text() or "") + " "
            except: pass
    return full_text.strip()

# --- 📤 UPLOAD ---
@app.post("/upload")
async def upload_file(file: UploadFile = File(...), category: str = Form(...)):
    try:
        save_dir = os.path.join(UPLOAD_PATH, category if category in CATEGORIES else "notes")
        file_path = os.path.join(save_dir, file.filename)
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        return {"status": "success"}
    except: return {"status": "error"}

# --- 📊 DASHBOARD STATS ---
@app.get("/dashboard_stats")
async def get_dashboard_stats():
    ctx_text = get_context()
    progress = min(len(ctx_text) / 50000, 1.0) if ctx_text else 0.0
    return {
        "progress": round(progress, 2),
        "streak": 7,
        "insights": {"pyq_mastery": "75%", "goal": "Daily Quiz", "blindspot": "Review ML", "recommendation": "Check new notes!"}
    }

# --- 🎯 QUIZ SYSTEM (STRICT) ---
@app.post("/generate_quiz")
async def generate_quiz(request: Request):
    try:
        data = await request.json()
        count = data.get("count", 5)
        context_text = get_context()
        if len(context_text) < 100:
            return {"quiz": [{"question": "Please upload notes first.", "options": ["OK"], "answer": "OK"}]}

        prompt = (
            f"CONTEXT:\n{context_text[:12000]}\n\n"
            f"Generate {count} MCQs. Return a JSON object with 'quiz' key as a LIST. "
            "Answer must match option text exactly."
        )
        chat_completion = client.chat.completions.create(
            model=MODEL_NAME,
            messages=[{"role": "system", "content": "You are a precise JSON generator."}, {"role": "user", "content": prompt}],
            response_format={"type": "json_object"}
        )
        return json.loads(chat_completion.choices[0].message.content)
    except: return {"quiz": []}

# --- 💬 FIXED: CHAT ENDPOINT ---
@app.post("/chat")
async def chat(request: Request):
    try:
        data = await request.json()
        history = data.get("history", [])
        context_text = get_context()

        system_prompt = (
            "You are a helpful Study Assistant. Use the following context from the user's notes "
            "to answer their questions. If the answer isn't in the notes, use your general knowledge "
            f"but prioritize the notes.\n\nCONTEXT:\n{context_text[:10000]}"
        )

        messages = [{"role": "system", "content": system_prompt}] + history

        completion = client.chat.completions.create(
            model=MODEL_NAME,
            messages=messages,
            temperature=0.7
        )
        return {"response": completion.choices[0].message.content}
    except Exception as e:
        print(f"Chat Error: {e}")
        return {"response": "Sorry, I'm having trouble connecting right now."}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
