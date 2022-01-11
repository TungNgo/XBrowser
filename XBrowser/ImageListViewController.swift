//
//  ImageListViewController.swift
//  XBrowser
//
//  Created by Lan Thien on 11/01/2022.
//

import Combine
import UIKit

class ImageListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    var webStateModel: WebStateModel!
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.register(UINib(nibName: "ImageListTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageListTableViewCell")
//        webStateModel.$imageSourcesFounded
//            .sink(receiveValue: self.tableView.items({ tableView, indexPath, element in
//                let cell = tableView.dequeueReusableCell(withIdentifier: "ImageListTableViewCell", for: indexPath) as! ImageListTableViewCell
//                return cell
//            }))
//            .store(in: &cancellables)
    }
}

extension UITableView {
    func items<Element>(_ builder: @escaping (UITableView, IndexPath, Element) -> UITableViewCell) -> ([Element]) -> Void {
        let dataSource = CombineTableViewDataSource(builder: builder)
        return { items in
            dataSource.pushElements(items, to: self)
        }
    }
}

class CombineTableViewDataSource<Element>: NSObject, UITableViewDataSource {

    let build: (UITableView, IndexPath, Element) -> UITableViewCell
    var elements: [Element] = []

    init(builder: @escaping (UITableView, IndexPath, Element) -> UITableViewCell) {
        build = builder
        super.init()
    }

    func pushElements(_ elements: [Element], to tableView: UITableView) {
        tableView.dataSource = self
        self.elements = elements
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        build(tableView, indexPath, elements[indexPath.row])
    }
}
