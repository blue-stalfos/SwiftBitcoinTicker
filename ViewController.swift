//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD",
						 "IDR","ILS","INR","JPY","MXN","NOK","NZD",
						 "PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""

	//MARK: - IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		currencyPicker.delegate = self
		currencyPicker.dataSource = self
    }

	//MARK: - UIPickerView
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return currencyArray.count
	}
    
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return currencyArray[row]
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		print(currencyArray[row])
		
		finalURL = baseURL + currencyArray[row]
		print(finalURL)
		
		getPriceData(url: finalURL)
	}
	
    //MARK: - Networking
    /***************************************************************/
	
    func getPriceData(url: String) {
		Alamofire.request(url, method: .get).responseJSON {
			response in if response.result.isSuccess {
//				print("Success! Got the cryptocurrency data")
				let cryptoJSON: JSON = JSON(response.result.value!)
//				print(cryptoJSON)

				self.updatePriceData(json: cryptoJSON)
			} else {
				print("Error: \(String(describing: response.result.error))")
				self.bitcoinPriceLabel.text = "Connection Issues"
			}
		}
    }


    //MARK: - JSON Parsing
    /***************************************************************/
	
    func updatePriceData(json: JSON) {
        if let cryptoResult = json["ask"].double {
			self.bitcoinPriceLabel.text = String(cryptoResult)
//			print(cryptoResult)
        } else {
			self.bitcoinPriceLabel.text = "Unknown"
		}
	}
}
