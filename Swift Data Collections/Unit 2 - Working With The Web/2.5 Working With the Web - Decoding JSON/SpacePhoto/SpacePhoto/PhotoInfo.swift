//
//  PhotoInfo.swift
//  SpacePhoto
//
//  Created by Quien on 2023/1/5.
//

import Foundation

struct PhotoInfo: Codable {
  var title: String
  var date: String
  var url: URL
  var description: String
  var copyright: String?
  
  enum CodingKeys: String, CodingKey {
    case title
    case date
    case url
    case description = "explanation"
    case copyright
  }
}
