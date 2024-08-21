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
    categoryEntity.trackers = NSSet(array: category.trackers.compactMap({trackerStore.addNewTracker(from: $0)}))
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
    if let existingCategory = fetchCategory(with: titleCategory) {
      var existingTrackers = existingCategory.trackers?.allObjects as? [TrackerCoreData] ?? []
      if let trackerCoreData = trackers.first(where: { $0.id == tracker.id }) {
        if !existingTrackers.contains(where: { $0.id == tracker.id }) {
          existingTrackers.append(trackerCoreData)
        }
      }
      existingCategory.trackers = NSSet(array: existingTrackers)
    } else {
      let category = TrackerCategory(title: titleCategory, trackers: [tracker])
      createCategory(category)
    }
    do {
      try context.save()
    } catch {
      print("Ошибка сохранения трекера в категории: \(error)")
    }
  }

  func saveOriginalCategory(tracker: Tracker, originalCategory: String) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext

    let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
    fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)

    do {
      let trackers = try managedContext.fetch(fetchRequest)
      if let trackerCoreData = trackers.first {
        trackerCoreData.trackerCategory = originalCategory
        try managedContext.save()
      }
    } catch {
      print("Ошибка сохранения исходной категории трекера: \(error)")
    }
  }

  func getOriginalCategory(tracker: Tracker) -> String {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return "" }
    let managedContext = appDelegate.persistentContainer.viewContext

    let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
    fetchRequest.predicate = NSPredicate(format: "id == %@", tracker.id as CVarArg)

    do {
      let trackers = try managedContext.fetch(fetchRequest)
      if let trackerCoreData = trackers.first {
        return trackerCoreData.trackerCategory ?? ""
      }
    } catch {
      print("Ошибка получения исходной категории трекера: \(error)")
    }

    return ""
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
      print("Ошибка удаления трекера из категории: \(error)")
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
