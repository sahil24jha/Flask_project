from flask import Flask, request, render_template
from datetime import datetime
import requests

BACKEND_URL = 'http://127.0.0.1:9000'

app = Flask(__name__)

@app.route("/")
def home():
    return render_template('index.html')

#Submitting data
@app.route("/submit", methods=['POST'])
def submit():

    form_data = dict(request.form)
    
    requests.post(BACKEND_URL + '/submit', json=form_data)
    return 'Data submitted Successfully!'

#Displaying data from the backend, fetching data from mmongoDB
@app.route("/get_data")
def get_data():

    response = requests.get(BACKEND_URL+'/api')
    return response.json()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port = 8000, debug=True)