//
//  Room.swift
//  HomeFurniture
//
//  Created by Quien on 2023/1/2.
//

import Foundation

class Room {
  let name: String
  let furniture: [Furniture]
  
  init(name: String, furniture: [Furniture]) {
    self.name = name
    self.furniture = furniture
  }
}
