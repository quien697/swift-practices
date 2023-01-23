//
//  HabitStatistics.swift
//  Habits
//
//  Created by Quien on 2023/1/21.
//

import Foundation

struct HabitStatistics {
  let habit: Habit
  let userCounts: [UserCount]
}

extension HabitStatistics: Codable { }
