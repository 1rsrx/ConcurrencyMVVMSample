//
//  ViewController.swift
//  ConcurrencyMVVMSample
//
//  Created by Hikaru Kuroda on 2023/01/29.
//

import UIKit

class SearchRepositoryViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var repositoryTableView: UITableView!
    private var loadingLabel: UILabel!


    override func loadView() {
        let view = UINib(nibName: "SearchRepositoryView", bundle: nil)
            .instantiate(withOwner: self).first! as! UIView
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

