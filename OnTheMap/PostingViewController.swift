//
//  PostingViewController.swift
//  OnTheMap
//
//  Created by Alessandro Bellotti on 18/08/17.
//  Copyright © 2017 Alessandro Bellotti. All rights reserved.
//

import UIKit
import MapKit

class PostingViewController: UIViewController {

    // MARK: @IBOutlet
    
    // Search - first group start visible
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    
    // Result - second group start hidden
    @IBOutlet weak var resultView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add corner to search button
        searchButton.addCorner(value: 10)
    }


    @IBAction func cancelPosting(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

extension UIView {
    func addCorner(value: CGFloat) {
        self.layer.cornerRadius = value
    }
    
    func addBorder(value: CGFloat) {
        self.layer.borderWidth = 3
    }
    
    func addLabelBorder() {
        self.layer.borderWidth = 1
    }
    
    func addOpacity(value: Float) {
        self.layer.opacity = value
    }
    
    func addShadows() {
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3
    }
}

