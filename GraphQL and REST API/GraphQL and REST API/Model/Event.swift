//
//  Event.swift
//  GraphQL and REST API
//
//  Created by aryzae on 2020/04/02.
//  Copyright © 2020 aryzae. All rights reserved.
//

import Foundation

struct Event: Decodable {
    let id: String
    let type: String
    let actor: Actor
    let repo: Repo
    let `public`: Bool
    let createdAt: String
}
