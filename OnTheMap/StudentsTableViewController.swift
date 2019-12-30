//
//  StudentsTableViewController.swift
//  OnTheMap
//
//  Created by Alessandro Bellotti on 17/08/17.
//  Copyright © 2017 Alessandro Bellotti. All rights reserved.
//

import UIKit

class StudentsTableViewController: UITableViewController {

    // MARK: IBOutlet
    @IBOutlet var studentsTableView: UITableView!
    
    // MARK: Constant
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: Var
    var tableAlertView: UIAlertController?
    var selectedMediaURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataList), name: NSNotification.Name(rawValue: "loadList"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        studentsTableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Students.sharedStudents.members.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentPinCell", for: indexPath) as! StudentTableViewCell
        
        // Configure the cell
        let student = Students.sharedStudents.members[indexPath.item]
        cell.studentFullName.text! = student.firstName + " " + student.lastName
        cell.studentURL.text! = student.mediaURL
        
        return cell
    }

    // MARK: func
    
    @objc func reloadDataList(){
        self.tableView.reloadData()
    }
    
    func showAlertView(message: String) {
        
        self.tableAlertView = UIAlertController(title: Constants.appName,
                                              message: message,
                                              preferredStyle: .alert)
        // Add action for close alert view
        let action = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default,
                                   handler: {(paramAction :UIAlertAction!) in
                                    
        })
        tableAlertView!.addAction(action)
        
        present(tableAlertView!, animated: true, completion: nil)
    }
    
    func openMediaURL(urlString: String) {
        guard urlString != "" else {
            showAlertView(message: LinkErrors.linkEmpty)
            return
        }
        // Check if link is valid before open it
        let isValidLink = NSURL(string: urlString)
        if (isValidLink != nil) {
            UIApplication.shared.open(URL(string: urlString)!)
        } else {
            showAlertView(message: LinkErrors.brokedLink)
        }
    }
    
    // MARK: - Navigation
    
    // Prepare and open Link in app when tap on item list
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMediaURL = Students.sharedStudents.members[indexPath.item].mediaURL
        // Deselect row for doesn't remain in the "Selected State" after returning to the app from the browser
        tableView.deselectRow(at: indexPath, animated: true)
        // Call func for check the link and open it (if is ok)
        openMediaURL(urlString: selectedMediaURL!)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
