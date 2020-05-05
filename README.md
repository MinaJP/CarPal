# BackendFinalProj

Element Planning:

I am thinking we should have 3 tables(just for planing) if it doesn't make sense let me know

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

GET "carshare/user/{id}/"
Response{
  "success": true,
  "data": {            
        "id": <ID>,
        "username":<USER INPUT FOR USERNAME>
        "email":<USER INPUT>
        "scheduled_ride"
        "requests"


}
