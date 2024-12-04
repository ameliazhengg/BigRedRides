from db import db
from flask import Flask
from flask import request
import json
from db import db, Ride, User, Trip

app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///rides.db"
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db.init_app(app)
with app.app_context():
    db.create_all()

# Utility functions
def success_response(data, code=200):
    return json.dumps(data), code, {"Content-Type": "application/json"}

def failure_response(message, code=404):
    return json.dumps({"error": message}), code, {"Content-Type": "application/json"}

# Routes
@app.route("/rides", methods=["GET"])
def get_all_rides():
    rides = Ride.query.all()
    return success_response([ride.serialize() for ride in rides])

@app.route("/rides/<int:ride_id>", methods=["GET"])
def get_ride(ride_id):
    ride = Ride.query.get(ride_id)
    if not ride:
        return failure_response("Ride not found.")
    return success_response(ride.serialize())

@app.route("/rides", methods=["POST"])
def create_ride():
    body = request.json
    try:
        new_ride = Ride(
            driver_id=body["driver_id"],
            driver_name=body["driver_name"],
            departure=body["departure"],
            destination=body["destination"],
            time=body["time"],
            seats=body["seats"],
            info=body.get("info")
        )
        db.session.add(new_ride)
        db.session.commit()
        return success_response(new_ride.serialize(), 201)
    except Exception as e:
        return failure_response(str(e))

@app.route("/rides/<int:ride_id>", methods=["POST"])
def update_ride(ride_id):
    ride = Ride.query.get(ride_id)
    if not ride:
        return failure_response("Ride not found.")
    body = request.json
    ride.driver_name = body.get("driver_name", ride.driver_name)
    ride.departure = body.get("departure", ride.departure)
    ride.destination = body.get("destination", ride.destination)
    ride.time = body.get("time", ride.time)
    ride.seats = body.get("seats", ride.seats)
    ride.info = body.get("info", ride.info)
    db.session.commit()
    return success_response(ride.serialize())

@app.route("/rides/<int:ride_id>", methods=["DELETE"])
def delete_ride(ride_id):
    ride = Ride.query.get(ride_id)
    if not ride:
        return failure_response("Ride not found.")
    db.session.delete(ride)
    db.session.commit()
    return success_response({"message": "Ride deleted successfully."})

@app.route("/users", methods=["POST"])
def create_user():
    body = request.json
    try:
        new_user = User(name=body["name"], email=body["email"])
        db.session.add(new_user)
        db.session.commit()
        return success_response(new_user.serialize(), 201)
    except Exception as e:
        return failure_response(str(e))

@app.route("/users/<int:user_id>", methods=["GET"])
def get_user(user_id):
    user = User.query.get(user_id)
    if not user:
        return failure_response("User not found.")
    return success_response(user.serialize())


@app.route("/trips", methods=["POST"])
def create_trip():
    body = request.json
    try:
        new_trip = Trip(
            driver_id=body["driver_id"],
            rider_id=body["rider_id"],
            status=body["status"]
        )
        db.session.add(new_trip)
        db.session.commit()
        return success_response(new_trip.serialize(), 201)
    except Exception as e:
        return failure_response(str(e))

@app.route("/trips/<int:user_id>", methods=["GET"])
def get_trips_by_user(user_id):
    trips = Trip.query.filter((Trip.driver_id == user_id) | (Trip.rider_id == user_id)).all()
    return success_response([trip.serialize() for trip in trips])

@app.route("/trips/<int:trip_id>", methods=["DELETE"])
def delete_trip(trip_id):
    trip = Trip.query.get(trip_id)
    if not trip:
        return failure_response("Trip not found.")
    db.session.delete(trip)
    db.session.commit()
    return success_response({"message": "Trip deleted successfully."})

@app.route("/trips/<int:user_id>/waitlist", methods=["POST"])
def update_waitlist(user_id):
    body = request.json
    ride_id = body.get("ride_id")
    ride = Ride.query.get(ride_id)
    if not ride:
        return failure_response("Ride not found.")
    # Add waitlist logic here (if needed)
    return success_response({"message": "Waitlist updated successfully."})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=True)