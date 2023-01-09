//
//  PhotoInfo.swift
//  WorkingWithTheWeb
//
//  Created by Quien on 2023/1/8.
//

import Foundation

struct PhotoInfo: Codable {
  var title: String
  var description: String
  var url: URL
  var copyright: String?
  
  enum CodingKeys: String, CodingKey {
    case title
    case description = "explanation"
    case url
    case copyright
  }
}
