//
//  Tracker.swift
//  Tracker
//
//  Created by Alexander Salagubov on 10.07.2024.
//

import Foundation
import UIKit

struct Tracker {
  let id: UUID
  let title: String
  let color: UIColor
  let emoji: String
  let schedule: [Weekday]
}
