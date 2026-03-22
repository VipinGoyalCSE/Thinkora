🧠 Thinkora: AI Study Companion with Persistent Memory
Thinkora is a next-generation learning platform designed to solve the "context-loss" problem in traditional AI tutors. By leveraging Vectorize Hindsight, Thinkora creates a permanent memory bank for students, allowing the AI to recall past notes, syllabus details, and previous year questions (PYQs) during active chat sessions.

🚀 The Problem & Our Solution
The Problem: Most AI tutors forget the context once the session ends. Students have to re-upload notes or explain their doubts multiple times.

Our Solution: Thinkora uses a persistent Hindsight Memory Cluster. Once a student uploads a document, it is "injected" into the AI's long-term memory, enabling it to provide highly personalized and factually accurate guidance.

🛠️ Tech Stack
Frontend: Flutter (State management via Riverpod)

Backend: FastAPI (Python 3.10+)

Memory Engine: Vectorize Hindsight (High-performance Vector Storage)

LLM: Llama 3.3 70B (Powered by Groq for sub-second responses)

PDF Processing: PyPDF2 & BytesIO

📂 Project Structure
Plaintext
Thinkora_Hindsight_Project/
├── exam_pilot/             # Flutter Frontend Project
│   ├── lib/
│   │   ├── screens/        # Knowledge Vault, Chat, Dashboard
│   │   ├── providers/      # Riverpod Logic
│   │   └── services/       # API Integration
├── backend/                # Python FastAPI Server
│   ├── main.py             # Core logic with Hindsight & Groq
│   └── requirements.txt    # Backend dependencies
└── README.md
⚙️ Setup & Installation
1. Backend Setup
Bash
cd backend
pip install -r requirements.txt
# Update your API Keys in main.py
python main.py
2. Frontend Setup
Bash
cd exam_pilot
flutter pub get
flutter run
🧠 Hindsight Integration Details
We implemented two core Hindsight features:

Injection (/inject): Automatically parses PDF text and stores it in the Thinker cluster with specific metadata (Category: Syllabus/Notes/PYQs).

Recall (/recall): Before every AI response, we query the Hindsight cluster to fetch the top 5 most relevant context snippets from the user's personal study library.

👨‍💻 Developed By
Vipin Goyal (VipinGoyalCSE) - Full Stack Developer & AI Integration

Ab ye commands chalao taaki ye README GitHub par dikhne lage:
Bash
git add README.md
git commit -m "Added professional README for Hackathon judging"
git push origin main
