from flask import Flask, render_template, request
from subprocess import run, PIPE
import re


# Flask app instance
app = Flask(__name__)
p = re.compile("^[a-zåäö]+$", re.IGNORECASE)

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def index(path):
    return render_template("index.html")

@app.route('/substantiv', methods=['POST'])
def substantiv_post():
    noun = request.form['noun']
    if not p.match(noun):
        return "_evil"
    print('got: {}'.format(noun))
    noun = noun.lower()
    res = run(["../bloomcmd/bloomcmd.out", "-w", noun], stdout=PIPE)
    gender = 'The noun "{}" was not found'.format(noun)
    if res.returncode == 3:
        gender = 'En {}'.format(noun)
    elif res.returncode == 4:
        gender = 'Ett {}'.format(noun)
    return gender

if __name__ == '__main__':
	app.run(debug=False)
