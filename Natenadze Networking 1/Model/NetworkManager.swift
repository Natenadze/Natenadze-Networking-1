//
//  NetworkManager.swift
//  Natenadze Networking 1
//
//  Created by Davit Natenadze on 13.12.22.
//

import Foundation

class NetworkManager {
    
    static let shared =  NetworkManager()
    
    func performRequestForPosts<T:Codable>(_ url: String, completion: @escaping (T)-> Void) {
        guard let url = URL(string: url) else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print(error.localizedDescription)
            }
            
            guard let data else {return}
            let result = try? JSONDecoder().decode(T.self, from: data)
            guard let result else {return}

            DispatchQueue.main.async {
                completion(result)
            }
            
        }.resume()
    }
}
