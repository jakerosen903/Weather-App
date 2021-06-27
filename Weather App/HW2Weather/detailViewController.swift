//
//  detailViewController.swift
//  HW2Weather
//
//  Created by Jacob Rosen on 2/24/21.
//

import UIKit

class detailViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var forecastLabel: UILabel!
    
    
        var city: String = ""
        var temp: String = ""
        var forecast: String = ""
        var image: UIImage!
        
        override func viewDidLoad() {
            super.viewDidLoad()

            // Do any additional setup after loading the view.
            cityLabel.text = city
            tempLabel.text = temp
            forecastLabel.text = forecast
            weatherImage.image = image
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
