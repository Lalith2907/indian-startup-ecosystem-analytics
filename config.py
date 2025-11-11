# config.py
import os
from dotenv import load_dotenv

# Load from .env file
load_dotenv()

# Get password
password = os.getenv('DB_PASSWORD', '')

# Database config
DB_CONFIG = {
    'host': 'localhost',
    'port': 3306,
    'user': 'root',
    'password': password,
    'database': 'mini_project'
}

APP_TITLE = "Indian Startup Ecosystem Analytics Platform"
APP_ICON = ""
