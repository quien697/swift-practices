//
//  CombinedStatistics.swift
//  Habits
//
//  Created by Quien on 2023/1/22.
//

import Foundation

struct CombinedStatistics {
  let userStatistics: [UserStatistics]
  let habitStatistics: [HabitStatistics]
}

extension CombinedStatistics: Codable { }
