//
//  NetworkManager.swift
//  CarPal
//
//  Created by Mina on 6/5/2563 BE.
//  Copyright © 2563 Mina. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager {
	private static let getRide = "http://34.86.45.240/carshare/ride/"
	private static let postRide = "http://34.86.45.240/carshare/2/ride/"
	private static let getUserRide = "http://34.86.45.240/carshare/user/2/"


	static func getRide(rideInfo: Ride, _ didGetRides: @escaping ([Ride]) -> Void) {
		let parameter:Parameters = ["o": rideInfo.origin, "d":rideInfo.destination, "s":String(rideInfo.scheduled)]
		print("network is called")
		AF.request(getRide, method: .get, parameters: parameter).validate().responseJSON { response in switch response.result {

			case .success(let data):
				let json = JSON(data)

					//print("jsondat")
					//print(json)
					//print(json["data"])
					if let ridArray = json["data"].array{
						var result = [Ride]()
						for ridInfo in ridArray{
							let destination = ridInfo["destination"].string
							let origin = ridInfo["origin"].string
							let sched = ridInfo["scheduled"].int
							result.append(Ride(origin: origin ?? "not available", destination: destination ?? "not available", scheduled: sched!))
						}

						didGetRides(result)


				}


			case .failure(let error):
				print(error.localizedDescription)
			}

		}







}

	static func postRide(rideInfo: Ride, _ didPostRides: @escaping () -> Void){



		let parameter:Parameters = ["origin": rideInfo.origin, "destination":rideInfo.destination, "scheduled":rideInfo.scheduled]
		//print(parameter)

		AF.request(postRide, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in switch response.result {

			case .success(_):

				didPostRides()

			case .failure(let error):
			print(error)
			}


}
}


	static func getUserRide( _ didGetRides: @escaping ([Ride]) -> Void) {

	AF.request(getUserRide, method: .get).validate().responseJSON { response in switch response.result {

		case .success(let data):
			let json = JSON(data)

				//print("jsondat")
				//print(json)
				//print(json["data"])
				if let ridArray = json["data"]["rides_created"].array{
					var result = [Ride]()
					for ridInfo in ridArray{
						let destination = ridInfo["destination"].string
						let origin = ridInfo["origin"].string
						let sched = ridInfo["scheduled"].int
						result.append(Ride(origin: origin ?? "not available", destination: destination ?? "not available", scheduled: sched!))
					}

					didGetRides(result)
		}




		case .failure(let error):
			print(error.localizedDescription)
		}

	}

}
}
