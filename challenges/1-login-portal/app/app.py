import flask
from flask import Flask
from flask import request

import codecs
import base64

from .caller import caller, number

app = Flask("login")
app.register_blueprint(caller)

@app.route("/", methods=['GET', 'POST'])
def root():
    if check_data(request.cookies.get('data'), 'issignedin'):
        return flask.redirect('/verification')

    resp = flask.make_response(flask.render_template('login.html'))
    if 'data' not in request.cookies:
        resp.set_cookie('data', create_cookie({'issignedin': 'no', 'isadmin': 'no'}))
    return resp

@app.route("/login", methods=['GET', 'POST'])
def login():
    params = {
        'title': 'Login'
    }

    if check_data(request.cookies.get('data'), 'issignedin'):
        return flask.redirect('/verification')

    if request.method == 'GET':
        args = request.args
    if request.method == 'POST':
        args = request.form

    if 'username' in args and len(args['username']) == 0:
        return flask.render_template('login.html', **params, error='invalid username')
    elif 'password' in args and len(args['password']) == 0:
        return flask.render_template('login.html', **params, error='invalid password')
    elif 'username' in args and 'password' in args:
        return flask.render_template('login.html', **params, error='incorrect login credentials')

    resp = flask.make_response(flask.render_template('login.html', **params))
    if 'data' not in request.cookies:
        resp.set_cookie('data', create_cookie({'issignedin': 'no', 'isadmin': 'no'}))
    return resp

@app.route("/logout", methods=['GET', 'POST'])
def logout():
    resp = flask.make_response(flask.redirect('/'))
    resp.set_cookie('data', create_cookie({'issignedin': 'no', 'isadmin': 'no'}))
    return resp

@app.route("/verification", methods=['GET', 'POST'])
def verification():
    if check_data(request.cookies.get('data'), 'issignedin'):
        if check_data(request.cookies.get('data'), 'isadmin'):
            return flask.render_template(
                'secret.html',
                title='identify verifier',
                message='please call ' + number + ' to verify your identity'
            )
        else:
            title = 'unauthorized access'
            msg = "you're logged in, but not as the admin..."
            return flask.render_template('secret.html', title=title, message=msg)
    else:
        return flask.render_template('base.html', error='you can\'t do that')

def check_data(d, *keys, value='yes'):
    if not d:
        return False

    data = parse_cookie(d)
    for key in keys:
        if data.get(key) != value:
            return False

    return True

def create_cookie(cookie):
    parts = []
    for (key, value) in cookie.items():
        parts.append(f'{key}={value}')

    data = ';'.join(parts)
    # data = codecs.decode(data, 'rot13')
    data = base64.b64encode(data.encode('utf8'))

    return data

def parse_cookie(data):
    cookie = {}

    data = base64.b64decode(data).decode('utf8')
    # data = codecs.encode(data, 'rot13')
    parts = data.split(';')
    for part in parts:
        key, value = part.split('=')
        cookie[key] = value

    return cookie
