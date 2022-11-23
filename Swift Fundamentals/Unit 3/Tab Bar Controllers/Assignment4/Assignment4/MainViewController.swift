//
//  MainViewController.swift
//  Assignment4
//
//  Created by Quien on 2022/11/20.
//  Copyright © 2022 Derrick Park. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 5 cities
    let vancouver = City(name: "Vancouver", temp: 15, precipitation: 95, icon: "canada", summary: "Rainy")
    let verona = City(name: "Verona", temp: 22, precipitation: 20, icon: "italy", summary: "Cloudy")
    let tokyo = City(name: "Tokyo", temp: 24, precipitation: 40, icon: "japan", summary: "Sunny")
    let saoPaulo = City(name: "Sao Paulo", temp: 32, precipitation: 20, icon: "brazil", summary: "Sunny")
    let seoul = City(name: "Seoul", temp: 35, precipitation: 50, icon: "skorea", summary: "Sunny")
    
    let vanVC = CityViewController()
    vanVC.city = vancouver
    vanVC.tabBarItem = UITabBarItem(title: vancouver.name, image: UIImage(named: vancouver.icon), selectedImage: nil)
    let verVC = CityViewController()
    verVC.city = verona
    verVC.tabBarItem = UITabBarItem(title: verona.name, image: UIImage(named: verona.icon), selectedImage: nil)
    let tokVC = CityViewController()
    tokVC.city = tokyo
    tokVC.tabBarItem = UITabBarItem(title: tokyo.name, image: UIImage(named: tokyo.icon), selectedImage: nil)
    let spVC = CityViewController()
    spVC.city = saoPaulo
    spVC.tabBarItem = UITabBarItem(title: saoPaulo.name, image: UIImage(named: saoPaulo.icon), selectedImage: nil)
    let seoulVC = CityViewController()
    seoulVC.city = seoul
    seoulVC.tabBarItem = UITabBarItem(title: seoul.name, image: UIImage(named: seoul.icon), selectedImage: nil)
    let cities = [vanVC, verVC, tokVC, spVC, seoulVC]
    
    viewControllers = cities.map { UINavigationController(rootViewController: $0) }
  }
}
