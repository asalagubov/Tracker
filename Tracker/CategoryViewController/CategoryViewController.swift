//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Alexander Salagubov on 10.07.2024.
//

import Foundation
import UIKit


class CategoryViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Категория"
    backGround()
    setupCategoryView()
    addButton()
  }

  private func backGround() {
    view.backgroundColor = .ypWhite
  }
  private func setupCategoryView() {
    navigationItem.hidesBackButton = true

    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 8
    view.addSubview(stackView)

    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.image = UIImage(named: "tracker_stub")
    stackView.addArrangedSubview(image)


    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Привычки и события можно объединить по смыслу"
    label.font = .systemFont(ofSize: 12, weight: .medium)
    stackView.addArrangedSubview(label)

    stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    image.heightAnchor.constraint(equalToConstant: 80).isActive = true
    image.widthAnchor.constraint(equalToConstant: 80).isActive = true
  }
  func addButton() {
    let button = UIButton()
    button.setTitle("Добавить категорию", for: .normal)
    button.layer.cornerRadius = 16
    button.layer.masksToBounds = true
    button.backgroundColor = .ypBlack
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    button.setTitleColor(.ypWhite, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(button)

    button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true

    button.heightAnchor.constraint(equalToConstant: 60).isActive = true
    button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true

    button.addTarget(self, action: #selector(addCategory), for: .touchUpInside)
  }
  @objc func addCategory() {
    print("Add Category")
    dismiss(animated: true)
  }
}
