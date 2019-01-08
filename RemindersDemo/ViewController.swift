//
//  ViewController.swift
//  RemindersDemo
//
//  Created by Ahemadabbas Vagh on 07/01/19.
//  Copyright © 2019 Ahemadabbas Vagh. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var eventStore: EKEventStore!
    var reminders: [EKReminder]!
    var selectedReminder: EKReminder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

        self.eventStore = EKEventStore()
        self.reminders = [EKReminder]()
        self.eventStore.requestAccess(to: EKEntityType.reminder) { (granted, error) in
            if granted {
                let predicate = self.eventStore.predicateForReminders(in: nil)
                self.eventStore.fetchReminders(matching: predicate, completion: { (reminders) in
                    self.reminders = reminders
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            } else {
                print("The app is not permitted to access reminders, make sure to grant permission in the settings and try again")
            }
        }
    }
    
    @IBAction func addEventButtonTapped(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        tableView.isEditing = !tableView.isEditing
        if tableView.isEditing{
            tableView.setEditing(true, animated: true)
        }else{
            tableView.setEditing(false, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowReminderDetails"{
            let reminderDetailsVC = segue.destination as! EditEventViewController
            reminderDetailsVC.selectedReminder = self.selectedReminder
            reminderDetailsVC.eventStore = eventStore
        } else {
            let newReminder = segue.destination as! NewReminderVC
            newReminder.eventStore = eventStore
        }
       
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reminders.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reminderCell", for: indexPath)
        let reminder = self.reminders[indexPath.row]
        cell.textLabel?.text = reminder.title
        let formate = DateFormatter()
        formate.dateFormat = "yyyy-MM-dd"
        if let dueDate = reminder.dueDateComponents?.date {
            cell.detailTextLabel?.text = formate.string(from: dueDate)
        } else {
            cell.detailTextLabel?.text = "N/A"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let reminder: EKReminder = reminders[indexPath.row]
        do {
            try eventStore.remove(reminder, commit: true)
            self.reminders.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } catch{
            print("An error occurred while removing the reminder from the Calendar database: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.selectedReminder = self.reminders[indexPath.row]
        self.performSegue(withIdentifier: "ShowReminderDetails", sender: self)
    }
    
}
