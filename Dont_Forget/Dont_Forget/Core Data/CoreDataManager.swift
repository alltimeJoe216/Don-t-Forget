//
//  CoreDataManager.swift
//  Dont_Forget
//
//  Created by Joseph Veverka on 9/6/20.
//  Copyright © 2020 Joseph Veverka. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Dont_Forget")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Loading of stores failed")
            }
        }
        return container
    }()
    
    // 1. createReminderFolder
    func createReminderFolder(title: String) -> ReminderFolder {

        let context = persistentContainer.viewContext
        let newNoteFolder = NSEntityDescription.insertNewObject(forEntityName: "ReminderFolder", into: context) as! ReminderFolder

        newNoteFolder.title = title

        do {
            try context.save()
            return newNoteFolder
        } catch let error {
            print("Failed to save shit: \(error)")
            return newNoteFolder
        }
    }

    // 2. fetchReminderFolders
    func fetchReminderFolders() -> [ReminderFolder] {

        let context = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<ReminderFolder>(entityName: "ReminderFolder")

        do {
            let reminderFolder = try context.fetch(fetchRequest)
            return reminderFolder
        } catch let fetchError {
            print("Failed to fetch note folders: \(fetchError)")
            return []
        }
    }

    // 3. delete Reminder folder

    func deleteReminderFolder(reminderFolder: ReminderFolder) -> Bool {
        let context = persistentContainer.viewContext

        context.delete(reminderFolder)

        do {
            try context.save()
            return true
        } catch let error {
            print("Errror delete reminder folder: \(error)")
            return false
        }
    }

    // Create new reminder
    func createNewNote(title: String, date: Date, bodyText: String, reminderFolder: ReminderFolder) -> Reminder {

        let context = persistentContainer.viewContext

        let newReminder = NSEntityDescription.insertNewObject(forEntityName: "Reminder", into: context) as! Reminder

        newReminder.title = title
        newReminder.bodyText = bodyText
        newReminder.date = date
        newReminder.reminderFolder = reminderFolder

        do {
            try context.save()
            return newReminder
        } catch let error {
            print("Failed to save shit: \(error)")
            return newReminder
        }
    }
    
    // MARK: - TODO
    // fetch notes from core data
    func fetchNotes(from reminderFolder: ReminderFolder) -> [Reminder] {
        guard let folderNotes = reminderFolder.reminders?.allObjects as? [Reminder] else { return [] }
        return folderNotes
    }
    // delete them mugs
    func deleteNote(reminder: Reminder) -> Bool {
        let context = persistentContainer.viewContext

        context.delete(reminder)

        do {
            try context.save()
            return true
        } catch let error {
            print("Errror delete note entity \(error)")
            return false
        }
    }

    func saveUpdatedNote(reminder: Reminder, newText: String) {
        let context = persistentContainer.viewContext

        reminder.title = newText
        reminder.bodyText = newText
        reminder.date = Date()

        do {

            try context.save()

        } catch let error {

            print("Errror delete note entity \(error)")

        }

    }
}
