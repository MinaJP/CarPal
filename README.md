<h1> CarPal </h1> 
<p> Project is in progress. </p>
<p> A ride-sharing IOS app that allows Cornell students to schedule rides with fellow students who depart from and arrive at similar locations. </p>


<h2> Address: </h2>
    http://34.86.45.240 (down)

<h2> Database Tables </h2>

<h3> User: </h3>

    Fields:
    id: unique user id,
    username,
    requests_sent: requests to join other's people's rides, 
    requests_received: requests from others to join your ride(s),
    rides_created,
    rides_joined

<h3> Ride: </h3>

    Fields:
        id: unique ride id,
        origin: starting place of the ride,
        destination: ending place of the ride,
        scheduled: time the ride leaves in Unix,
        creator: id of the creator,
        members: id of people joining the ride,
        requests: requests to join this ride

<h3> Requests: </h3>

    Fields:
        id: unique request id,
        time: time the request is sent,
        sender_id: id of the sender,
        receiver_id: id of the owner of the ride,
        ride_id: id of the ride,
        message: message from sender to receiver,
        accepted: status of the request


<h2> API Specification: </h2>

<h4> get a user </h4>
        `GET "/carshare/user/{user_id}/"
        Response
            {
            "success": true,
            "data": {            
                "id": <ID>,
                "username":<USER INPUT FOR USERNAME>
                "scheduled_ride": [ <SERIALIZED RIDE>, ... ],
                "requests": [<SERIALIZED REQUEST>, ... ]
            }`


    create a user
    POST "/carshare/user/"
        Request
            {
            "username": <USER INPUT>
            }
        Response
            {
            "success": true,
            "data": {            
                "id": <ID>,
                "username":<USER INPUT FOR USERNAME>
                "scheduled_ride": [],
                "requests": []
                }
            }


    Get rides that start at the same location, end in the same destination, and scheduled to be 
    within 24 hours starting from the desired time input
    GET "/carshare/ride/"
    parameter -o query by origin
    parameter -d query by destination
    parameter -s query by time (unix)
        Response
            {
            "success": true,
            "data": {
                "id": <id>,
                "origin": <USER INPUT FOR ORIGIN>,
                "destination": <USER INPUT FOR DESTINATION>,
                "scheduled": <USER INPUT FOR scheduled>,
                "creator": <USER ID>
                "members" [<SERIALIZED USER WITHOUT RIDE and REQUEST FIELD>, ... ]
                "request": [<SERIALIZED REQUEST WITHOUT RIDE FIELD>, ... ]    
                }
                {
                ...
                }
            }


    Create a ride
    POST "/carshare/{user_id}/ride/"
        Request
            {
            "origin": <USER INPUT for ORIGIN>
            "destination":<USER INPUT FOR DESTINATION>,
            "scheduled":<USER INPUT FOR scheduled>,
            }
        Response
            {
            "success": true,
            "data": {
                "id": <id>,
                "origin": <USER INPUT FOR ORIGIN>,
                "destination": <USER INPUT FOR DESTINATION IN UNIX>,
                "scheduled": <USER INPUT FOR scheduled>,
                "creator": <USER_ID>
                "members" []
                "request": []    
                }
            }


    Delete scheduled ride plan
    DELETE "/carshare/{user_id}/ride/{ride_id}/"
    NOTE: Verify that user_id is the owner of the ride
        Response:
            {
            "success": true,
            "data": {
                "id": <ID>,
                "timestamp": <NOW>,
                "creator": <ID OF OWNER OF THE RIDE>,
                "ride_id": <RIDE ID>,
                "message": <USER INPUT FOR MESSAGE>,
                "accepted": <USER INPUT FOR ACCEPTED>
                }    
            }


    Create Request to join ride
    POST "/carshare/{user_id}/request/{ride_id}"
        Request
            {
            "message":<USER INPUT FOR MESSAGE>
            }
        Response
            {
            "success": true,
            "data": {
                "id": <ID>,
                "timestamp": <NOW>,
                "sender_id": <ID OF USER>,
                "receiver_id": <ID OF OWNER OF THE RIDE>,
                "ride_id": <RIDE ID>,
                "message": <USER INPUT FOR MESSAGE>,
                "accepted": null
                }    
            }


    POST "/carshare/{user_id}/request/response/{request_id}"
        Request
            {
            "accepted": true or false
            }
        Response
            {
            "success": true,
            "data": {
                "id": <ID>,
                "timestamp": <NOW>
                "sender_id": <USER INPUT FOR SENDER_ID>,
                "creator": <ID OF OWNER OF THE RIDE>,
                "ride_id": <RIDE ID>,
                "message": <USER INPUT FOR MESSAGE>,
                "accepted": <USER INPUT FOR ACCEPTED>
                }    
            }


<h2> Future Development: </h2>

    Frontend use the id to request the user info (will need to change to credential and extra layer if do authentication)

    a client should not be able to get access to all available user

    a client should be able to request users that fit the search
    can be implement by
    -using parameter and query string (more automate and can handle different combination of parameter work)
    -using / / like was done in HW (we know how, might cause error if the input not exact)

    Find rides should be able to search for rides within a radius of the starting and ending locations.

    Mark requests false if ride's scheduled time passes current timestamp

    Mark rides completed if ride's scheduled time passes current timestamp
