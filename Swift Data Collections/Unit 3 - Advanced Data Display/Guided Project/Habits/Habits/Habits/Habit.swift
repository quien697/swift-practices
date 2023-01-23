//
//  Habit.swift
//  Habits
//
//  Created by Quien on 2023/1/20.
//

import UIKit

// MARK: - Habit
struct Habit {
  let name: String
  let category: Category
  let info: String
}

extension Habit: Codable { }

extension Habit: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
  }
  static func == (lhs: Habit, rhs: Habit) -> Bool {
    return lhs.name == rhs.name
  }
}

extension Habit: Comparable {
  static func < (lhs: Habit, rhs: Habit) -> Bool {
    return lhs.name < rhs.name
  }
}

// MARK: - Category
struct Category {
  let name: String
  let color: Color
}

extension Category: Codable { }

extension Category: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
  }
  static func == (lhs: Category, rhs: Category) -> Bool {
    return lhs.name == rhs.name
  }
}

// MARK: - Color
struct Color {
  let hue: Double
  let saturation: Double
  let brightness: Double
}

extension Color: Codable {
  enum CodingKeys: String, CodingKey {
    case hue = "h"
    case saturation = "s"
    case brightness = "b"
  }
}

extension Color {
  var uiColor: UIColor {
    return UIColor(
      hue: CGFloat(hue),
      saturation: CGFloat(saturation),
      brightness: CGFloat(brightness),
      alpha: 1
    )
  }
}

extension Color: Hashable { }
