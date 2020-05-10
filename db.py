from flask_sqlalchemy import SQLAlchemy
db = SQLAlchemy()


association_table_1 = db.Table("user-ride", db.Model.metadata,
    db.Column("user_id", db.Integer, db.ForeignKey("users.id")),
    db.Column("ride_id", db.Integer, db.ForeignKey("rides.id"))
)



class User(db.Model):
    __tablename__ = "users"
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String, nullable=False)
    requests_sent = db.relationship("Request", cascade = "delete", foreign_keys = 'requests.sender_id' )
    requests_received = db.relationship("Request", cascade= "delete", foreign_keys = 'requests.receiver_id')
    rides_created = db.relationship("Ride", cascade = "delete")
    rides_joined = db.relationship("Ride", secondary = association_table_1, back_populates = "members")


    def serialize(self):
        return {
        "id": self.id,
        "username": self.username,
        "requests_sent": [r.serialize() for r in self.requests_sent],
        "requests_received": [r.serialize() for r in self.requests_received],
        "rides_created": [r.serialize2() for r in self.rides_created],
        "rides_joined": [r.serialize2() for r in self.rides_joined],
        }


    def serialize2(self):
        return{
        "id": self.id,
        "username": self.username
        }



class Ride(db.Model):
    __tablename__ = "rides"
    id = db.Column(db.Integer, primary_key=True)
    origin = db.Column(db.String, nullable = False)
    destination = db.Column(db.String, nullable = False)
    scheduled = db.Column(db.Integer, nullable = False)
    creator = db.Column(db.Integer, db.ForeignKey("users.id"), nullable=False)
    members = db.relationship("User", secondary = association_table_1, back_populates = "rides_joined")
    requests = db.relationship("Ride", cascade = "delete")


    def serialize(self):
        return {
        "id": self.id,
        "origin": self.origin,
        "destination": self.destination,
        "scheduled": self.scheduled,
        "creator": self.creator,
        "members": [m.serialize2() for m in self.members],
        "requests": [request.serialize() for request in self.requests]
        }


    def serialize2(self):
        return {
        "id": self.id,
        "origin": self.origin,
        "destination": self.destination,
        "scheduled": self.scheduled,
        }



class Request(db.Model):
    __tablename__ = "requests"
    id = db.Column(db.Integer, primary_key=True)
    time = db.Column(db.Integer, nullable = False)
    sender_id = db.relationship(db.Integer, db.ForeignKey("users.id"))
    receiver_id = db.relationship(db.Integer, db.ForeignKey("users.id"))
    ride_id = db.relationship(db.Integer, db.ForeignKey("rides.id"))
    message = db.Column(db.String, nullable = False)
    accepted = db.Column(db.Boolean)


    def serialize():
        res = {
        "id": self.id,
        "time": self.time,
        "sender_id": self.sender_id,
        "receiver_id": self.receiver_id,
        "ride_id": self.ride_id,
        "message": self.message,
        }
        if accepted is not None:
            res["accepted"] = self.accepted
        return res
