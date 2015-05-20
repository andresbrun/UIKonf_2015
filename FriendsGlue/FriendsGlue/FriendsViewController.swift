//
//  FriendsViewController.swift
//  FriendsGlue
//
//  Created by Andres Brun Moreno on 20/05/15.
//  Copyright (c) 2015 Andres Brun Moreno. All rights reserved.
//

import UIKit


class FriendsViewController: UITableViewController, UIActionSheetDelegate {

    let addressBook = APAddressBook()
    var contactsRetrieved = [APContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressBook.loadContacts(
            { (contacts: [AnyObject]!, error: NSError!) in
                if let contactsValue = contacts as? [APContact] {
                    self.contactsRetrieved = contactsValue.filter { contact in return contact.firstName != nil && contact.lastName != nil}
                    self.tableView.reloadData()
                }
        })
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsRetrieved.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath: indexPath) as! FriendCell

        let contact: APContact = contactsRetrieved[indexPath.row]
        if (contact.photo != nil) {
            cell.icon.image = contact.photo
        }
        cell.name.text = "\(contact.lastName), \(contact.firstName)"

        return cell
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let actionsheet = UIActionSheet(title: "Select channel", delegate: self, cancelButtonTitle: "No this one!", destructiveButtonTitle: nil, otherButtonTitles: "Facebook", "Twitter","SMS")
        actionsheet.showInView(view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if actionSheet.cancelButtonIndex == buttonIndex {
            if let indexPath = tableView.indexPathsForSelectedRows()?.last as? NSIndexPath {
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
    }

}
