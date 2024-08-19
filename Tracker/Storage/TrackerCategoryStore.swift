//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Alexander Salagubov on 23.07.2024.
//

import Foundation
import CoreData
import UIKit

protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdateData(in store: TrackerCategoryStore)
}

final class TrackerCategoryStore: NSObject {
    weak var delegate: TrackerCategoryStoreDelegate?
    private let context: NSManagedObjectContext
    private let trackerStore = TrackerStore()

    convenience override init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.init(context: context)
    }

    init(context: NSManagedObjectContext) {
        self.context = context
    }
}

extension TrackerCategoryStore {
  func createCategory(_ category: TrackerCategory) {
      guard fetchCategory(with: category.title) == nil else { return }
      guard let entity = NSEntityDescription.entity(forEntityName: "TrackerCategoryCoreData", in: context) else { return }
      let categoryEntity = TrackerCategoryCoreData(entity: entity, insertInto: context)
      categoryEntity.title = category.title
      categoryEntity.trackers = NSSet(array: [])
    do {
        try context.save()
    } catch {
        print("Failed to save context: \(error)")
    }

  }


    func fetchAllCategories() -> [TrackerCategoryCoreData] {
        return try! context.fetch(NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData"))
    }

    func decodingCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) -> TrackerCategory? {
        guard let title = trackerCategoryCoreData.title else { return nil }
        guard let trackers = trackerCategoryCoreData.trackers else { return nil }

        return TrackerCategory(title: title, trackers: trackers.compactMap { coreDataTracker -> Tracker? in
            if let coreDataTracker = coreDataTracker as? TrackerCoreData {
                return trackerStore.decodingTrackers(from: coreDataTracker)
            }
            return nil
        })
    }

  func createCategoryAndTracker(tracker: Tracker, with titleCategory: String) {
      guard let trackerCoreData = trackerStore.addNewTracker(from: tracker) else { return }
      if let existingCategory = fetchCategory(with: titleCategory) {
          var existingTrackers = existingCategory.trackers?.allObjects as? [TrackerCoreData] ?? []
          existingTrackers.append(trackerCoreData)
          existingCategory.trackers = NSSet(array: existingTrackers)
      } else {
          let newCategory = TrackerCategoryCoreData(entity: NSEntityDescription.entity(forEntityName: "TrackerCategoryCoreData", in: context)!, insertInto: context)
          newCategory.title = titleCategory
          newCategory.trackers = NSSet(array: [trackerCoreData])
      }
    do {
        try context.save()
    } catch {
        print("Failed to save context: \(error)")
    }

  }



  func addTrackerToCategory(tracker: Tracker, with titleCategory: String) {
      let trackers = trackerStore.fetchTracker2()
      guard let existingCategory = fetchCategory(with: titleCategory) else { return }
      var existingTrackers = existingCategory.trackers?.allObjects as? [TrackerCoreData] ?? []
      if let trackerCoreData = trackers.first(where: {$0.id == tracker.id}) {
          if !existingTrackers.contains(where: { $0.id == tracker.id }) {
              existingTrackers.append(trackerCoreData)
          }
      }
      existingCategory.trackers = NSSet(array: existingTrackers)
    do {
        try context.save()
    } catch {
        print("Failed to save context: \(error)")
    }

  }



  func deleteTrackerFromCategory(tracker: Tracker, with titleCategory: String) {
    guard let existingCategory = fetchCategory(with: titleCategory) else { return }
    var existingTrackers = existingCategory.trackers?.allObjects as? [TrackerCoreData] ?? []
    if let index = existingTrackers.firstIndex(where: { $0.id == tracker.id }) {
        existingTrackers.remove(at: index)
    }
    existingCategory.trackers = NSSet(array: existingTrackers)
    do {
        try context.save()
    } catch {
        print("Failed to save context: \(error)")
    }

}



    private func fetchCategory(with title: String) -> TrackerCategoryCoreData? {
        return fetchAllCategories().filter({$0.title == title}).first ?? nil
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateData(in: self)
    }
}
