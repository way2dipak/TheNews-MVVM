//
//  SearchViewController.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit

class CoronaViewController: BaseViewController {
    
    enum HeaderSection {
        case country
        case dashboard
        case worldwide
    }
    
    @IBOutlet weak var coronaTableView: UITableView! {
        didSet {
            let refresh = UIRefreshControl()
            refresh.tintColor = .black
            self.coronaTableView.refreshControl = refresh
            refresh.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    var coronaArray = [CoronaViewModel]()
    var headerArray: [HeaderSection] = [.country, .dashboard, .worldwide]
    var countryArray: [CoronaViewModel] = []
    
    
    var cell = ChooseCountryTableViewCell()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentScreenType = .corona
        registerNib()
        setUpView()
        getCoronaStatusBy(country: "IN")
    }
    
    func setUpView() {
        //searchTableView.hideTableView(true)
        coronaTableView.estimatedRowHeight = 500
        coronaTableView.rowHeight = UITableView.automaticDimension
        coronaTableView.tableFooterView = UIView()
        cell = coronaTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ChooseCountryTableViewCell
    }
    
    func registerNib() {
        coronaTableView.register(UINib(nibName: ChooseCountryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ChooseCountryTableViewCell.identifier)
        coronaTableView.register(UINib(nibName: CoronaDashboardTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CoronaDashboardTableViewCell.identifier)
        coronaTableView.register(UINib(nibName: GlobalCaseTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: GlobalCaseTableViewCell.identifier)
    }
    
    @objc func refreshHandler() {
        //self.coronaTableView.refreshControl?.beginRefreshing()
        
    }
    
     func navigateToVC() {
        if Global.shared.country.count != 0 {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: SelectCountryViewController.identifier) as! SelectCountryViewController
        vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func getCoronaStatusBy(country code: String) {
        CoronaService().getCoronaResultByCountry(countryCode: code, result: {[weak self] (result) in
            self?.countryArray = result
            DispatchQueue.main.async {
                self?.coronaTableView.reloadData()
            }
        }) { (message) in
            self.displayAlert(title: "Error", message: message)
        }
    }
    
}

extension CoronaViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch headerArray[indexPath.row] {
        case .country:
            let cell = tableView.dequeueReusableCell(withIdentifier: ChooseCountryTableViewCell.identifier, for: indexPath) as! ChooseCountryTableViewCell
            cell.handler = { [weak self] in
                self?.navigateToVC()
            }
            return cell
        case .dashboard:
            let cell = tableView.dequeueReusableCell(withIdentifier: CoronaDashboardTableViewCell.identifier, for: indexPath) as! CoronaDashboardTableViewCell
            if countryArray.count != 0 {
                cell.setUpValue(details: countryArray[0])
            }
            return cell
        case .worldwide:
            let cell = tableView.dequeueReusableCell(withIdentifier: GlobalCaseTableViewCell.identifier, for: indexPath) as! GlobalCaseTableViewCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


extension CoronaViewController: CountryDelegate {
    func didSelectCountry(name: String, code: String) {
        cell.selectCountryButton.setTitle(name, for: .normal)
        getCoronaStatusBy(country: code)
    }
    
}
