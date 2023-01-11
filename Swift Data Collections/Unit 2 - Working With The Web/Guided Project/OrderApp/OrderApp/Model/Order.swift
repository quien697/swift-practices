//
//  Order.swift
//  OrderApp
//
//  Created by Quien on 2023/1/10.
//

import Foundation

struct Order: Codable {
  var menuItems: [MenuItem]
  
  init(menuItems: [MenuItem] = []) {
    self.menuItems = menuItems
  }
}
