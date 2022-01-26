//
//  AlbumTagsViewController.swift
//  Freeform Exercise
//
//  Created by Michael Irimus on 24.01.22.
//

import Foundation
import UIKit

class AlbumTagsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    var keywords: [Keyword?] = []
    var keywordDatas: [KeywordData]?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // CoreData.resetAllCoreData() // fast cleanup
        self.title = "Tags"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        
        CoreData.context.refreshAllObjects()
        keywordDatas = CoreData.fetchKeywordsFromCoreData()
        
        if let keywordDatas = keywordDatas {
            for keywordData in keywordDatas {
                let newKeyword = Keyword(keyword: keywordData.name!, score: keywordData.percentage)
                keywords.append(newKeyword)
            }
        } else {
            showAlertWith(title: "Error", message: "keywords could not be fetched, try again")
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumImagesViewController = self.storyboard?.instantiateViewController(withIdentifier: "AlbumImagesViewController") as? AlbumImagesViewController
        self.navigationController?.pushViewController(albumImagesViewController!, animated: true)
        
        if let index = tableView.indexPathForSelectedRow?.row {
            albumImagesViewController?.images = keywordDatas![index].keywordImages?.allObjects as? [Image]
        }
    }
}
