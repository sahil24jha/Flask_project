from flask import Flask, request, jsonify
import json
import os
from threading import Lock

app = Flask(__name__)

DATA_FILE = "users.json"
file_lock = Lock()

def read_data():
    if not os.path.exists(DATA_FILE):
        return []
    with open(DATA_FILE, "r") as f:
        return json.load(f)

def write_data(data):
    with open(DATA_FILE, "w") as f:
        json.dump(data, f, indent=4)

@app.route("/")
def home():
    return "Backend running"

@app.route("/backend/submit", methods=["POST"])
def submit():
    form_data = dict(request.json)
    with file_lock:
        data = read_data()
        data.append(form_data)
        write_data(data)
    return "Data submitted successfully!"

@app.route("/backend/api")
def view():
    with file_lock:
        data = read_data()
    return jsonify({"data": data})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=9000, debug=True)