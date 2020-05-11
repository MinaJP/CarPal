
from flask import Flask, request
import dao
import json
from db import db

# define dp
app = Flask(__name__)
db_filename = "carShare.db"

# config
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

# initialize app
db.init_app(app)
with app.app_context():
    db.create_all()


def success_response(data, code=200):
    return json.dumps({"success": True, "data": data}), code


def failure_response(message, code=404):
    return json.dumps({"success": False, "error": message}), code


def check_key(key, body):
    for a in key:
        inn = body.get(a, -1)
        # print(inn)
        if inn is -1:
            #print("key not found is" + str(a))
            return False, "key not found is" + str(a)
    return True


@app.route("/carshare/user/<int:user_id>/")
def get_a_user(user_id):
    user = dao.get_user_by_id(user_id)
    if user is None:
        return failure_response("user not found")
    return success_response(user)


@app.route("/carshare/user/", methods=['POST'])
def create_a_user():
    print("Creating a new user")
    body = json.loads(request.data)
    key = ("username")
    print("Checking for key")
    checkkey = check_key(key,body)
    if not checkkey:
        return failure_response(checkkey)
    username = body["username"]
    return success_response(dao.create_user(username))


@app.route("/carshare/ride/")
def find_rides():
    args = request.args
    print(args)
    key = ("o", "d", "s")
    check_args = check_key(key, args)
    if not check_args:
        return failure_response("incomplete information")
    origin = args["o"]
    destination = args["d"]
    scheduled = int(args["s"])
    print(origin, destination, scheduled)
    return success_response(dao.get_rides(origin, destination, scheduled))


@app.route("/carshare/<int:user_id>/ride/", methods=['POST'])
def create_ride(user_id):
    body = json.loads(request.data)
    verify_id = dao.get_user_by_id(user_id)
    if verify_id is None:
        return failure_response("invalid user id")

    key = ("origin", "destination", "scheduled")
    checkkey = check_key(key, body)
    if not check_key:
        return failure_response(checkkey)

    origin = body["origin"]
    destination = body["destination"]
    scheduled = body["scheduled"]
    return success_response(dao.create_ride(user_id, origin, destination, scheduled))


@app.route("/carshare/<int:user_id>/ride/<int:ride_id>/", methods=['DELETE'])
def delete_ride(user_id, ride_id):

    #Check if user owns this ride
    creator = dao.get_ride_by_id(ride_id)["creator"]
    if creator != user_id:
        return failure_response("You do not own this event.")

    ride = dao.delete_ride_by_id(ride_id)
    if ride is not None:
        return success_response(ride)
    return failure_response("ride not found")


@app.route("/carshare/<int:user_id>/request/<int:ride_id>/", methods=['POST'])
def request_ride(user_id, ride_id):
    body = json.loads(request.data)
    #Check if ride exists
    ride = dao.get_ride_by_id(ride_id)
    if ride is None:
        return failure_response("ride not exist")

    #Check if user exists
    sender = dao.get_user_by_id(user_id)
    if sender is None:
        return failure_response("not valid user id")

    #Check if data contains all required fields
    key = ("message")
    checkkey = check_key(key, body)
    if not check_key:
        return failure_response(checkkey)

    message = body["message"]
    receiver_id = ride["creator"]

    return success_response(dao.create_request(ride_id, user_id, receiver_id, message))


@app.route("/carshare/<int:user_id>/request/response/<int:request_id>/", methods=['POST'])
def update_request(user_id, request_id):
    #Check if request exists
    req = dao.get_request_by_id(request_id)
    if req is None:
        return failure_response("Request id is invalid.")

    #Check if user_id is the receiver_id of the request
    receiver = req["receiver_id"]
    if receiver != user_id:
        return failure_response("You do not have permission to change the status of this request.")


    ride_id = req["ride_id"]
    body = json.loads(request.data)

    #Check if the data body contains required keys
    key = ("accepted")
    checkkey = check_key(key, body)
    if not check_key:
        return failure_response(checkkey)

    #Check if the user has already answered to this request
    status = req["accepted"]
    if status is not None:
        return failure_response("You have changed the status of this request before.")

    response = body["accepted"]
    up = dao.update_ride_by_id(ride_id, req["sender_id"])

    if up is None:
        return failure_response("invalid ride or sender_id")

    return success_response(dao.update_request_by_id(request_id, response))


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
