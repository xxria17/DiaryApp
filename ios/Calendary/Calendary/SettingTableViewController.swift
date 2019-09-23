//
//  SettingTableViewController.swift
//  Calendary
//
//  Created by 김기현 on 02/09/2019.
//  Copyright © 2019 김기현. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SettingTableViewController: UITableViewController {
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var deleteUserButton: UIButton!
    @IBOutlet weak var personalInfoCell: UITableViewCell!
    
    var userArray: [UserDocument] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firebaseAuth = Auth.auth()
        
        logoutButton.setTitle("\((firebaseAuth.currentUser?.email)!)에서 로그아웃하기", for: .normal)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFill
        let image = UIImage(named: "Calendary.png")
        imageView.image = image
        navigationItem.titleView = imageView

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    @IBAction func logoutButtonTouches() {
        let firebaseAuth = Auth.auth()
        print(firebaseAuth.currentUser)
        
        let alertTitle = "로그아웃"
        let alertMessage = "로그아웃 하시겠습니까?"

        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: {alertAction in
            do {
                try firebaseAuth.signOut()
                if firebaseAuth.currentUser == nil {
                    self.dismiss(animated: true, completion: nil)
                }
            } catch let signOutError as NSError {
                print("Error signing out : %@", signOutError)
            }}))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func deleteUserButtonTouches(_ sender: Any) {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        
        let alertTitle = "회원탈퇴"
        let alertMessage = "회원탈퇴 하시겠습니까?"
        
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: {alertAction in
            db.collection("User").whereField("Email", isEqualTo: user?.email).getDocuments(completion: { (snapshot, error) in
                guard let snapshot = snapshot else {
                    print(error)
                    return }
                print(snapshot.documents.count)
                let name = snapshot.documents.first?.get("name") as? String
                snapshot.documents.first?.reference.delete() { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                        } else {
                            print("Document successfully removed!")
                            print(name)
                            user?.delete(completion: { (error) in
                                if error == nil {
                                    self.dismiss(animated: true, completion: nil)
                                } else {
                                    print(error?.localizedDescription)
                                    db.collection("User").addDocument(data: [
                                        "Email": user?.email,
                                        "name": name
                                    ]) { error in
                                        print(error)
                                    }
                                }
                            })
                            
                        }
                    }
                })
            }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
////         Configure the cell...
//
//        return cell
//    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
