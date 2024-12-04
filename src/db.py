from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

trips_table = db.Table("trips", db.Model.metadata,
    db.Column("ride_id", db.Integer, db.ForeignKey("rides.id")),
    db.Column("user_id", db.Integer, db.ForeignKey("users.id"))
)

class Ride(db.Model):
    """
    Ride Model
    """
    __tablename__ = "rides"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    driver_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False) 
    driver_name = db.Column(db.String, nullable=False)
    departure = db.Column(db.String, nullable=False)
    destination = db.Column(db.String, nullable=False)
    time = db.Column(db.DateTime, nullable=False)
    seats = db.Column(db.Integer, nullable=False)
    info = db.Column(db.String, nullable=True)

class User(db.Model):
    """
    User Model
    """
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)
    email = db.Column(db.String, nullable=False)

    def __init__(self, **kwargs):
        """
        Initializes a User
        """
        self.name = kwargs.get("name", "")
        self.email = kwargs.get("email", "")

    def serialize(self):
        """
        Returns a serialized user object
        """
        return {
            "id": self.id,
            "name": self.name,
            "email": self.email
        }

class Trip(db.Model):
    """
    Trip Model
    """
    __tablename__ = "trips"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    driver_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    rider_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    status = db.Column(db.String, nullable=False)

    def __init__(self, **kwargs):
        """
        Initializes a Trip
        """
        self.driver_id = kwargs.get("driver_id", None)
        self.rider_id = kwargs.get("rider_id", None)
        self.status = kwargs.get("status", "")

    def serialize(self):
        """
        Returns a serialized trip object
        """
        return {
            "id": self.id,
            "driver_id": self.driver_id,
            "rider_id": self.rider_id,
            "status": self.status
        }
