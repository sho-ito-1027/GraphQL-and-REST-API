//
//  ViewController.swift
//  GraphQL and REST API
//
//  Created by aryzae on 2020/04/01.
//  Copyright © 2020 aryzae. All rights reserved.
//

import UIKit

typealias Viewer = QueryQuery.Data.Viewer

class ViewController: UIViewController {
    @IBOutlet weak var myIconImageView: UIImageView!
    @IBOutlet weak var myNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private(set) var items: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            myIconImageView.layer.cornerRadius = myIconImageView.frame.width / 2
            myIconImageView.clipsToBounds = true
        }

        fetchRESTAPI()
        fetchGraphQL()
    }

    private func fetchRESTAPI() {
        API.shared.request(Events()) { [unowned self] (result, _) in
            switch result {
            case .success(let response):
                self.items = response
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func fetchGraphQL() {
        API.graphql.apollo.fetch(query: QueryQuery()) { [unowned self] (result) in
            switch result {
            case .success(let data):
                print(data)
                guard let viewer = data.data?.viewer else { return }
                self.update(viewer: viewer)
            case .failure(let error):
                print(error)
            }
        }
    }

    private func update(viewer: Viewer) {

        do {
            let data = try Data(contentsOf: URL(string: viewer.avatarUrl)!)
            myIconImageView.image = UIImage(data: data)
        } catch {
            print(error)
        }
        myNameLabel.text = viewer.name
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = items[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell else {
            fatalError("cast miss")
        }
        cell.update(item: items[indexPath.row])
        return cell
    }
}
