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
    let gravatarID: String
    let url: String
    let avatarURL: String

    lazy var accessURL: URL = URL(string: url)!
    lazy var accessAvatarURL: URL = URL(string: avatarURL)!
}
