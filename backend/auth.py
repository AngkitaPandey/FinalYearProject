import bcrypt
from flask import Flask, request, jsonify
from config import get_db_reference

# Initialize the Flask app 
app = Flask(__name__)

# Register endpoint
@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    # Extract user details from the request
    first_name = data.get('first_name')
    last_name = data.get('last_name')
    email = data.get('email')
    password = data.get('password')
 
    if not first_name or not last_name or not email or not password:
        return jsonify({'error': 'Missing data'}), 400
    
    try:
        # Check if user already exists
        ref = get_db_reference('users')
        users = ref.order_by_child('email').equal_to(email).get()

        if users:
            return jsonify({'error': 'User already exists'}), 400
        
        # Hash the password
        hashed_password = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())

        # Save user to realtime database
        ref.push({
            'first_name': first_name, 
            'last_name': last_name,
            'email': email,
            'password': hashed_password.decode('utf-8')
        })

        return jsonify({'message': 'User registered successfully'}), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# Login endpoint
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    # Extract user details from the request
    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({'error': 'Missing email or password'}), 400
    
    try:
        # Check if user exists
        ref = get_db_reference('users')
        users = ref.order_by_child('email').equal_to(email).get()
        
        if not users:
            return jsonify({'error': 'User not found'}), 404

        # Get the user data
        user = list(users.values())[0]

        # Verify password
        if not bcrypt.checkpw(password.encode('utf-8'), user['password'].encode('utf-8')):
            return jsonify({'error': 'Incorrect password'}), 401

        return jsonify({'message': 'Login successful'}), 200
    
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
# if __name__ == "__main__":
#     app.run(host='0.0.0.0', port=5000)

