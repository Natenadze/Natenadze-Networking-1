//
//  ViewController.swift
//  Natenadze Networking 1
//
//  Created by Davit Natenadze on 08.12.22.
//

import UIKit

class ViewController: UIViewController {
    
    // changes in branch 1
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    var postsArray = [[PostData]]()
   
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
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts"     ) else {return}
        
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
    
   
    
    func postsArrayManager(_ json: [PostData]) {
        var postsIdCount = 1
        for id in json where id.userId != postsIdCount {
            postsIdCount += 1
        }
        for i in 1...postsIdCount {
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
            
        secondVC.commentURL = "https://jsonplaceholder.typicode.com/posts/\(indexPath.row + 1)/comments"
        }else {
            secondVC.commentURL = "https://jsonplaceholder.typicode.com/posts/\(indexPath.section)\(indexPath.row + 1)/comments"
            print()
        }
    
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
