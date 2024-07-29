//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Alexander Salagubov on 23.07.2024.
//

import Foundation
import CoreData
import UIKit


final class TrackerRecordStore {

  private let context: NSManagedObjectContext

  convenience init() {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    self.init(context: context)
  }

  init(context: NSManagedObjectContext) {
    self.context = context
  }

  func addNewRecord(from trackerRecord: TrackerRecorder) {
    guard let entity = NSEntityDescription.entity(forEntityName: "TrackerRecordCoreData", in: context) else { return }
    let newRecord = TrackerRecordCoreData(entity: entity, insertInto: context)
    newRecord.id = trackerRecord.id
    newRecord.date = trackerRecord.date
    do {
        try context.save()  // Save the context after adding the tracker
    } catch {
        print("Failed to save context: \(error)")
    }
  }
//
//  func fetchAllRecords() -> [TrackerRecorder] {
//    let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
//    do {
//      let trackerRecords = try context.fetch(fetchRequest)
//      return trackerRecords.map { TrackerRecorder(id: $0.id ?? UUID(), date: $0.date ?? Date()) }
//    } catch {
//      print("Failed to fetch tracker records: \(error)")
//      return []
//    }
//  }
//
//  func deleteRecord(for trackerRecord: TrackerRecorder) {
//    let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
//    fetchRequest.predicate = NSPredicate(format: "id == %@ AND date == %@", trackerRecord.id as CVarArg, trackerRecord.date as CVarArg)
//    if let result = try? context.fetch(fetchRequest), let recordToDelete = result.first {
//      context.delete(recordToDelete)
//      try? context.save()
//    }
//  }
}
