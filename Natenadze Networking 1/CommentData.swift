//
//  CommentData.swift
//  Natenadze Networking 1
//
//  Created by Davit Natenadze on 09.12.22.
//

import Foundation

struct CommentData: Codable {
    var PostId: Int
    var id: Int
    var name: String
    var email: String
    var body: String
}
