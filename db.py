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
    requests_sent = db.relationship("requests", cascade = delete, foreign_keys = 'requests.sender_id' )
    requests_received = db.relationship("requests", cascade= delete, foreign_keys = 'receiver_id')
    rides_created = db.relationship("rides", cascade = delete)
    rides_joined = db.relationship("Ride", secondary = association_table_1, back_populates = "members")


class Ride(db.Model):
    __tablename__ = "rides"
    id = db.Column(db.Integer, primary_key=True)
    origin = db.Column(db.String, nullable = False)
    destination = db.Column(db.String, nullable = False)
    scheduled = db.Column(db.Integer, nullable = False)
    creator = db.Column(db.Integer, db.ForeignKey("user.id"), nullable=False)
    members = db.relationship("User", secondary = association_table_1, back_populates = "rides_joined")
    requests = db.relationship("rides", cascade = delete)


class Request(db.Model):
    __tablename__ = "requests"
    id = db.Column(db.Integer, primary_key=True)
    sender_id = db.relationship(db.Integer, db.ForeignKey("user.id"))
    receiver_id = db.relationship(db.Integer, db.ForeignKey("user.id"))
