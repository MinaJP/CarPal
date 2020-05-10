from db import User, Ride, Request

#get user by id
#Parameter: id
#Precondition: id is a integer
def get_user_by_id(id):
    pass


#create new user
#Parameter: username
#Precondition: username is a nonempty string
def create_user(username):
    pass


#get a list of rides by destination and time
#Parameters: origin, destination, time
#Preconditions: origin is a nonempty string
#destination is a non empty string,
#time is time in Unix
def get_rides(origin, destination, time):
    pass


#create a ride
#Parameters: user_id, origin, destination, date
#Precondition:
#user_id is an integer
#origin is a nonempty string
#destination is a string
#time is time in Unix
def create_ride(user_id, origin, destination, time):
    pass


def delete_ride_by_id(user_id, ride_id):
    pass

#add another user to members list of a car ride
def update_ride_by_id(ride_id, member):
    pass


def create_request(ride_id, sender_id, message):
    pass


def update_request_by_id(request_id, response):
    pass
