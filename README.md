Signup Form – Flask Microservices Project
📌 Project Overview

This project is a simple Signup Form application built using Flask with a microservice-style architecture:
Frontend Service (Port 8000) – Renders HTML form and communicates with backend
Backend API Service (Port 9000) – Handles data storage and retrieval
Data Storage – JSON file (users.json)

The application allows users to:
Submit signup details (Username, Email, Password)
Store data in a JSON file
Fetch stored user data via API

🏗 Architecture
User (Browser)
      ↓
Frontend Flask App (Port 8000)
      ↓
Backend Flask API (Port 9000)
      ↓
users.json (File Storage)

📂 Project Structure
project/
│
├── backend/
│   ├── app.py
│   └── users.json   (auto-created)
│
├── frontend/
│   ├── app.py
│   └── templates/
│       └── index.html
│
└── README.md

⚙️ Technologies Used
Python
Flask
HTML5

CSS3
JavaScript (Client-side validation)
JSON (File-based storage)
Requests library (Service-to-service communication)

🚀 How to Run the Project
1️⃣ Install Dependencies
pip install flask requests

2️⃣ Start Backend Server
Navigate to backend folder:

cd backend
python app.py

Backend runs on:
http://127.0.0.1:9000

3️⃣ Start Frontend Server
Open a new terminal:

cd frontend
python app.py

Frontend runs on:
http://127.0.0.1:8000

🌐 Available Routes
Frontend (Port 8000)
Route	Method	Description
/	GET	Signup form
/submit	POST	Sends form data to backend
/get_data	GET	Fetches data from backend
Backend (Port 9000)
Route	Method	Description
/submit	POST	Stores data in JSON file
/api	GET	Returns stored user data

📁 Example users.json
[
    {
        "username": "sahil",
        "email": "test@mail.com",
        "password": "Test@123"
    }
]

🔐 Features
Client-side password validation
Password strength indicator
Microservice-based structure
JSON-based persistent storage
REST-style API communication
