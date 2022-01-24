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
    let coreData = CoreData()
    var keywords: [Keyword]?
    var image: Data?
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var discardButton: UIButton!
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        coreData.saveImage(data: image!, keywords: keywords!)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func discardButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tags"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        
        coreData.fetchImagesFromCoreData()
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
