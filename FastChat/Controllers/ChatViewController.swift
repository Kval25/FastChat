

import UIKit
import Firebase
import FirebaseAuth

class ChatViewController: UIViewController {
    
    let db = Firestore.firestore()
    var messages: [Message] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FastChat"
        navigationItem.hidesBackButton = true
        messageTextfield.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        
        loadMessages()
        
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text,
           let sender = Auth.auth().currentUser?.email {
            
            db.collection("messages").addDocument(data: [
                "sender": sender,
                "body": messageBody,
                "date": Date().timeIntervalSince1970
            ]) { error in
                
                if let e = error {
                    print(e)
                } else {
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
    
    //Fetches messages from Firestore,Listens for real-time updates,Updates your table view
    func loadMessages() {
        
        db.collection("messages")
            .order(by: "date")
            .addSnapshotListener { querySnapshot, error in
                
                self.messages = []
                
                if let snapshot = querySnapshot {
                    
                    for doc in snapshot.documents {
                        
                        let data = doc.data()
                        
                        if let sender = data["sender"] as? String,
                           let body = data["body"] as? String {
                            
                            let newMessage = Message(sender: sender, body: body)
                            self.messages.append(newMessage)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if self.messages.count > 0 {
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                            }
                    }
                }
            }
    }
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated:true )
            print("Signout")
            
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
}


//MARK: - TableViewDataSource Methods.
extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell" , for: indexPath) as! MessageCell
        cell.messageLabel.text = message.body
        
        if let currentUser = Auth.auth().currentUser?.email,
           message.sender == currentUser {
            // Current user (Me)

            cell.rightImageView.isHidden = false
            cell.leftImageView.isHidden = true

            cell.messageBackgroundView.backgroundColor = UIColor.systemTeal
            cell.messageLabel.textColor = UIColor.white

        } else {
            // Other user (You)

            cell.rightImageView.isHidden = true
            cell.leftImageView.isHidden = false

            cell.messageBackgroundView.backgroundColor = UIColor.systemGray5
            cell.messageLabel.textColor = UIColor.black
        }
        
     
        return cell
    }
}

//MARK: - UITextFieldDelegate
extension ChatViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            messageTextfield.resignFirstResponder()
            return true
        }
}
