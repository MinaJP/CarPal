//
//  ViewController.swift
//  CarPal
//
//  Created by Mina on 6/5/2563 BE.
//  Copyright © 2563 Mina. All rights reserved.
//

import GoogleMaps
import GooglePlaces
import UIKit

class ViewController: UIViewController {
    var mapView: GMSMapView!
    var resultsViewController: GMSAutocompleteViewController?
    var destinationButton: UIButton!
	var searchButton: UIButton!
	var originField: UITextField!
    let space = CGFloat(8)
    var place: String?
	var time: Int?
    // var datePicker:UIDatePicker!
    var dateTextField: UITextField!
	var datePickerView:UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red


		navigationItem.title = "CarPal"
		let centeredParagraphStyle = NSMutableParagraphStyle()
		centeredParagraphStyle.alignment = .center
		originField = UITextField()
		let fieldOPlaceholder = NSAttributedString(string: "Enter you Origin", attributes: [NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
		originField.attributedPlaceholder = fieldOPlaceholder
		originField.textAlignment = .center
        originField.contentHorizontalAlignment = .center
        originField.backgroundColor = .white
        originField.layer.shadowColor = .init(genericGrayGamma2_2Gray: 20, alpha: 10)
        originField.layer.shadowOffset = CGSize(width: 0, height: 5)
        originField.font = UIFont.systemFont(ofSize: 20, weight: .medium)
		originField.textColor = .gray
		originField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(originField)

		searchButton = UIButton()
		searchButton.backgroundColor = .blue
		searchButton.setTitle("Search Ride", for: .normal)
		searchButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
		searchButton.setTitleColor(.white, for: .normal)
	searchButton.translatesAutoresizingMaskIntoConstraints = false
		searchButton.addTarget(self, action: #selector(searchTab), for: .touchUpInside)

        view.addSubview(searchButton)





        destinationButton = UIButton()
        let im = UIImage(named: "Im2")
        destinationButton.setImage(im, for: .normal)
        destinationButton.imageView?.isHidden = false
        // destinationButton.imageView?.sizeToFit()
        // destinationButton.imageView?.trailingAnchor.constraint(equalTo: destinationButton.trailingAnchor).isActive=true

        // destinationButton.semanticContentAttribute = .forceRightToLeft
        destinationButton.titleLabel?.textAlignment = .left
        destinationButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)

        // destinationButton.imageView?.frame = CGRect(origin: center, size: 20 )
        // print(destinationButton.imageView!)

        destinationButton.setTitle("Where to?", for: .normal)

        destinationButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 30)
        destinationButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        destinationButton.setTitleColor(.gray, for: .normal)
        destinationButton.setTitleShadowColor(.lightGray, for: .normal)
        //		destinationButton.layer.cornerRadius = 5
//        destinationButton.layer.borderColor = UIColor.blue.cgColor
//        destinationButton.layer.borderWidth = 1

        // destinationButton.ti
        destinationButton.backgroundColor = .white
        destinationButton.layer.shadowColor = .init(genericGrayGamma2_2Gray: 20, alpha: 10)
        destinationButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        destinationButton.layer.borderColor = UIColor.black.cgColor
        destinationButton.contentHorizontalAlignment = .leading
        destinationButton.translatesAutoresizingMaskIntoConstraints = false
        destinationButton.addTarget(self, action: #selector(presentSearch), for: .touchUpInside)
        view.addSubview(destinationButton)

        dateTextField = UITextField()

		let attributedPlaceholder = NSAttributedString(string: "Schedule the ride", attributes: [NSAttributedString.Key.paragraphStyle: centeredParagraphStyle])
		dateTextField.attributedPlaceholder = attributedPlaceholder


        dateTextField.textAlignment = .center
        dateTextField.contentHorizontalAlignment = .center
        dateTextField.backgroundColor = .white
        dateTextField.layer.shadowColor = .init(genericGrayGamma2_2Gray: 20, alpha: 10)
        dateTextField.layer.shadowOffset = CGSize(width: 0, height: 5)
        dateTextField.font = UIFont.systemFont(ofSize: 20, weight: .medium)
		dateTextField.textColor = .gray
		datePickerView = UIDatePicker()
		let currentDate = NSDate()
		let topbar = UIToolbar(frame: CGRect(origin: view.center, size: CGSize(width: view.frame.width, height: 40)))
		topbar.barStyle = .default
		let cancelBut = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTap))
		let doneBut = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTap))
		let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		topbar.items = [cancelBut, space, doneBut]

		datePickerView.minimumDate = currentDate as Date
		datePickerView.backgroundColor = .white
		dateTextField.inputAccessoryView = topbar
		dateTextField.inputView = datePickerView

        dateTextField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(dateTextField)

        //		datePicker=UIDatePicker()
        //		datePicker.frame = CGRect(x: 10, y: 100, width: self.view.frame.width, height: 150)
        //		datePicker.datePickerMode = .dateAndTime
        //		datePicker.timeZone = NSTimeZone.local
        //		datePicker.backgroundColor = UIColor.white
        //		view.addSubview(datePicker)

        let camera = GMSCameraPosition.camera(withLatitude: 42.443962, longitude: -76.501884, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: view.frame, camera: camera)
        mapView.setMinZoom(10, maxZoom: 20)

        mapView.settings.scrollGestures = true
        mapView.settings.zoomGestures = true


        view.addSubview(mapView)
        view.bringSubviewToFront(destinationButton)
        // view.bringSubviewToFront(datePicker)
        view.bringSubviewToFront(dateTextField)
		view.bringSubviewToFront(searchButton)
		view.bringSubviewToFront(originField)

        //		let marker = GMSMarker()
        //		marker.position = CLLocationCoordinate2D(latitude: 42.443962, longitude: -76.501884)
        //		marker.map = mapView

        setUpConstraint()

        // Do any additional setup after loading the view.
    }

    func setUpConstraint() {
        NSLayoutConstraint.activate([destinationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), destinationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space), destinationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space), destinationButton.heightAnchor.constraint(equalToConstant: 70), destinationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -370)])

        NSLayoutConstraint.activate([dateTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor), dateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space), dateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space), dateTextField.heightAnchor.constraint(equalToConstant: 70), dateTextField.topAnchor.constraint(equalTo: destinationButton.bottomAnchor, constant: 10)])
		NSLayoutConstraint.activate([searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space), searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space), searchButton.heightAnchor.constraint(equalToConstant: 70), searchButton.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 10)])

		NSLayoutConstraint.activate([originField.centerXAnchor.constraint(equalTo: view.centerXAnchor), originField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space), originField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space), originField.heightAnchor.constraint(equalToConstant: 70), originField.bottomAnchor.constraint(equalTo: destinationButton.topAnchor, constant: -10)])


    }

    func resetButton() {
        destinationButton.setTitle(place, for: .normal)
        destinationButton.imageView?.isHidden = true
    }

    @objc func presentSearch() {
        let placePickerController = GMSAutocompleteViewController()
        placePickerController.delegate = self
        present(placePickerController, animated: true, completion: nil)
    }

	@objc func doneTap(){
		let dateForm = DateFormatter()
		dateForm.dateStyle = .medium
		dateForm.timeStyle = .medium
		let date = datePickerView.date
		let scheduled = date.timeIntervalSince1970 as Double
		let time = Int(scheduled)
		print(time)
		self.time = time
		dateTextField.text=dateForm.string(from: datePickerView.date)
		dateTextField.resignFirstResponder()


	}

	@objc func cancelTap(){
		dateTextField.resignFirstResponder()
	}
	@objc func searchTab(){
		let rideInfo = Ride(origin: originField.text ?? "RPCC", destination: place ?? "Syracuse", scheduled: time ?? Int(NSDate.now.timeIntervalSince1970 as Double))

		let vc = FindRideController(rideinfo: rideInfo)

		navigationController?.pushViewController(vc, animated: true)


	}
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        //		let placeName = place.name
        //		let placeId = place.placeID
        //		print("\(String(describing: placeName))")
        //		print("\(String(describing: placeId))")
        self.place = place.name
        resetButton()
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        if destinationButton.titleLabel!.text != "Where to?" {
            destinationButton.imageView?.isHidden = true
        }
        dismiss(animated: true, completion: nil)
    }
}
