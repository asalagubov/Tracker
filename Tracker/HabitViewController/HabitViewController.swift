//
//  HabitViewController.swift
//  Tracker
//
//  Created by Alexander Salagubov on 08.07.2024.
//

import Foundation
import UIKit

class HabitViewController: UIViewController {

  let tableList = ["Категория", "Расписание"]
  let textField = UITextField()
  let emojiList = ["🙂","😻","🌺","🐶","❤️","😇","😡","🥶","🤔","🙌","🍔","🥦","🏓","🥇","🎸","🏝","😪"]
  let colorList: [UIColor] = [.cSelection1,.cSelection2,.cSelection3,.cSelection4,.cSelection5,.cSelection6,.cSelection7,.cSelection8,.cSelection9,.cSelection10,.cSelection11,.cSelection12,.cSelection13,.cSelection14,.cSelection15,.cSelection16,.cSelection17,.cSelection18]
  let tableView = UITableView()
  let createButton = UIButton()

  private var selectedCategory: TrackerCategory?
  private var selectedSchedule: [Weekday] = []
  private var enteredEventName = ""


  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Новая привычка"
    backGround()
    setupHabitView()
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
    textField.leftViewMode = .always
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

    view.addSubview(cancelButton)

    cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    cancelButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    cancelButton.widthAnchor.constraint(equalToConstant: 166).isActive = true

    cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
  }

  private func setupCreateButton() {
    createButton.setTitle("Создать", for: .normal)
    createButton.layer.cornerRadius = 16
    createButton.layer.masksToBounds = true
    createButton.backgroundColor = .ypGray
    createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    createButton.setTitleColor(.ypWhite, for: .normal)
    createButton.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(createButton)

    createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

    createButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    createButton.widthAnchor.constraint(equalToConstant: 166).isActive = true

    createButton.addTarget(self, action: #selector(create), for: .touchUpInside)
  }

  private func createTable() {
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

  func checkCreateButtonValidation() {

      if selectedCategory != nil && !enteredEventName.isEmpty && !selectedSchedule.isEmpty {
          createButton.isEnabled = true
          createButton.backgroundColor = .ypBlack
          createButton.setTitleColor(.ypWhite, for: .normal)
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

extension HabitViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .ypBackground
        let item = "\(tableList[indexPath.row])"
        cell.textLabel?.text = item
        if item == "Категория" {
            cell.detailTextLabel?.text = selectedCategory?.title
            cell.detailTextLabel?.textColor = .ypGray
        }
        if item == "Расписание" {
            var text : [String] = []
            for day in selectedSchedule {
                text.append(day.rawValue)
            }
            cell.detailTextLabel?.text = text.joined(separator: ", ")
            cell.detailTextLabel?.textColor = .ypGray
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // Снимаем выделение ячейки

        let selectedItem = tableList[indexPath.row]

        if selectedItem == "Категория" {
            let categoryViewController = CategoryViewController()
            categoryViewController.delegate = self
            let navigatonVC = UINavigationController(rootViewController: categoryViewController)
            present(navigatonVC, animated: true)
        }

        if selectedItem == "Расписание" {
            let scheduleVC = ScheduleViewController()
            scheduleVC.delegate = self
            navigationController?.pushViewController(scheduleVC, animated: true)
        }
    }
}

extension HabitViewController: UITextFieldDelegate {

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Название не может быть пустым"
            return false
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        enteredEventName = textField.text ?? ""
        checkCreateButtonValidation()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkCreateButtonValidation()
        return true
    }

}

extension HabitViewController: CategoryViewControllerDelegate {
    func categoryScreen(_ screen: CategoryViewController, didSelectedCategory category: TrackerCategory) {
        selectedCategory = category
        checkCreateButtonValidation()
        tableView.reloadData()
    }
}

extension HabitViewController: SelectedScheduleDelegate {
    func selectScheduleScreen(_ screen: ScheduleViewController, didSelectedDays schedule: [Weekday]) {
        selectedSchedule = schedule
        checkCreateButtonValidation()
        tableView.reloadData()
    }
}
