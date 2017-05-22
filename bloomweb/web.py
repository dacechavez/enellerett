from flask import Flask
from flask import render_template, request, redirect, jsonify


app = Flask(__name__)

@app.route('/')
def index():
	return render_template("index.html")

@app.route('/substantiv', methods=['POST'])
def substantiv_post():
    return jsonify(
        answer="en"
    ) 

@app.errorhandler(404)
def page_not_found(e):
    return render_template('404.html'), 404

if __name__ == '__main__':
	app.run(debug=True)
