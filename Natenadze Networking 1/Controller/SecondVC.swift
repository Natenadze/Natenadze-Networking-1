//
//  SecondVC.swift
//  Natenadze Networking 1
//
//  Created by Davit Natenadze on 09.12.22.
//

import UIKit

class SecondVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var commentURL:String = "https://jsonplaceholder.typicode.com/posts/1/comments"
    var keyForUserDefaults = ""
    var commentsArray = [CommentData]()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchComments()
        tableView.frame = view.frame
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    func fetchComments() {
        if UserDefaults.standard.object(forKey: keyForUserDefaults) == nil {
            NetworkManager.shared.performURLRequest(commentURL) { (data: [CommentData] ) in
                if let obj = try? JSONEncoder().encode(data) {
                    UserDefaults.standard.set(obj, forKey: self.keyForUserDefaults)
                }
                self.commentsArray.append(contentsOf: data)
                self.navigationItem.title = "Data from Internet"
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        } else {
            if let data = UserDefaults.standard.object(forKey: keyForUserDefaults) as?  Data {
                guard let result = try? JSONDecoder().decode([CommentData].self, from: data) else {return}
                self.commentsArray.append(contentsOf: result)
                self.navigationItem.title = "Data from Memory"
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - TableView cells
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.commentsArray[indexPath.row].email
        return cell
    }
}
