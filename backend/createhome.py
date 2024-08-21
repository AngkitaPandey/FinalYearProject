from flask import Flask, request, jsonify
from config import get_db_reference
import uuid
from google.cloud import firestore

#Initialize Flask app
app = Flask(__name__)

#Reference to the Firebase Realtime DB
db_ref = get_db_reference()

# Helper function to generate a unique ID
def generate_unique_id():
    return str(uuid.uuid4())

# Create a new home listing
@app.route('/homes', methods=['POST'])
def create_home():
    data = request.json
    # home_id = db_ref.child('homes').push(data).key
    home_id = generate_unique_id()
    # Save the initial data to Firebase
    db_ref.child('homes').document(home_id).set({
        'propertyType': data.get('propertyType'),
        'roomType': data.get('roomType'),
        'isMainHome': data.get('isMainHome'),
        'createdAt': firestore.SERVER_TIMESTAMP
    })
    
    return jsonify({"homeId": home_id}), 201


# Get a home listing by ID
@app.route('/homes/<home_id>', methods=['GET'])
def get_home(home_id):
    home = db_ref.child('homes').child(home_id).get()
    if home:
        return jsonify(home.val()), 200
    return jsonify({"error": "Home not found"}), 404


# Update a home listing
@app.route('/homes/<home_id>', methods=['PUT'])
def update_home(home_id):
    data = request.json
    db_ref.child('homes').child(home_id).update(data)
    return jsonify({"message": "Home updated successfully"}), 200

# Update home location
@app.route('/homes/<home_id>/location', methods=['POST'])
def update_home_location(home_id):
    data = request.json
    location_data = {
        'location': data.get('location'),
        'latitude': data.get('latitude'),
        'longitude': data.get('longitude'),
        'localization': data.get('localization')
    }
    
    home_ref = db_ref.collection('homes').document(home_id)
    home_ref.update(location_data)
    
    return jsonify({"message": "Home location updated successfully"}), 200


# Delete a home listing
@app.route('/homes/<home_id>', methods=['DELETE'])
def delete_home(home_id):
    db_ref.child('homes').child(home_id).delete()
    return jsonify({"message": "Home deleted successfully"}), 200

if __name__ == '__main__':
    app.run(debug=True)