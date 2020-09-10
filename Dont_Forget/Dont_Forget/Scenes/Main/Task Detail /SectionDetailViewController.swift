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
        
        let newNote = CoreDataManager.shared.createNewNote(title: title, date: date, bodyText: text, reminderFolder: self.reminderFolder!)
        
        reminders.append(newNote)
        
//        self.tableView.insertRows(at: [IndexPath(row: reminders.count - 1, section: 0)], with: .fade)
    }
}

class SectionDetailViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var sectionNameLabel: UILabel!

    //MARK: -Properties
    fileprivate var reminders:[Reminder] = []
    var reminderFolder: ReminderFolder?
        
    
    var folderData: ReminderFolder! {
        didSet {
            
            reminders = CoreDataManager.shared.fetchNotes(from: folderData)
            
            print(reminders)
//            filteredReminders = reminders
        }
    }
    
    
    
    // Cell ID
    var reminderCell: String = "reminderCell"
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        tableView.register(SectionDetailTableViewCell.self, forCellReuseIdentifier: reminderCell)

        super.viewDidLoad()
        tableView.reloadData()
        sectionNameLabel.text = reminderFolder?.title

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    
    //MARK: -IBactions
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as? AddTaskViewController
        destination?.delegate = self
    }
}

extension SectionDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reminderCell, for: indexPath) as! SectionDetailTableViewCell
        let reminderForRow = self.reminders[indexPath.row]
        cell.reminderData =  reminderForRow
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}
