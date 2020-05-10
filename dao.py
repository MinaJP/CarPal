from db import User, Ride, Request
import time
# get user by id
# Parameter: id
# Precondition: id is a integer


def get_user_by_id(id):
    usr = User.query.filter_by(id=id).first()
    if usr is not None:
        return usr.serialize()
    return usr


# create new user
# Parameter: username
# Precondition: username is a nonempty string
def create_user(username):
    newU = User(username=username)
    db.session.add(newU)
    db.session.commit()
    return newU.serialize()


# get a list of rides by destination and time
# Parameters: origin, destination, time
# Preconditions: origin is a nonempty string
# destination is a non empty string,
# time is time in Unix
def get_rides(origin, destination, time):
    interval = 24 * 60 * 60
    rides = Ride.query.filter(Ride.origin.like("%" + origin + "%")).\
        filter(Ride.destination.like("%" + destination + "%")).\
        filter(Ride.scheduled.between(time - interval, time + interval)).all()
    return [r.serialize() for r in rides]


# create a ride
# Parameters: user_id, origin, destination, date
# Precondition:
# user_id is an integer
# origin is a nonempty string
# destination is a string
# time is time in Unix
def create_ride(user_id, origin, destination, time):
    newR = Ride(origin=origin, destination=destination,
                scheduled=time, creator=user_id)
    db.session.add(newR)
    db.session.commit()
    return newR.serialize()


def delete_ride_by_id(ride_id):
    rde = Ride.query.filter_by(id=ride_id).first()
    if rde is None:
        return rde
    db.session.delete(rde)
    db.session.commit()
    return rde.serialize()


def get_ride_by_id(ride_id):
    ride = Ride.query.filter_by(id=ride_id).first()
    if ride is not None:
        return ride.serialize()
    return ride


# add another user to members list of a car ride
def update_ride_by_id(ride_id, member_id):
    ride = Ride.query.filter_by(id=ride_id)
    member = User.query.filter_by(id=member_id)
    if member is None or ride is None:
        return None
    ride.members.append(member)
    db.session.commit()


def create_request(ride_id, sender_id, receiver_id, message):
    t = int(time.time())
    req = Request(time=t, sender_id=sender_id,
                  receiver_id=receiver_id, message=message, accepted=None)
    db.session.add(req)
    db.session.commit()
    return req.serialize()


def get_request_by_id(request_id):
    req = Request.query.filter_by(id=request_id).first()
    if req is not None:
        return req.serialize()
    return req


def update_request_by_id(request_id, response):
    req = Request.query.filter_by(id=request_id)
    req.accepted = response
    db.session.commit()
    return req.serialize()
