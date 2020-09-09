//
//  FolderDetailViewController.swift
//  Dont_Forget
//
//  Created by Joseph Veverka on 9/6/20.
//  Copyright © 2020 Joseph Veverka. All rights reserved.
//

import UIKit

extension SectionDetailViewController: ReminderDelegate {
    
    func saveNewNote(title: String, date: Date, text: String) {
        
        let newNote = CoreDataManager.shared.createNewNote(title: title, date: date, bodyText: text, reminderFolder: self.folderData)
        
        reminders.append(newNote)
        filteredReminders.append(newNote)
        
        self.tableView.insertRows(at: [IndexPath(row: reminders.count - 1, section: 0)], with: .fade)
    }
}

class SectionDetailViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var sectionNameLabel: UILabel!

    //MARK: -Properties
    
    var reminderFolders: [ReminderFolder] = []
    fileprivate var reminders:[Reminder] = []
    fileprivate var filteredReminders:[Reminder] = []
    
    var folderData: ReminderFolder! {
        didSet {
            reminders = CoreDataManager.shared.fetchNotes(from: folderData)
            filteredReminders = reminders
        }
    }
    var reminderCell: String = "reminderCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    //MARK: -IBactions
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
    }
}

extension SectionDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredReminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reminderCell, for: indexPath) as! SectionDetailTableViewCell
        let reminderForRow = self.filteredReminders[indexPath.row]
        cell.reminderData =  reminderForRow
        return cell
    }
    
    
}
