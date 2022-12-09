//
//  SecondVC.swift
//  Natenadze Networking 1
//
//  Created by Davit Natenadze on 09.12.22.
//

import UIKit

class SecondVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var comment: String?
    
     let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        tableView.frame = view.frame
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.reloadData()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = comment
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
