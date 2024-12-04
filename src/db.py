from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

# driver_table = db.Table("drivers", db.Model.metadata,
#                         db.Column("ride_id", db.Integer, db.ForeignKey("rides.id")),
#                         db.Column("driver.id", db.Integer, db.ForeignKey("users.id")))
# rider_table = db.Table("riders", db.Model.metadata,
#                         db.Column("ride_id", db.Integer, db.ForeignKey("rides.id")),
#                         db.Column("rider.id", db.Integer, db.ForeignKey("users.id")))

class Ride(db.Model):
    __tablename__ = "rides"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    driver_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    driver_name = db.Column(db.String, nullable=False)
    departure = db.Column(db.String, nullable=False)
    destination = db.Column(db.String, nullable=False)
    time = db.Column(db.DateTime, nullable=False)
    seats = db.Column(db.Integer, nullable=False)
    price = db.Column(db.Integer, nullable=False)
    info = db.Column(db.String, nullable=True)

    def __init__(self, **kwargs):
        self.driver_id = kwargs.get("driver_id", "")
        self.driver_name = kwargs.get("driver_name", "")
        self.departure = kwargs.get("departure", "")
        self.destination = kwargs.get("destination", "")
        self.seats = kwargs.get("seats", "")
        self.price = kwargs.get("price","")
        self.info = kwargs.get("info")

    def serialize(self):
        return {
            "id": self.id,
            "driver_id": self.driver_id,
            "driver_name": self.driver_name,
            "departure": self.departure,
            "destination": self.destination,
            "time": self.time,
            "seats": self.seats,
            "price": self.price,
            "info": self.info
        }



class User(db.Model):
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)
    email = db.Column(db.String, nullable=False)

    def __init__(self, **kwargs):
        self.name = kwargs.get("name", "")
        self.email = kwargs.get("email", "")

    def serialize(self):
        return {"id": self.id, "name": self.name, "email": self.email}

class Trip(db.Model):
    __tablename__ = "trips"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    driver_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    rider_id = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    status = db.Column(db.String, nullable=False)

    def serialize(self):
        return {
            "id": self.id,
            "driver_id": self.driver_id,
            "rider_id": self.rider_id,
            "status": self.status,
        }
