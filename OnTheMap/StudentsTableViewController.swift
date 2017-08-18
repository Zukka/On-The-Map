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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        studentsTableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.udacityStudents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentPinCell", for: indexPath) as! StudentTableViewCell
        
        // Configure the cell
        let student = appDelegate.udacityStudents[indexPath.item]
        cell.studentFullName.text! = student.firstName + " " + student.lastName
        cell.studentURL.text! = student.mediaURL
        
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
