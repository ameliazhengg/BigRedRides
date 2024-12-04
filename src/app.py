from db import db, Ride, User, Trip
from flask import Flask, request
import json
from datetime import datetime


app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///rides.db"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db.init_app(app)
with app.app_context():
    db.create_all()

# Utility functions
def success_response(data, code=200):
    return json.dumps(data), code

def failure_response(message, code=404):
    return json.dumps({"error": message}), code

# Routes
# Get all rides
@app.route("/rides/", methods=["GET"])
def get_all_rides():
    rides = Ride.query.all()
    return success_response([ride.serialize() for ride in rides])

# Get a specific ride
@app.route("/rides/<int:ride_id>/", methods=["GET"])
def get_ride(ride_id):
    ride = Ride.query.get(ride_id)
    if not ride:
        return failure_response("Ride not found.")
    return success_response(ride.serialize())

# Create a new ride
@app.route("/rides/", methods=["POST"])
def create_ride():
    body = request.json
    try:
        # Parse the time string into a Python datetime object
        time = datetime.fromisoformat(body["time"])  # Converts "2024-12-04T10:30:00" to a datetime object
        
        # Check if user exists
        id = body.get("driver_id")
        existing_user = User.query.filter_by(id=id).first()
        if existing_user is None:
            return failure_response("Driver does not exist.", 400)
        
        # Create a new ride object
        new_ride = Ride(
            driver_id=body["driver_id"],
            departure=body["departure"],
            destination=body["destination"],
            time=time,  # Use the parsed datetime object here
            seats=body["seats"],
            price=body["price"],
            info=body.get("info"),
        )
        db.session.add(new_ride)
        db.session.commit()

        # Create a new trip
        new_trip = Trip(ride_id=new_ride.id, user_id=id, role="driver", status="confirmed")
        db.session.add(new_trip)
        db.session.commit()

        return success_response(new_ride.serialize(), 201)
    except KeyError as e:
        return failure_response(f"Missing field: {str(e)}", 400)
    except ValueError as e:
        return failure_response(f"Invalid datetime format: {str(e)}", 400)
    except Exception as e:
        return failure_response(str(e))

# Update a ride 
@app.route("/rides/<int:ride_id>/", methods=["PATCH"])
def update_ride(ride_id):
    ride = Ride.query.get(ride_id)
    if not ride:
        return failure_response("Ride not found.")
    
    body = request.json

    if "driver_id" in body:
        ride.driver_id = body["driver_id"]
    if "departure" in body:
        ride.departure = body["departure"]
    if "destination" in body:
        ride.destination = body["destination"]
    if "time" in body:
        try:
            ride.time = datetime.fromisoformat(body["time"])  # Convert to datetime object
        except ValueError:
            return failure_response("Invalid datetime format.", 400)
    if "seats" in body:
        ride.seats = body["seats"]
    if "price" in body:
        ride.price = body["price"]
    if "info" in body:
        ride.info = body["info"]
    if "status" in body:
        ride.status = body["status"]

    try:
        db.session.commit()
        return success_response(ride.serialize())
    except Exception as e:
        return failure_response(str(e))

# Delete a ride
@app.route("/rides/<int:ride_id>/", methods=["DELETE"])
def delete_ride(ride_id):
    ride = Ride.query.get(ride_id)
    if not ride:
        return failure_response("Ride not found.")
    
    associated_trips = Trip.query.filter_by(ride_id=ride_id).all()
    for trip in associated_trips:
        db.session.delete(trip)

    db.session.delete(ride)
    db.session.commit()

    return success_response({"message": "Ride deleted successfully."})

# Create a new user
@app.route("/users/", methods=["POST"])
def create_user():
    body = request.json
    email = body.get("email")

    # Check if email already exists
    existing_user = User.query.filter_by(email=email).first()
    if existing_user:
        return failure_response("Email already exists.", 400)

    # Proceed to create the user
    try:
        name = body["name"]
        new_user = User(name=name, email=email)
        db.session.add(new_user)
        db.session.commit()
        return success_response(new_user.serialize(), 201)
    except KeyError as e:
        return failure_response(f"Missing field: {str(e)}", 400)
    except Exception as e:
        return failure_response(str(e), 500)


# Get a specific user
@app.route("/users/<int:user_id>/", methods=["GET"])
def get_user(user_id):
    user = User.query.get(user_id)
    if not user:
        return failure_response("User not found.")
    return success_response(user.serialize())


# Get all trips
@app.route("/trips/", methods=["GET"])
def get_all_trips():
    try:
        trips = Trip.query.all()  # Fetch all trips from the database
        return success_response({"trips": [trip.serialize() for trip in trips]})
    except Exception as e:
        return failure_response(str(e), 500)

# Add a user to a trip
@app.route("/trips/", methods=["POST"])
def add_user_to_trip():
    body = request.json
    try:
        ride_id = body["ride_id"]
        user_id = body["user_id"]
        
        # Check if the ride exists
        ride = Ride.query.get(ride_id)
        if not ride:
            return failure_response("Ride not found.")

        # Check if the user exists
        user = User.query.get(user_id)
        if not user:
            return failure_response("User not found.")

        # Check if seats are available
        if ride.seats <= 0:
            return failure_response("No seats available.")

        # Create a new trip
        new_trip = Trip(ride_id=ride_id, user_id=user_id, role="rider", status="confirmed")
        ride.seats -= 1  # Reduce available seats
        if ride.seats == 0:
            ride.status = "full"
        db.session.add(new_trip)
        db.session.commit()

        # Return the trip details with driver information
        return success_response({
            "trip": new_trip.serialize(),
            "ride": {
                "ride_id": ride.id,
                "driver_id": ride.driver_id,
            }
        }, 201)
    except KeyError as e:
        return failure_response(f"Missing field: {str(e)}", 400)
    except Exception as e:
        return failure_response(str(e))
  
# Remove a user from a trip
@app.route("/trips/<int:trip_id>/", methods=["DELETE"])
def delete_user_from_trip(trip_id):
    body = request.json
    user_id = body.get("user_id")

    if not user_id:
        return failure_response("User ID is required.", 400)

    trip = Trip.query.get(trip_id)
    if not trip:
        return failure_response("Trip not found.")

    # Verify the user is part of the trip
    if trip.user_id != user_id:
        return failure_response("User does not belong to this trip.", 400)
    
    if trip.role == "driver":
        return failure_response("Cannot remove driver from trip.", 400)

    # Restore seat to the ride
    ride = Ride.query.get(trip.ride_id)
    if ride:
        ride.seats += 1
        if ride.status == "full":
            ride.status = "open"

    db.session.delete(trip)
    db.session.commit()

    # Check waitlist, create trip if exists
    if ride.waitlist:
        new_user = ride.waitlist.pop(0)
    
        new_trip = Trip(ride_id=ride.id, user_id=new_user.id, role="rider", status="confirmed")
        ride.seats -= 1  # Reduce available seats
        ride.status = "full"
        db.session.add(new_trip)
        db.session.commit()
        return success_response({"message": "User removed from trip successfully. Waitlist updated."})


    return success_response({"message": "User removed from trip successfully."})

# Update waitlist for a ride
@app.route("/rides/<int:ride_id>/waitlist/", methods=["POST"])
def update_waitlist_for_ride(ride_id):
    body = request.json
    user_id = body.get("user_id")
    ride = Ride.query.get(ride_id)
    if not ride:
        return failure_response("Ride not found.")

    user = User.query.get(user_id)
    if not user:
        return failure_response("User not found.")

    # Check if user is already in the waitlist
    if user in ride.waitlist:
        return failure_response("User is already in the waitlist.")

    # Add user to the waitlist
    ride.waitlist.append(user)
    db.session.commit()
    return success_response({"message": "Waitlist updated successfully."})

# Get trips based on user_id
@app.route("/users/<int:user_id>/trips/", methods=["GET"])
def get_trips_by_user(user_id):
    user = User.query.get(user_id)
    if not user:
        return failure_response("User not found.")

    trips = Trip.query.filter_by(user_id=user_id).all()
    return success_response([trip.serialize() for trip in trips])


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)

