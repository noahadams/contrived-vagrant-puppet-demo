from flask import Flask
import config

app = Flask(__name__)

# Load Configuration
app.config.from_object(config)

@app.route('/')
def root():
    return 'Hello, World!'