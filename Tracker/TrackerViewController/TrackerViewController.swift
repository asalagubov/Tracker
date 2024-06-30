//
//  ViewController.swift
//  Tracker
//
//  Created by Alexander Salagubov on 28.06.2024.
//

import UIKit

class TrackerViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    backGround()
    setupTrackerView()
    setupDatePicker()
  }


  private func backGround() {
    view.backgroundColor = .ypWhite
  }

  private func setupTrackerView() {

    let plusButton = UIBarButtonItem(image: UIImage(named: "plus_button"), style: .plain, target: self, action: #selector(plusButtonTapped))
    plusButton.tintColor = .ypBlack
    navigationItem.leftBarButtonItem = plusButton

    let searchController = UISearchController()
    navigationItem.searchController = searchController
    searchController.searchBar.placeholder = "Поиск"

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
    label.text = "Что будем отслеживать?"
    label.font = .systemFont(ofSize: 12, weight: .medium)
    stackView.addArrangedSubview(label)

    stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    image.heightAnchor.constraint(equalToConstant: 80).isActive = true
    image.widthAnchor.constraint(equalToConstant: 80).isActive = true

  }
  private func setupDatePicker() {
    let datePicker = UIDatePicker()
    datePicker.preferredDatePickerStyle = .compact
    datePicker.datePickerMode = .date
    datePicker.tintColor = .ypBlack
    datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yy"
    dateFormatter.locale = Locale(identifier: "ru_RU")
    let currentDateString = dateFormatter.string(from: Date())
    let dateButton = UIBarButtonItem(title: currentDateString, style: .plain, target: nil, action: nil)
    dateButton.customView = datePicker

    navigationItem.rightBarButtonItem = dateButton
  }

  private func updateDateButtonTitle(date: Date) {
  }

  @objc func plusButtonTapped() {
    print("PlusButtonTapped")
  }
  @objc func datePickerChanged() {
    print("CalendarTapped")
  }
}

