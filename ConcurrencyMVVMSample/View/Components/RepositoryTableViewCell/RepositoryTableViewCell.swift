//
//  RepositoryTableViewCell.swift
//  ConcurrencyMVVMSample
//
//  Created by Hikaru Kuroda on 2023/02/02.
//

import Foundation
import UIKit

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var repositoryNameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureWith(repository: Repository) {
        repositoryNameLabel.text = repository.full_name
        descriptionTextView.text = repository.description
    }
}
