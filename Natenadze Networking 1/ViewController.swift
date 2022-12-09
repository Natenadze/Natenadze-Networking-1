//
//  ViewController.swift
//  Natenadze Networking 1
//
//  Created by Davit Natenadze on 08.12.22.
//

import UIKit

class ViewController: UIViewController {
    var commentURL:String = ""
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var postsArray = [[PostData]]()
    var commentsArray = [CommentData]()
    
    var test = [
        CommentData(PostId: 1, id: 1, name: "saxeli 1", email: "asd1@.com", body: "dara1"),
             CommentData(PostId: 1, id: 2, name: "saxeli 2", email: "asd2@.com", body: "dara2"),
                CommentData(PostId: 1, id: 3, name: "saxeli 3", email: "asd3@.com", body: "dara3")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = view.frame
        tableView.sectionFooterHeight = 0.0
        view.addSubview(tableView)
        performRequestForPosts()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: -  Networking
    
    func performRequestForPosts() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {return}
//        let session = URLSession(configuration: .default)
        
         URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print(error.localizedDescription)
            }
            guard let data else {return}
            let result = try? JSONDecoder().decode([PostData].self, from: data)
            guard let result else {return}
             self.postsArrayManager(result)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.resume()
    }
    
    func performRequestForComments(with url: String) {
        guard let url = URL(string: url) else {return}
//        let session = URLSession(configuration: .default)
        
         URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print(error.localizedDescription)
            }
            guard let data else {return}
            let result = try? JSONDecoder().decode([CommentData].self, from: data)
            guard let result else {return}
             self.commentsarrayManager(result)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }.resume()
    }
    
    func commentsarrayManager(_ json: [CommentData]) {
            commentsArray.append(contentsOf: json)
    }
    
    func postsArrayManager(_ json: [PostData]) {
        for i in 1...10 {
            postsArray.append(json.filter({$0.userId == i }))
        }
    }
    
}

// MARK: - tableView Cells

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        postsArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postsArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = postsArray[indexPath.section][indexPath.row].title
        return cell
    }
}

// MARK: - Header info

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondVC = storyboard?.instantiateViewController(withIdentifier: "SecondVC") as! SecondVC
        if indexPath.section == 0 {
            commentURL = "https://jsonplaceholder.typicode.com/posts/\(indexPath.row + 1))/comments"
        }else {
            commentURL = "https://jsonplaceholder.typicode.com/posts/\(indexPath.section)\(indexPath.row + 1))/comments"
        }

        performRequestForComments(with: commentURL)
        
  
            secondVC.comment = "asd"  // self.commentsArray[0].body
        
            
        
     
        navigationController?.pushViewController(secondVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 65))
        header.backgroundColor = .systemGray4
        
        let imageView = UIImageView(image: UIImage(systemName: "person"))
        imageView.frame = CGRect(x: 10, y: 1, width: header.frame.size.height - 10,
                                              height: header.frame.size.height - 10)
        imageView.contentMode = .scaleAspectFit
        imageView.center.y = header.center.y
        header.addSubview(imageView)
        
        let label = UILabel(frame: CGRect(x: CGFloat(10 + Int(imageView.frame.size.width)), y: 5,
                                          width: header.frame.size.width - 15,
                                          height: header.frame.size.height - 10))
        label.text = "User id is: \(postsArray[section][section].userId)"
        label.font = .boldSystemFont(ofSize: 20)
        header.addSubview(label)
        
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        70
    }
    
}
