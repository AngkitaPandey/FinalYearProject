import firebase_admin
from firebase import firebase
from firebase_admin import credentials
from firebase_admin import db

#Fetch the service account key JSON file contents
cred = credentials.Certificate('serviceAccountkey.json')

#Initialise the app with a service account, granting admin privileges
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://homeswapping-2a524-default-rtdb.asia-southeast1.firebasedatabase.app/'
})

#save data
ref = db.reference('py/')
users_ref = ref.child('users')
users_ref.set({
    'alanisawesome': {
        'date_of_birth': 'June 23, 1912',
        'full_name': 'Alan Turing'
    },
    'gracehop': {
        'date_of_birth': 'December 9, 1906',
        'full_name': 'Grace Hopper'
    }
})   
#read data
handle = db.reference('py/users/alainisawesome')  
#read the data at the posts reference
print(ref.get())  
