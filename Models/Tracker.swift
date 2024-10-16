//
//  Tracker.swift
//  Tracker
//
//  Created by Alexander Salagubov on 10.07.2024.
//

import Foundation
import UIKit

struct Tracker: Equatable {
  let id: UUID
  let title: String
  let color: UIColor
  let emoji: String
  let schedule: [Weekday]
  let trackerCategory: String

  static func ==(lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id
  }
}
