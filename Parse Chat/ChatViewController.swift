//
//  ChatViewController.swift
//  Parse Chat
//
//  Created by Michelle Shu on 2/23/17.
//  Copyright © 2017 Michelle Shu. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var chatTable: UITableView!
    @IBOutlet weak var messageField: UITextField!
    var messages: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        chatTable.delegate = self
        chatTable.dataSource = self
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatViewController.onTimer), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickSend(_ sender: Any) {
        let message = PFObject(className: "Message")
        
        message["text"] = messageField.text!
        
        if let user = PFUser.current() {
            message["user"] = user
        }
        
        message.saveInBackground(block: {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                print(message["text"])
                self.chatTable.reloadData()
            } else {
                print(error?.localizedDescription as Any)
            }
        })
    }
    
    func onTimer() {
        let query = PFQuery(className: "Message")
        query.order(byDescending: "createdAt")
        query.includeKey("user")
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error != nil {
                print("error")
            } else {
                print("success")
                
                if let objects = objects {
                    self.messages = objects
                    self.chatTable.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages == nil {
            return 0
        } else {
            return messages!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTable.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        
        if let message = messages?[indexPath.row] {
            cell.messageLabel.text = message["text"] as! String?
            if let username = message["user"] {
                cell.usernameLabel.text = (username as! String)
                cell.usernameLabel.isHidden = false
            }
        }
        
        return cell
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
