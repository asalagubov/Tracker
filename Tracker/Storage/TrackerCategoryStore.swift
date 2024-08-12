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
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch categories: \(error)")
            return []
        }
    }

    func decodingCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) -> TrackerCategory? {
        guard let title = trackerCategoryCoreData.title else { return nil }
        let trackers = (trackerCategoryCoreData.trackers?.allObjects as? [TrackerCoreData])?.compactMap {
            trackerStore.decodingTrackers(from: $0)
        } ?? []
        return TrackerCategory(title: title, trackers: trackers)
    }

    func createCategoryAndTracker(tracker: Tracker, with titleCategory: String) {
        let category = fetchCategory(with: titleCategory) ?? createCategory(with: titleCategory)
        guard let trackerCoreData = trackerStore.addNewTracker(from: tracker) else { return }
        category.addToTrackers(trackerCoreData)
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }

    private func fetchCategory(with title: String) -> TrackerCategoryCoreData? {
        return fetchAllCategories().first { $0.title == title }
    }

    private func createCategory(with title: String) -> TrackerCategoryCoreData {
        guard let entity = NSEntityDescription.entity(forEntityName: "TrackerCategoryCoreData", in: context) else { fatalError("Failed to create entity description") }
        let newCategory = TrackerCategoryCoreData(entity: entity, insertInto: context)
        newCategory.title = title
        newCategory.trackers = NSSet(array: [])
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
        return newCategory
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdateData(in: self)
    }
}
