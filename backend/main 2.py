import os
import requests
import json
import io
import PyPDF2
import uvicorn
from fastapi import FastAPI, UploadFile, File, Form, Request
from fastapi.middleware.cors import CORSMiddleware
from groq import Groq

app = FastAPI()

# --- ⚙️ CORS CONFIG ---
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- 🔑 HINDSIGHT & GROQ CONFIG ---
HINDSIGHT_API_KEY = "hsk_9349e7d4effd6e330f36fed3d0e1539d_faa87a048101455b"
HINDSIGHT_CLUSTER_ID = "Thinker"
# Base URL for Hindsight Cloud API
HINDSIGHT_BASE_URL = "https://api.hindsight.vectorize.io/v1"

GROQ_API_KEY = "YOUR_GROQ_API_KEY_HERE"
client = Groq(api_key=GROQ_API_KEY)
MODEL_NAME = "llama-3.3-70b-versatile"

# --- 🧠 HINDSIGHT CORE FUNCTIONS ---

def inject_to_hindsight(text, filename, category):
    """Memory Injection using Header-based Cluster Routing"""
    url = f"{HINDSIGHT_BASE_URL}/inject"
    headers = {
        "Authorization": f"Bearer {HINDSIGHT_API_KEY}",
        "Content-Type": "application/json",
        "X-Hindsight-Cluster": HINDSIGHT_CLUSTER_ID  # Crucial fix for 404 errors
    }
    
    payload = {
        "documents": [
            {
                "content": text,
                "metadata": {
                    "source": filename,
                    "category": category
                }
            }
        ]
    }
    
    try:
        response = requests.post(url, headers=headers, json=payload)
        # Check your terminal: status 200 means it finally worked!
        print(f"DEBUG: Inject Status: {response.status_code} | Response: {response.text}")
        return response.status_code == 200
    except Exception as e:
        print(f"DEBUG: Injection Exception: {e}")
        return False

def recall_from_hindsight(query):
    """Contextual Recall from Hindsight Memory [cite: 4]"""
    url = f"{HINDSIGHT_BASE_URL}/recall"
    headers = {
        "Authorization": f"Bearer {HINDSIGHT_API_KEY}",
        "Content-Type": "application/json",
        "X-Hindsight-Cluster": HINDSIGHT_CLUSTER_ID
    }
    payload = {"query": query, "top_k": 5}
    
    try:
        response = requests.post(url, headers=headers, json=payload)
        if response.status_code == 200:
            results = response.json().get("results", [])
            return " ".join([r['content'] for r in results])
    except Exception as e:
        print(f"DEBUG: Recall Exception: {e}")
    return ""

# --- 🚀 API ENDPOINTS ---

@app.post("/upload")
async def upload_file(file: UploadFile = File(...), category: str = Form(...)):
    """Handles PDF/Text upload and stores in Hindsight [cite: 33]"""
    try:
        content = await file.read()
        text = ""
        
        if file.filename.lower().endswith(".pdf"):
            reader = PyPDF2.PdfReader(io.BytesIO(content))
            for page in reader.pages:
                text += (page.extract_text() or "")
        else:
            text = content.decode("utf-8")
        
        if len(text.strip()) == 0:
            return {"status": "error", "message": "No text found in file"}

        # Store in Hindsight Cloud [cite: 15]
        success = inject_to_hindsight(text, file.filename, category)
        
        if success:
            return {"status": "success"}
        else:
            return {"status": "error", "message": "Failed to sync with Hindsight Cloud"}
            
    except Exception as e:
        print(f"Upload Error: {e}")
        return {"status": "error", "message": str(e)}

@app.post("/chat")
async def chat(request: Request):
    """AI Study Companion Chat with Persistent Memory [cite: 35, 39]"""
    try:
        data = await request.json()
        history = data.get("history", [])
        user_query = history[-1]["content"] if history else ""
        
        # Recall relevant data from Hindsight [cite: 3]
        context = recall_from_hindsight(user_query)

        system_prompt = (
            "You are Thinkora, an AI Study Assistant. Use the provided context from "
            "the user's persistent memory to answer. Prioritize the memory data.\n\n"
            f"MEMORY CONTEXT:\n{context[:10000]}"
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
        return {"response": "I'm having trouble accessing my memory right now."}

@app.get("/dashboard_stats")
async def get_stats():
    """Dashboard metrics for the Hackathon Demo [cite: 101]"""
    return {
        "progress": 0.85,
        "streak": 7,
        "insights": {
            "status": "Hindsight Memory Online",
            "pyq_mastery": "75%",
            "recommendation": "Review the last PDF you uploaded."
        }
    }

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
