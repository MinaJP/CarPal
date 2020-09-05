//
//  Ride.swift
//  CarPal
//
//  Created by Mina on 16/5/2563 BE.
//  Copyright © 2563 Mina. All rights reserved.
//

import Foundation
import UIKit

struct Ride: Codable {
    let origin: String
    let destination: String
	let scheduled: Int
}


//struct GetRide: Codable {
//	let id: Int
//    let origin: String
//    let destination: String
//	let scheduled: Int
//	let creator: Int
//
//}


struct RideSearchResponse: Codable {
    var results: [Ride]
}





