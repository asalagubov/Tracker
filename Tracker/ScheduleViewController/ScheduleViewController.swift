//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Alexander Salagubov on 10.07.2024.
//

import Foundation
import UIKit

class ScheduleViewController: UIViewController {

  let daysOfWeek = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]

  var selectedDays: [Bool] = [false, false, false, false, false, false, false]

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Расписание"
    backGround()
    setupCategoryView()
    addButton()
  }

  private func backGround() {
    view.backgroundColor = .ypWhite
  }

  func setupCategoryView() {
    navigationItem.hidesBackButton = true

    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    view.addSubview(tableView)

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.rowHeight = 75
    let tableCount : CGFloat = CGFloat(selectedDays.count)
    tableView.heightAnchor.constraint(equalToConstant: tableView.rowHeight * tableCount).isActive = true
    tableView.allowsSelection = false
    tableView.layer.cornerRadius = 16
    tableView.isScrollEnabled = false
    tableView.translatesAutoresizingMaskIntoConstraints = false

    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
  }

  func addButton() {
    let button = UIButton()
    button.setTitle("Готово", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 16
    button.layer.masksToBounds = true
    button.backgroundColor = .ypBlack
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    button.setTitleColor(.ypWhite, for: .normal)

    view.addSubview(button)

    button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true

    button.heightAnchor.constraint(equalToConstant: 60).isActive = true
    button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true

    button.addTarget(self, action: #selector(doneButton), for: .touchUpInside)
  }

  @objc func doneButton() {
    print("Done")
    dismiss(animated: true)
    navigationController?.popViewController(animated: true)
  }

  @objc func switchChanged(_ sender: UISwitch) {
    let index = sender.tag
    selectedDays[index] = sender.isOn
    print("День \(selectedDays[index]) выбран: \(sender.isOn)")
  }
}
extension ScheduleViewController : UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return daysOfWeek.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = daysOfWeek[indexPath.row]

    let switchView = UISwitch()
    switchView.tag = indexPath.row
    switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
    switchView.onTintColor = .ypBlue
    cell.accessoryView = switchView
    cell.backgroundColor = .ypBackground

    return cell
  }
}
