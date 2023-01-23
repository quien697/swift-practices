//
//  UserStatistics.swift
//  Habits
//
//  Created by Quien on 2023/1/21.
//

import Foundation

struct UserStatistics {
    let user: User
    let habitCounts: [HabitCount]
}

extension UserStatistics: Codable { }
