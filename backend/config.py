# config.py
import firebase_admin
from firebase_admin import credentials, db

#Path to Firebase credentials JSON file
CRED_PATH = "serviceAccountKey.json"
DB_URL = "https://homeswapping-2a524-default-rtdb.asia-southeast1.firebasedatabase.app/"

def initialize_firebase():
    cred = credentials.Certificate(CRED_PATH)
    firebase_admin.initialize_app(cred, {
        'databaseURL': DB_URL
    })

def get_db_reference(reference_path=""):
    return db.reference(reference_path)

#Initialize Firebase when this module is imported
initialize_firebase()
