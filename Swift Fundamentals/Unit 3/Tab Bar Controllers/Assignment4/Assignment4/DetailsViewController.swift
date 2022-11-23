//
//  DetailsViewController.swift
//  Assignment4
//
//  Created by Quien on 2022/11/20.
//  Copyright © 2022 Derrick Park. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
  
  let country: UILabel = {
    let lb = UILabel()
    lb.font = UIFont.boldSystemFont(ofSize: 20)
    lb.translatesAutoresizingMaskIntoConstraints = false
    return lb
  }()
  
  let name: UILabel = {
    let lb = UILabel()
    lb.font = UIFont.boldSystemFont(ofSize: 20)
    lb.translatesAutoresizingMaskIntoConstraints = false
    return lb
  }()
  
  let temp: UILabel = {
    let lb = UILabel()
    lb.font = UIFont.boldSystemFont(ofSize: 20)
    lb.translatesAutoresizingMaskIntoConstraints = false
    return lb
  }()
  
  let precipitation: UILabel = {
    let lb = UILabel()
    lb.font = UIFont.boldSystemFont(ofSize: 20)
    lb.translatesAutoresizingMaskIntoConstraints = false
    return lb
  }()
  
  let summary: UILabel = {
    let lb = UILabel()
    lb.font = UIFont.boldSystemFont(ofSize: 20)
    lb.translatesAutoresizingMaskIntoConstraints = false
    return lb
  }()

  lazy var vStackView: UIStackView = {
    let sv = UIStackView(arrangedSubviews: [country, name, temp, precipitation, summary])
    sv.translatesAutoresizingMaskIntoConstraints = false
    sv.axis = .vertical
    sv.alignment = .leading
    sv.distribution = .fillEqually
    sv.spacing = 20
    return sv
  }()
  
  var city: City! {
    didSet {
      country.text = "Country : \(city.icon)"
      name.text = "City : \(city.name)"
      temp.text = "Temperature : \(city.temp)"
      precipitation.text = "Precipitation : \(String(city.precipitation))"
      summary.text = "Summary : \(String(city.summary))"
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Detail of \(city.name)"
    view.backgroundColor = .white
    
    view.addSubview(vStackView)
    vStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
    vStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50).isActive = true
    vStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50).isActive = true
  }
}
