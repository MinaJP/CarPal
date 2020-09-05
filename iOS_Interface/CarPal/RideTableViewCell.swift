//
//  RideTableViewCell.swift
//  CarPal
//
//  Created by Mina on 16/5/2563 BE.
//  Copyright © 2563 Mina. All rights reserved.
//

import UIKit

class RideTableViewCell: UITableViewCell {
	let destinationLabel = UILabel()
    let originLabel = UILabel()
	let timeLabel = UILabel()



	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		 super.init(style: style, reuseIdentifier: reuseIdentifier)


		 let marginGuide = contentView.layoutMarginsGuide


		 contentView.addSubview(destinationLabel)
		 destinationLabel.translatesAutoresizingMaskIntoConstraints = false
		 destinationLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
		 destinationLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
		 destinationLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
		 destinationLabel.numberOfLines = 0


		 contentView.addSubview(originLabel)
		 originLabel.translatesAutoresizingMaskIntoConstraints = false
		 originLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
		 originLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
		 originLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
		 originLabel.topAnchor.constraint(equalTo: destinationLabel.bottomAnchor).isActive = true
		 originLabel.numberOfLines = 0
		 originLabel.textColor = UIColor.lightGray


		contentView.addSubview(timeLabel)
		timeLabel.translatesAutoresizingMaskIntoConstraints = false
		timeLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
		timeLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
		timeLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
		timeLabel.topAnchor.constraint(equalTo: originLabel.bottomAnchor).isActive = true
		timeLabel.numberOfLines = 0
		timeLabel.textColor = UIColor.lightGray
	 }

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
