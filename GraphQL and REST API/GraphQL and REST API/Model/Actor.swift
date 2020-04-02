//
//  Actor.swift
//  GraphQL and REST API
//
//  Created by aryzae on 2020/04/02.
//  Copyright © 2020 aryzae. All rights reserved.
//

import Foundation

struct Actor: Decodable {
    let id: Int
    let login: String
    let displayLogin: String
    let gravatarId: String
    let url: String
    let avatarUrl: String

    var accessUrl: URL { URL(string: url)! }
    var accessAvatarUrl: URL { URL(string: avatarUrl)! }
}
