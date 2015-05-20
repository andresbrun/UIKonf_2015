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
    
    let actionTypes = ["Sport", "Beer", "Watch a Film", "Watch a Game"]
    let datePicker = UIDatePicker()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let whatActionSheet = UIActionSheet(title: "Choose Activity", delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil, otherButtonTitles: "Sport", "Beer", "Watch a Film", "Watch a Game")
        
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
            performSegueWithIdentifier("showFriendList", sender: self) 
        }
        
        return false
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if actionSheet == whatTextField.inputView {
            whatTextField.text = actionTypes[buttonIndex]
        }
    }
    
    func dateSelected(sender: AnyObject) {
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .MediumStyle

        whenTextField.text = formatter.stringFromDate(datePicker.date)
        whenTextField.resignFirstResponder()
    }

}
