import subprocess
import time
import os

def run(cmd):
    print('running {}'.format(cmd))
    s = subprocess.run(cmd, check=True, stdout=subprocess.PIPE)
    return s.stdout.decode('utf-8')

def startkore():
    run(['kore', '-nrq', '-c', 'conf/webserver.conf'])

def stopkore():
    if not os.path.isfile('kore.pid'):
        return
    with open('kore.pid', 'r') as f:
        pid = f.read()[:-1]
    run(['kill', '-SIGQUIT', pid])
    time.sleep(1)

def curl(noun):
    url = 'https://127.0.0.1:8888/substantiv'
    return run(['curl', '-sk', '-d', 'noun={}'.format(noun), '-X', 'POST', url])

def test(noun, expected):
    was = curl(noun)
    if expected != was:
        print('Looked up [{}] and got back [{}] but expected [{}]'.format(noun, was, expected))

stopkore()
startkore()
test('öl', 'both')
test('stol', 'en')
test('bok', 'en')
test('penna', 'en')
test('bord', 'ett')
test('äpple', 'ett')
test('NULL', 'not found')
test('', 'error')
stopkore()
