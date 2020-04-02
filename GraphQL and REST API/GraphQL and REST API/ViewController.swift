//
//  ViewController.swift
//  GraphQL and REST API
//
//  Created by aryzae on 2020/04/01.
//  Copyright © 2020 aryzae. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private(set) var items: [Event] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        fetch()
    }

    private func fetch() {
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
