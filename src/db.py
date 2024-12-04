from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

class Ride(db.Model):
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
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String, nullable=False)
    email = db.Column(db.String, nullable=False)

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
