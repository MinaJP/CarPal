# BackendFinalProj

Element Planning:

I am thinking we should have 3 tables(this is just planing if u don't like or it doesn't make sense let me know)

User:

Store data on user information, and scheduled ride

Client should be able to create a user: -> user id is stored in frontend
frontend use the id to request the user info (will need to change to credential and extra layer if do authentication)

a client should not be able to get access to all available user

a client should be able to request users that fit the search
can be implement by
-using parameter and query string (more automate and can handle different combination of parameter work)
-using / / like was done in HW (we know how, might cause error if the input not exact)


Ride:

store information on ride id, date,  time, origin, destination, and mode of transportation of the ride
also creator of the ride and the users who will be joining the ride


Request:

Is similar to transaction table we did for venmo
  (how should this be done? other users request the owner of ride to join? owner request other to join? either one or both which one?)
contain information on the request to join Ride
So contain request_id, sender_id, receiver_id, ride_id, accepted, and message

will need to think and define sender and receiver

  Need:

    get request by user_id(sender and receiver)
    post request(create post)
    post request(accepted request)


Basic Flow/interaction

  -first time user, no stored id -> prompt to create a user -> make a  
   post request ->store the user id in the app(change to credential if do auth)
  -have user id ->prompt to search for ride-> get request->return relevant    
   existing ride
  -Show the result of the return on a table with option to purpose/create    
   own ride, (if return None -> display no relevant ride available at this time consider creating you own)
  -if click existing ride-> prompt user to request to join ride->make
   post request to the owner of the ride
  -if click create my own, use existing data(handle in frontend) ->make post   
   request, create ride







API Specification:
    get a user
    GET "carshare/user/{user_id}/"
    Response
      {
      "success": true,
      "data": {            
            "id": <ID>,
            "username":<USER INPUT FOR USERNAME>
            "scheduled_ride": [ <SERIALIZED RIDE>, ... ],
            "requests": [<SERIALIZED REQUEST>, ... ]
          }
    create a user
    POST "carshare/user/"
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

    Get relevant ride available
    GET "carshare/ride/"
    parameter -d query by destination
    parameter -s query by time (unix)
    NOTE: maybe we can choose all time within the time interval EX 1 day
    Response
      {
        "success": true,
        "data": {
            "id": <id>,
            "destination": <USER INPUT FOR DESTINATION>,
            "scheduled": <USER INPUT FOR scheduled>,
            "completed": <USER INPUT FOR completed>,
            "owner": <USER ID>
            "details":<USER INPUT FOR details>,
            "members" [<SERIALIZED USER WITHOUT RIDE and REQUEST FIELD>, ... ]
            "request": [<SERIALIZED REQUEST WITHOUT RIDE FIELD>, ... ]    
        }
      }

    Create ride
    POST "carshare/ride/{user_id}/"
    Request
      {
        "destination":<USER INPUT FOR DESTINATION>,
        "scheduled":<USER INPUT FOR scheduled>,
        "details":<USER INPUT FOR details>
      }

    Response
      {
        "success": true,
        "data": {
            "id": <id>,
            "destination": <USER INPUT FOR DESTINATION>,
            "scheduled": <USER INPUT FOR scheduled>,
            "completed": False,
            "creator": <USER_ID>
            "members" []
            "request": []    
        }
      }
      Delete scheduled ride plan
      DELETE "carshare/ride/{user_id}/{ride_id}/"
      NOTE: Verify that user_id is the owner of the ride
        {
          "success": true,
          "data": <DELETED RIDE>
        }


      Create Request to join ride
      POST "carshare/request/{ride_id}"
      user who want to join send request
        Request
          {
            "sender_id":<USER ID>
            "message":<USER INPUT FOR MESSAGE>
          }
        Response
          {
            "success": true,
            "data": {
                "id": <ID>,
                "timestamp": <NOW>,
                "sender_id": <USER INPUT FOR SENDER_ID>,
                "owner_id": <ID OF OWNER OF THE RIDE>,
                "ride_id": <RIDE ID>,
                "message": <USER INPUT FOR MESSAGE>,
                "accepted": null
              }    
            }

      Accept "carshare/request/{request_id}"
        Request
          {
            "accepted": true or false
          }

        Response
          {
            "success": true,
            "data": {
                "id": <ID>,
                "timestamp": <NOW> / update timestamp to time of accept/deny
                "sender_id": <USER INPUT FOR SENDER_ID>,
                "owner_id": <ID OF OWNER OF THE RIDE>,
                "ride_id": <RIDE ID>,
                "message": <USER INPUT FOR MESSAGE>,
                "accepted": <USER INPUT FOR ACCEPTED>
              }    
            }
