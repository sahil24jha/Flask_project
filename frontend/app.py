from flask import Flask, request, render_template
import requests
import os

BACKEND_URL = os.environ.get('BACKEND_URL', 'http://127.0.0.1:9000')

app = Flask(__name__)

@app.route("/")
def home():
    return render_template('index.html')

@app.route("/submit", methods=['POST'])
def submit():
    form_data = {
        "username": request.form.get("username"),
        "email": request.form.get("email"),
        "password": request.form.get("password"),
        "confirmPassword": request.form.get("confirmPassword")
    }
    response = requests.post(BACKEND_URL + '/backend/submit', json=form_data)
    return 'Data submitted Successfully!'

@app.route("/get_data")
def get_data():
    response = requests.get(BACKEND_URL + '/backend/api')
    return response.json()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)