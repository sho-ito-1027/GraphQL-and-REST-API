//
//  Events.swift
//  GraphQL and REST API
//
//  Created by aryzae on 2020/04/02.
//  Copyright © 2020 aryzae. All rights reserved.
//

import Foundation

struct Events: Requestable {
    typealias Response = [Event]

    private(set) var method: HTTPMethod = .get
    private(set) var path: String = "/events"
}
