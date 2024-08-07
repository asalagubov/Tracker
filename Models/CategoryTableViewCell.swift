//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Alexander Salagubov on 07.08.2024.
//

import Foundation
import UIKit

class CategoryTableViewCell: UITableViewCell {
    static let reuseIdentifier = "CategoryTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        textLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        textLabel?.textColor = .ypBlack
        backgroundColor = .ypBackground
        selectionStyle = .none
    }

    func configure(with category: TrackerCategory) {
        textLabel?.text = category.title
    }
}
