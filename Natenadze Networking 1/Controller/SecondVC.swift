//
//  SecondVC.swift
//  Natenadze Networking 1
//
//  Created by Davit Natenadze on 09.12.22.
//

import UIKit

class SecondVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var commentURL:String = "https://jsonplaceholder.typicode.com/posts/1/comments"
    var commentsArray = [CommentData]()
    
    
    
     let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.performURLRequest(commentURL) { (data: [CommentData] ) in
            self.commentsarrayManager(data)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        tableView.frame = view.frame
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    
    func commentsarrayManager(_ json: [CommentData]) {
        commentsArray.append(contentsOf: json)
    }
      
    // MARK: - TableView cells
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = self.commentsArray[indexPath.row].body
        return cell
    }
}
