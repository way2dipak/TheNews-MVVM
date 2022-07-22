//
//  SearchViewController.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit

class CoronaViewController: BaseViewController {
    
    @IBOutlet weak var coronaTableView: UITableView! {
        didSet {
            let refresh = UIRefreshControl()
            refresh.tintColor = UIColor(named: "DarkPink")
            self.coronaTableView.refreshControl = refresh
            refresh.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    var vwModel = CoronaViewModel()
    
    var selectedCountry: Country?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        vwModel.fetchCoronaWorldWideSummary()
        vwModel.refreshUI = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.selectedCountry = self.vwModel.getDefaultCountryDetails()
                self.coronaTableView.refreshControl?.endRefreshing()
                self.coronaTableView.reloadData()
            }
        }
    }
    
    func registerNib() {
        coronaTableView.register(UINib(nibName: ChooseCountryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: ChooseCountryTableViewCell.identifier)
        coronaTableView.register(UINib(nibName: CoronaDashboardTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CoronaDashboardTableViewCell.identifier)
        coronaTableView.register(UINib(nibName: GlobalCaseTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: GlobalCaseTableViewCell.identifier)
    }
    
    @objc func refreshHandler() {
        self.coronaTableView.refreshControl?.beginRefreshing()
        vwModel.fetchCoronaWorldWideSummary()
    }
    
    func navigateToVC() {
        if vwModel.getAllCountryList().count != 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: SelectCountryViewController.identifier) as! SelectCountryViewController
            vc.countryList = vwModel.getAllCountryList()
            vc.selectedCountry = selectedCountry?.country ?? ""
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension CoronaViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vwModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch vwModel.sectionNameBasedOnRows(index: indexPath) {
        case .country:
            let cell = tableView.dequeueReusableCell(withIdentifier: ChooseCountryTableViewCell.identifier, for: indexPath) as! ChooseCountryTableViewCell
            cell.details = selectedCountry
            cell.handler = { [weak self] in
                self?.navigateToVC()
            }
            return cell
        case .dashboard:
            let cell = tableView.dequeueReusableCell(withIdentifier: CoronaDashboardTableViewCell.identifier, for: indexPath) as! CoronaDashboardTableViewCell
            cell.details = selectedCountry
            return cell
        case .worldwide:
            let cell = tableView.dequeueReusableCell(withIdentifier: GlobalCaseTableViewCell.identifier, for: indexPath) as! GlobalCaseTableViewCell
            cell.details = vwModel.coronaDetails?.global
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


extension CoronaViewController: CountryDelegate {
    func didSelectCountry(value: Country) {
        selectedCountry = value
        coronaTableView.reloadData()
    }
    
}
