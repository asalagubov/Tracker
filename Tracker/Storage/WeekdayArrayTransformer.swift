//
//  WeekdayArrayTransformer.swift
//  Tracker
//
//  Created by Alexander Salagubov on 26.07.2024.
//
import Foundation
import CoreData

@objc(WeekdayArrayTransformer)
class WeekdayArrayTransformer: ValueTransformer {
  override class func transformedValueClass() -> AnyClass {
    return NSData.self
  }
  
  override class func allowsReverseTransformation() -> Bool {
    return true
  }
  
  override func transformedValue(_ value: Any?) -> Any? {
    guard let weekdays = value as? [Weekday] else { return nil }
    let strings = weekdays.map { $0.rawValue }
    return try? NSKeyedArchiver.archivedData(withRootObject: strings, requiringSecureCoding: false)
  }
  
  override func reverseTransformedValue(_ value: Any?) -> Any? {
    guard let data = value as? Data,
          let strings = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [String] else { return nil }
    return strings.compactMap { Weekday(rawValue: $0) }
  }
}
