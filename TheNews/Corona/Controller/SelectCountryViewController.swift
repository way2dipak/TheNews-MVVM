//
//  SelectCountryViewController.swift
//  TheNews
//
//  Created by DS on 13/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit

protocol CountryDelegate {
    func didSelectCountry(name: String, code: String)
}

class SelectCountryViewController: BaseViewController {

    var delegate: CountryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

extension SelectCountryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.shared.country.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.identifier) as! CountryTableViewCell
        cell.countryNameLabel.text = Global.shared.country[indexPath.row].name.capitalized
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let details = Global.shared.country[indexPath.row]
        delegate?.didSelectCountry(name: details.name.capitalized, code: details.alpha2code)
        self.dismiss(animated: true, completion: nil)
    }
}


class CountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countryNameLabel: UILabel!
    
    
}
