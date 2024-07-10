//
//  EventViewController.swift
//  Tracker
//
//  Created by Alexander Salagubov on 08.07.2024.
//

import Foundation
import UIKit

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  let tableList = ["Категория"]
  let textField = UITextField()
  let stackView = UIStackView()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Новое нерегулярное событие"
    backGround()
    setupHabitView()
    setupStackView()
    setupCancelButton()
    setupCreateButton()
    createTable()
  }

  private func backGround() {
    view.backgroundColor = .ypWhite
  }

  private func setupHabitView() {
    textField.backgroundColor = .ypBackground
    textField.textColor = .ypGray
    textField.placeholder = "Введите название трекера"
    let paddingView : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
    textField.leftView = paddingView
    textField.leftViewMode = .always
    textField.rightView = paddingView
    textField.rightViewMode = .always
    textField.layer.cornerRadius = 16
    textField.layer.masksToBounds = true
    textField.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(textField)

    textField.heightAnchor.constraint(equalToConstant: 75).isActive = true
    textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
    textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
  }

  private func setupStackView() {
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 8
    stackView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(stackView)

    stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
  }

  private func setupCancelButton() {
    let cancelButton = UIButton()
    cancelButton.setTitle("Отменить", for: .normal)
    cancelButton.layer.cornerRadius = 16
    cancelButton.layer.masksToBounds = true
    cancelButton.backgroundColor = .clear
    cancelButton.layer.borderColor = UIColor.ypRed.cgColor
    cancelButton.layer.borderWidth = 1
    cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    cancelButton.setTitleColor(.ypRed, for: .normal)
    cancelButton.translatesAutoresizingMaskIntoConstraints = false

    stackView.addArrangedSubview(cancelButton)

    cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    cancelButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    cancelButton.widthAnchor.constraint(equalToConstant: 166).isActive = true

    cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
  }

  private func setupCreateButton() {
    let createButton = UIButton()
    createButton.setTitle("Создать", for: .normal)
    createButton.layer.cornerRadius = 16
    createButton.layer.masksToBounds = true
    createButton.backgroundColor = .ypGray
    createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    createButton.setTitleColor(.ypWhite, for: .normal)
    createButton.translatesAutoresizingMaskIntoConstraints = false

    stackView.addArrangedSubview(createButton)

    createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

    createButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    createButton.widthAnchor.constraint(equalToConstant: 166).isActive = true

    createButton.addTarget(self, action: #selector(create), for: .touchUpInside)
  }

  private func createTable() {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.layer.cornerRadius = 16
    tableView.rowHeight = 75
    tableView.backgroundColor = .ypBackground
    tableView.isScrollEnabled = false
    tableView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(tableView)

    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24).isActive = true
    tableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * tableList.count)).isActive = true

  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let selectedItem = tableList[indexPath.row]
    if selectedItem == "Категория" {
      let categotyVC = CategoryViewController()
      navigationController?.pushViewController(categotyVC, animated: true)
    }
  }

  @objc func cancel() {
    print("Cancel")
    dismiss(animated: true)
  }

  @objc func create() {
    print("Create")
    dismiss(animated: true)
  }
}

extension EventViewController {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
    cell.textLabel?.text = tableList[indexPath.row]
    cell.accessoryType = .disclosureIndicator
    cell.backgroundColor = .ypBackground
    return cell
  }

}
