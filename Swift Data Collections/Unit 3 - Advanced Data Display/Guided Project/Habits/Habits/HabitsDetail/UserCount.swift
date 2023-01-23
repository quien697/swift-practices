//
//  UserCount.swift
//  Habits
//
//  Created by Quien on 2023/1/21.
//

import Foundation

struct UserCount {
  let user: User
  let count: Int
}

extension UserCount: Codable { }

extension UserCount: Hashable {
  func hash(into hasher: inout Hasher) {
      hasher.combine(user)
  }
  static func ==(_ lhs: UserCount, _ rhs: UserCount) -> Bool {
      return lhs.user == rhs.user
  }
}
