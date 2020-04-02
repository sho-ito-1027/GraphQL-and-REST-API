//
//  EventCell.swift
//  GraphQL and REST API
//
//  Created by aryzae on 2020/04/02.
//  Copyright © 2020 aryzae. All rights reserved.
//

import UIKit

final class EventTableViewCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
        iconImageView.clipsToBounds = true
    }

    func update(item: Event) {
        do {
            let data = try Data(contentsOf: item.actor.accessAvatarUrl)
            iconImageView.image = UIImage(data: data)
        } catch {
            print(error)
        }
        userNameLabel.text = item.actor.displayLogin
        repositoryNameLabel.text = item.repo.name
        eventNameLabel.text = item.type
        createdAtLabel.text = item.createdAt
    }
}
