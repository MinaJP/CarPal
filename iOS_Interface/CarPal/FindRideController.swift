//
//  FindRideController.swift
//  CarPal
//
//  Created by Mina on 16/5/2563 BE.
//  Copyright © 2563 Mina. All rights reserved.
//

import UIKit

class FindRideController: UIViewController, UITableViewDataSource, UITableViewDelegate{

	var lab = UILabel()
	var tableView = UITableView()
    let rideCellIdentifier = "RideCell"
	var ride: [Ride] = []
	var rideinfo: Ride

	init(rideinfo:Ride){
		self.rideinfo = rideinfo
		super.init(nibName: nil, bundle: nil)

	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		NetworkManager.getRide(rideInfo: rideinfo){(ride) in
			self.ride = ride
			if ride.isEmpty{self.navigationItem.title = "No Available ride consider creating your own" }
			self.tableView.reloadData()
			//print(ride)
		}
	
		navigationItem.title = "Available Scheduled Ride"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self , action: #selector(addRide))
		tableView.dataSource=self
		tableView.register(RideTableViewCell.self, forCellReuseIdentifier: rideCellIdentifier)
		view.addSubview(tableView)

		tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true





    }

	@objc func addRide(){
		NetworkManager.postRide(rideInfo: rideinfo){
			let alert = UIAlertController(title: "Ride Added", message: "Your ride has been added", preferredStyle: UIAlertController.Style.actionSheet )
			let dismiss = UIAlertAction(title:"dismiss",style: .default)
			alert.addAction(dismiss)
			self.present(alert, animated: true, completion: nil)
		}

	}


	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return ride.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//		let dateForm = DateFormatter()
//		dateForm.dateStyle = .medium
//		dateForm.timeStyle = .medium
		let cell = tableView.dequeueReusableCell(withIdentifier: rideCellIdentifier, for: indexPath) as! RideTableViewCell

		cell.destinationLabel.text = ride[indexPath.row].destination
		//print(cell.destinationLabel.text ?? "nothing here some thing wrong")
		let dateForm = DateFormatter()
		dateForm.dateStyle = .medium
		dateForm.timeStyle = .medium
		let date = NSDate(timeIntervalSince1970:TimeInterval(ride[indexPath.row].scheduled))

		 cell.originLabel.text = "Origin: \(ride[indexPath.row].origin)   Scheduled:\(dateForm.string(from: date as Date))"

		print(ride[indexPath.row].scheduled)

		print(date)
		print(dateForm.string(from: date as Date))
		

		cell.timeLabel.text = "Scheduled: \(dateForm.string(from: date as Date))"


		 return cell
	}



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
