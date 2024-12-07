from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

# Waitlist association table
waitlist_table = db.Table(
    "waitlist_table",
    db.Model.metadata,
    db.Column("ride_id", db.Integer, db.ForeignKey("rides.id")),
    db.Column("user_id", db.Integer, db.ForeignKey("users.id")),
)

class User(db.Model):
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)
    email = db.Column(db.String, nullable=False, unique=True)

    def __init__(self, **kwargs):
        self.name = kwargs.get("name")
        self.email = kwargs.get("email")

    def serialize(self):
        return {
            "id": self.id,
            "name": self.name,
            "email": self.email,
        }

class Ride(db.Model):
    __tablename__ = "rides"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    driver_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    departure = db.Column(db.String, nullable=False)
    destination = db.Column(db.String, nullable=False)
    time = db.Column(db.DateTime, nullable=False)
    seats = db.Column(db.Integer, nullable=False)
    price = db.Column(db.Float, nullable=False)
    info = db.Column(db.String, nullable=True)
    status = db.Column(db.String, default="open")  # 'open' or 'full'

    # Relationship for waitlisted users
    waitlist = db.relationship(
        "User",
        secondary=waitlist_table,
        backref="waitlisted_rides",
    )

    def __init__(self, **kwargs):
        self.driver_id = kwargs.get("driver_id")
        self.departure = kwargs.get("departure")
        self.destination = kwargs.get("destination")
        self.time = kwargs.get("time")
        self.seats = kwargs.get("seats")
        self.price = kwargs.get("price")
        self.info = kwargs.get("info")
        self.status = kwargs.get("status", "open")  # Default to 'open'

    def serialize(self):
        return {
            "id": self.id,
            "driver_id": self.driver_id,
            "departure": self.departure,
            "destination": self.destination,
            "time": self.time.isoformat() if self.time else None,
            "seats": self.seats,
            "price": self.price,
            "info": self.info,
            "status": self.status,
            "waitlist": [user.serialize() for user in self.waitlist],
        }

class Trip(db.Model):
    __tablename__ = "trips"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    ride_id = db.Column(db.Integer, db.ForeignKey("rides.id"), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    role = db.Column(db.String, nullable=False)  # 'driver' or 'rider'
    status = db.Column(db.String, nullable=False)  # 'confirmed' or 'waitlisted'

    def __init__(self, **kwargs):
        self.ride_id = kwargs.get("ride_id")
        self.user_id = kwargs.get("user_id")
        self.role = kwargs.get("role")
        self.status = kwargs.get("status", "confirmed")  # Default to 'confirmed'

    def serialize(self):
        return {
            "id": self.id,
            "ride_id": self.ride_id,
            "user_id": self.user_id,
            "role": self.role,
            "status": self.status,
        }

