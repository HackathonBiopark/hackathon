#!/usr/bin/python3

from api import app
from flask import Flask

app = Flask(__name__)

if __name__ == "__main__":
    app.run()