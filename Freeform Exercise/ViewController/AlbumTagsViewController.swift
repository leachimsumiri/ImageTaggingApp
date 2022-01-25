//
//  AlbumTagsViewController.swift
//  Freeform Exercise
//
//  Created by Michael Irimus on 24.01.22.
//

import Foundation
import UIKit

class AlbumTagsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    let coreData = CoreData()
    var keywords: [Keyword?] = []
    var keywordDatas: [KeywordData]?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tags"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        
        keywordDatas = coreData.fetchKeywordsFromCoreData()
        for keywordData in keywordDatas! {
            let newKeyword = Keyword(keyword: keywordData.name!, score: keywordData.percentage)
            keywords.append(newKeyword)
        }
        
        self.tableView.reloadData()
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
        return keywords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
        cell.textLabel?.text = keywords[indexPath.row]?.keyword
        
        return cell
    }
    
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let countryDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "CountryDetailViewController") as? CountryDetailViewController
            self.navigationController?.pushViewController(countryDetailViewController!, animated: true)
            
            if let index = tableView.indexPathForSelectedRow?.row {
                countryDetailViewController!.country = countries?[index]
            }
        }
    */
}
