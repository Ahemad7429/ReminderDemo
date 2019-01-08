//
//  NewReminderVC.swift
//  RemindersDemo
//
//  Created by Ahemadabbas Vagh on 07/01/19.
//  Copyright © 2019 Ahemadabbas Vagh. All rights reserved.
//

import UIKit
import EventKit

class NewReminderVC: UIViewController {

    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var reminderDescriptionTextView: UITextView!
    
    var eventStore: EKEventStore!
    
    var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(addDate), for: UIControl.Event.valueChanged)
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        dateTextField.inputView = datePicker
        reminderDescriptionTextView.becomeFirstResponder()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
        let reminder = EKReminder(eventStore: self.eventStore)
        reminder.title = reminderDescriptionTextView.text
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let dueDateComponents = appDelegate.dateComponentFromDate(date: self.datePicker!.date)
        reminder.dueDateComponents = dueDateComponents
        reminder.calendar = self.eventStore.defaultCalendarForNewReminders()

        do {
            try self.eventStore.save(reminder, commit: true)
             self.dismiss(animated: true, completion: nil)
        }catch{
            print("Error creating and saving new reminder : \(error)")
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func addDate(){
        self.dateTextField.text = self.datePicker.date.description
    }

}
