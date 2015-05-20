//
//  EventCreatorViewController.swift
//  FriendsGlue
//
//  Created by Andres Brun Moreno on 20/05/15.
//  Copyright (c) 2015 Andres Brun Moreno. All rights reserved.
//

import UIKit

class EventCreatorViewController: UIViewController, UIActionSheetDelegate, UITextFieldDelegate {

    @IBOutlet weak var whatTextField: UITextField!
    @IBOutlet weak var whereTextfFeld: UITextField!
    @IBOutlet weak var whenTextField: UITextField!
    @IBOutlet weak var whoTextField: UITextField!
    @IBOutlet weak var privacySegmented: UISegmentedControl!
    
    let actionTypes = ["Play a Sport", "Drink a beer", "Watch a Film", "Watch a Game"]
    let datePicker = UIDatePicker()
    var eventData = Event.createEvent(nil, locationName: nil, latitude: nil, longitude: nil, date: nil, friends: [])
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let whatActionSheet = UIActionSheet(title: "Choose Activity", delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles: "Play a Sport", "Drink a beer", "Watch a Film", "Watch a Game")
        
        whatTextField.inputView = whatActionSheet
        
        
        whenTextField.inputView = datePicker
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, CGRectGetWidth(view.bounds), 44))
        toolbar.setItems([UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dateSelected:")], animated: false)
        
        whenTextField.inputAccessoryView = toolbar
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if let actionSheet = textField.inputView as? UIActionSheet {
            actionSheet.showInView(self.view)
        }
        
        if textField == whoTextField {
            performSegueWithIdentifier("showFriends", sender: self)
        }
        
        if textField == whereTextfFeld {
            performSegueWithIdentifier("showMap", sender: self)
        }

        
        return false
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if actionSheet == whatTextField.inputView {
            whatTextField.text = actionTypes[buttonIndex]
            eventData.verb = actionTypes[buttonIndex]
        }
    }
    
    func dateSelected(sender: AnyObject) {
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle

        eventData.date = datePicker.date
        whenTextField.text = formatter.stringFromDate(datePicker.date)
        whenTextField.resignFirstResponder()
    }

    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func save(sender: AnyObject) {
        
        // Create event. Call API
        
        // Alert
        UIAlertView(title: "Yeah!", message: "The event was created!", delegate: nil, cancelButtonTitle: "Thanks!").show()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let friendsVC = segue.destinationViewController as? FriendsViewController {
            friendsVC.successClosure = { contactsSelected in
                self.eventData.friends = contactsSelected
                self.whoTextField.text = "\(contactsSelected.count) friends" }
        }
        
        if let locationVC = segue.destinationViewController as? MapLocationViewController {
            locationVC.whatContext = eventData.verb
            locationVC.successClosure = { address, location in
                self.eventData.locationName = address
                self.eventData.latitude = Float(location.coordinate.latitude)
                self.eventData.longitude = Float(location.coordinate.longitude)
                self.whereTextfFeld.text = address
            }
        }
    }
}
