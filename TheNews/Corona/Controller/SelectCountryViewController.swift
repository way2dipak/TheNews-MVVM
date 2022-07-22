//
//  SelectCountryViewController.swift
//  TheNews
//
//  Created by DS on 13/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit

protocol CountryDelegate {
    func didSelectCountry(value: Country)
}

class SelectCountryViewController: BaseViewController {

    @IBOutlet weak var vwPicker: UIPickerView!
    
    var delegate: CountryDelegate?
    var countryList = [Country]()
    var selectedCountry = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedCountry != "" {
            if let row = countryList.firstIndex(where: { $0.country?.lowercased() ?? "" == selectedCountry.lowercased() }) {
                vwPicker.selectRow(row, inComponent: 0, animated: false)
            }
        }
    }

}

extension SelectCountryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryList.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countryList[row].country?.capitalized ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let details = countryList[row]
        delegate?.didSelectCountry(value: details)
        self.dismiss(animated: true, completion: nil)
    }

}

class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryNameLabel: UILabel!
    
    
}
