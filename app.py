
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
    body = json.loads(request.data)
    key = ("username")
    check_key, error = check_key(key, body)
    if not check_key:
        return failure_response(error)
    username = body["username"]
    return success_response(dao.create_user(username))


@app.route("/carshare/ride/")
def find_rides():
    args = request.args
    print(args)
    key = ("o", "d", "s")
    check_args, error = check_key(key, args)
    if not check_args:
        return failure_response("incomplete information")
    origin = args["o"]
    destination = args["d"]
    scheduled = args["s"]
    print(origin, destination, scheduled)
    return success_response(dao.get_rides(origin, destination, scheduled))


@app.route("/carshare/ride/<int:user_id>/", methods=['POST'])
def create_ride():
    body = json.loads(request.data)
    verify_id = dao.get_user_by_id(user_id)
    if verify_id is None:
        return failure_response("invalid user id")
    key = ("origin", "destination", "scheduled")
    check_key, error = check_key(key, body)
    if not check_key:
        return failure_response(error)
    origin = body["origin"]
    destination = body["destination"]
    scheduled = body["scheduled"]
    return success_response(dao.create_ride(user_id, origin, destination, scheduled))


# would be good if can verify if the user_id match the owner of the ride id
@app.route("/carshare/ride/{user_id}/{ride_id}/", methods=['DELETE'])
def delete_ride():
    ride = dao.delete_by_id(ride_id)
    if ride is not None:
        return success_response(ride)
    return failure_response("ride not found")


@app.route("/carshare/request/<int:ride_id>", methods=['POST'])
def request_ride(ride_id):
    ride = dao.get_ride_by_id(ride_id)
    if ride is None:
        return failure_response("ride not exist")
    receiver_id = ride["creator"]
    body = json.loads(request.data)
    key = ("sender_id", "message")
    check_key, error = check_key(key, body)
    if not check_key:
        return failure_response(error)
    sender_id = body["sender_id"]
    user = dao.get_user_by_id(sender_id)
    if user in None:
        return failure_response("not valid user id")
    message = body["message"]
    return success(dao.create_request(ride_id, sender_id, receiver_id, message))


@app.route("/carshare/request/<int:request_id>", methods=['POST'])
def update_request(request_id):
    req = dao.get_request_by_id(request_id)
    if req is None:
        return failure_response("request id is invalid")
    member_id = req["sender_id"]
    ride_id = req["ride_id"]
    body = json.loads(request.data)
    key = ("accepted")
    check_key, error = check_key(key, body)
    if not check_key:
        return failure_response(error)
    re = body["accepted"]
    if re:
        up = dao.update_ride_by_id(ride_id, member_id)
        if up is None:
            return failure_response("invalid ride or sender_id")
    return success_response(dao.update_request_by_id(request_id, re))


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
