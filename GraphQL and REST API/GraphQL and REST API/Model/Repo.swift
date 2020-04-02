//
//  Repo.swift
//  GraphQL and REST API
//
//  Created by aryzae on 2020/04/02.
//  Copyright © 2020 aryzae. All rights reserved.
//

import Foundation

struct Repo: Decodable {
    let id: Int
    let name: String
    let url: String

    lazy var accessURL: URL = URL(string: url)!
}
