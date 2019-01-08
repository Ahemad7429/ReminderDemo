//
//  EditEventViewController.swift
//  RemindersDemo
//
//  Created by Ahemadabbas Vagh on 07/01/19.
//  Copyright © 2019 Ahemadabbas Vagh. All rights reserved.
//

import UIKit
import EventKit

class EditEventViewController: UIViewController {

    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var textViewDescription: UITextView!
    
    var selectedReminder: EKReminder!
    var eventStore: EKEventStore!
    var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.textViewDescription.text = self.selectedReminder.title
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        self.textFieldDate.text = formatter.string(from: (self.selectedReminder.dueDateComponents?.date)!)
        datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(addDate), for: UIControl.Event.valueChanged)
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        textFieldDate.inputView = datePicker
        textViewDescription.becomeFirstResponder()

    }
    
    
    @objc func addDate(){
        self.textFieldDate.text = self.datePicker.date.description
    }

    
    @IBAction func saveReminderTapped(_ sender: UIBarButtonItem) {
        self.selectedReminder.title = textViewDescription.text
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let dueDateComponents = appDelegate.dateComponentFromDate(date: self.datePicker!.date)
        selectedReminder.dueDateComponents = dueDateComponents
        selectedReminder.calendar = self.eventStore.defaultCalendarForNewReminders()
        do {
            try self.eventStore.save(selectedReminder, commit: true)
            self.navigationController?.popToRootViewController(animated: true)
        }catch{
            print("Error creating and saving new reminder : \(error)")
        }
    }
}
