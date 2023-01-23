//
//  LoggedHabit.swift
//  Habits
//
//  Created by Quien on 2023/1/21.
//

import Foundation

struct LoggedHabit {
  let userID: String
  let habitName: String
  let timestamp: Date
}

extension LoggedHabit: Codable { }
