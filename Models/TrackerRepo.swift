//
//  TrackerRepo.swift
//  Tracker
//
//  Created by Alexander Salagubov on 11.07.2024.
//

import Foundation
import UIKit

enum CategoryList: String {
  case usefull = "Важное"
}

final class TrackerRepo {
  
  static let shared = TrackerRepo()
  private init() {}
  
  var visibleCategory: [TrackerCategory] = []
  
  var categories: [TrackerCategory] = [TrackerCategory(title: .usefull, trackers: [])]
  func appendTrackerInVisibleTrackers(weekday: Int) {
    var weekDayCase: Weekday = .monday
    
    switch weekday {
    case 1:
      weekDayCase = .sunday
    case 2:
      weekDayCase = .monday
    case 3:
      weekDayCase = .tuesday
    case 4:
      weekDayCase = .wednesday
    case 5:
      weekDayCase = .thursday
    case 6:
      weekDayCase = .friday
    case 7:
      weekDayCase = .saturday
    default:
      break
    }
    
    var trackers = [Tracker]()
    
    for tracker in categories.first!.trackers {
      for day in tracker.schedule {
        if day == weekDayCase {
          trackers.append(tracker)
        }
      }
    }
    
    let category = TrackerCategory(title: .usefull, trackers: trackers)
    visibleCategory.append(category)
  }
  
  func removeAllVisibleCategory() {
    visibleCategory.removeAll()
  }
  
  func createNewTracker(tracker: Tracker) {
    var trackers: [Tracker] = []
    guard let list = categories.first else {return}
    for tracker in list.trackers{
      trackers.append(tracker)
    }
    trackers.append(tracker)
    categories = [TrackerCategory(title: .usefull, trackers: trackers)]
  }
  
  func createNewCategory(newCategoty: TrackerCategory) {
    categories.append(newCategoty)
  }
  
  func checkIsCategoryEmpty() -> Bool {
    categories.isEmpty
  }
  
  func checkIsTrackerRepoEmpty() -> Bool {
    categories[0].trackers.isEmpty
  }
  
  func checkIsVisibleEmpty() -> Bool {
    if visibleCategory.isEmpty {
      return true
    }
    if visibleCategory[0].trackers.isEmpty {
      return true
    } else {
      return false
    }
  }
  
  func getTrackerDetails(section: Int, item: Int) -> Tracker {
    visibleCategory[section].trackers[item]
  }
  
  func getNumberOfCategories() -> Int {
    visibleCategory.count
  }
  
  func getNumberOfItemsInSection(section: Int) -> Int {
    visibleCategory[section].trackers.count
  }
  
  func getTitleForSection(sectionNumber: Int) -> String {
    visibleCategory[sectionNumber].title.rawValue
  }
}
