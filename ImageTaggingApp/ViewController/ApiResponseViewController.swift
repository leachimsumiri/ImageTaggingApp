//
//  ApiResponseViewController.swift
//  Freeform Exercise
//
//  Created by Michael Irimus on 24.01.22.
//

import Foundation
import UIKit

class ApiResponseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let networking = Networking()
    var keywords: [Keyword]?
    var image: Data?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var discardButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let saveImageStatus = CoreData.saveImage(data: image!, keywords: keywords!)
        
        if (!saveImageStatus) {
            showAlertWith(title: "Error", message: "Error saving image with tags")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func discardButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func triggerUiElementsState(state: Bool) {
        saveButton.isEnabled = state
        discardButton.isEnabled = state
        
        if (!state) {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tags"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        
        triggerUiElementsState(state: false)
        
        networking.uploadImage(imgData: image!, completionHandler: { keywords, apiReponseError, nserror  in
            if let keywords = keywords {
                DispatchQueue.main.async {
                    self.keywords = keywords
                    self.triggerUiElementsState(state: true)
                    self.tableView.reloadData()
                }
            }
            
            if let apiReponseError = apiReponseError {
                self.showAlertWith(title: "API Response Error", message: "\(apiReponseError.status): \(apiReponseError.message)")
            }
            
            if let nserror = nserror {
                self.showAlertWith(title: "NSError", message: nserror.localizedDescription)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tableView = tableView {
            if let indexPathForSelectedRow = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: indexPathForSelectedRow, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keywords?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
        cell.textLabel?.text = keywords?[indexPath.row].keyword
        
        return cell
    }
}
