//
//  TrackerStore.swift
//  Tracker
//
//  Created by Alexander Salagubov on 23.07.2024.
//

import Foundation
import CoreData
import UIKit

final class TrackerStore {
  private let context: NSManagedObjectContext

  convenience init() {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    self.init(context: context)
  }
  init(context: NSManagedObjectContext) {
      self.context = context
  }
}
