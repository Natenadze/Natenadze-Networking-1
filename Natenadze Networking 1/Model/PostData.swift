//
//  PostModel.swift
//  Natenadze Networking 1
//
//  Created by Davit Natenadze on 08.12.22.
//

import Foundation


struct PostData: Codable {
    var userId: Int
    var id: Int
    var title: String
    var body: String
}
