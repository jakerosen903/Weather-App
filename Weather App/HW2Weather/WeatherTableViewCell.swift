//
//  WeatherTableViewCell.swift
//  HW2Weather
//
//  Created by Jacob Rosen on 2/24/21.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
