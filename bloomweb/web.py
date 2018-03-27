from flask import Flask, render_template, request
from subprocess import run, PIPE
import re


app = Flask(__name__)
p = re.compile("^[\wåäö]+\s*([\wåäö]+\s*)*$", re.IGNORECASE)

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def index(path):
    return render_template("index.html")

@app.route('/substantiv', methods=['POST'])
def substantiv_post():
    noun = request.form['noun']
    if not p.match(noun):
        return "_evil"
    print('got: [{}]'.format(noun))
    noun = noun.lower().strip()
    res = run(["../bloomcmd/bloomcmd.out", "-w", noun], stdout=PIPE)
    gender = 'Substantivet "{}" hittades inte'.format(noun)
    if res.returncode == 3:
        gender = 'En {}'.format(noun)
    elif res.returncode == 4:
        gender = 'Ett {}'.format(noun)
    elif res.returncode == 5:
        gender = 'En eller ett {} beroende på kontext'.format(noun)

    return gender

if __name__ == '__main__':
    app.run(debug=False)
