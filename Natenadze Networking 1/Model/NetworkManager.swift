//
//  NetworkManager.swift
//  Natenadze Networking 1
//
//  Created by Davit Natenadze on 13.12.22.
//

import Foundation

enum HTTPStatusCode: Int {
    case Info = 100
    case Success = 200
    case Redirect = 300
    case ClientError = 400
    case ServerError = 500
    case Unknown = 999
}

class NetworkManager {
    
    static let shared =  NetworkManager()
    
    func performURLRequest<T:Codable>(_ url: String, completion: @escaping (T)-> Void) {
        guard let url = URL(string: url) else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print(error.localizedDescription)
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let status = httpResponse.statusCode
                switch status {
                case 100...199: print(HTTPStatusCode.Info)
                case 200...299: print(HTTPStatusCode.Success)
                case 300...399: print(HTTPStatusCode.Redirect)
                case 400...499: print(HTTPStatusCode.ClientError)
                case 500...599: print(HTTPStatusCode.ServerError)
                default: print(HTTPStatusCode.Unknown)
                }
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
