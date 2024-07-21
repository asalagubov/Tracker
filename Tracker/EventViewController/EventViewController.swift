//
//  EventViewController.swift
//  Tracker
//
//  Created by Alexander Salagubov on 08.07.2024.
//

import Foundation
import UIKit

protocol EventViewControllerDelegate: AnyObject {
  func didCreateNewEvent(_ tracker: Tracker)
}

class EventViewController: UIViewController {

  let tableList = ["Категория"]
  let emojiList = ["🙂","😻","🌺","🐶","❤️","😇","😡","🥶","🤔","🙌","🍔","🥦","🏓","🥇","🎸","🏝","😪"]
  let colorList: [UIColor] = [.cSelection1,.cSelection2,.cSelection3,.cSelection4,.cSelection5,.cSelection6,.cSelection7,.cSelection8,.cSelection9,.cSelection10,.cSelection11,.cSelection12,.cSelection13,.cSelection14,.cSelection15,.cSelection16,.cSelection17,.cSelection18]
  let textField = UITextField()
  let stackView = UIStackView()
  let createButton = UIButton()
  let tableView = UITableView()
  let cancelButton = UIButton()
  let emojiCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
  let colorCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

  private var selectedCategory : TrackerCategory?
  private var selectedEmoji: String?
  private var selectedColor: UIColor?
  private var enteredTrackerName = ""
  weak var delegate: EventViewControllerDelegate?
  weak var dismissDelegate: DismissProtocol?
  var trackerVC = TrackerViewController()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Новое нерегулярное событие"
    backGround()
    setupEventView()
    setupStackView()
    setupCancelButton()
    setupCreateButton()
    setupEmojiCollectionView()
    setupColorCollectionView()
    createTable()
    setupConstraint()
  }

  private func backGround() {
    view.backgroundColor = .ypWhite
  }

  private func setupEventView() {
    textField.backgroundColor = .ypBackground
    textField.textColor = .ypBlack
    textField.placeholder = "Введите название трекера"
    let paddingView : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
    textField.leftView = paddingView
    textField.leftViewMode = .always
    textField.rightView = paddingView
    textField.rightViewMode = .always
    textField.layer.cornerRadius = 16
    textField.layer.masksToBounds = true
    textField.delegate = self
    textField.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(textField)
  }

  private func setupStackView() {
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 8
    stackView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(stackView)
  }

  private func setupCancelButton() {
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

    cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
  }

  private func setupCreateButton() {
    createButton.setTitle("Создать", for: .normal)
    createButton.layer.cornerRadius = 16
    createButton.layer.masksToBounds = true
    createButton.isEnabled = false
    createButton.backgroundColor = .ypGray
    createButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    createButton.setTitleColor(.ypWhite, for: .normal)
    createButton.translatesAutoresizingMaskIntoConstraints = false

    stackView.addArrangedSubview(createButton)

    createButton.addTarget(self, action: #selector(create), for: .touchUpInside)
  }

  private func setupEmojiCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical

    emojiCollectionView.collectionViewLayout = layout
    emojiCollectionView.dataSource = self
    emojiCollectionView.delegate = self
    emojiCollectionView.backgroundColor = .clear
    emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false

    emojiCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "emojiCell")

    view.addSubview(emojiCollectionView)
  }

  private func setupColorCollectionView() {
    let layout = UICollectionViewFlowLayout()

    colorCollectionView.collectionViewLayout = layout
    colorCollectionView.dataSource = self
    colorCollectionView.delegate = self
    colorCollectionView.backgroundColor = .clear
    colorCollectionView.translatesAutoresizingMaskIntoConstraints = false

    colorCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")

    view.addSubview(colorCollectionView)
  }

  private func setupConstraint() {
    NSLayoutConstraint.activate([
      textField.heightAnchor.constraint(equalToConstant: 75),
      textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
      textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

      cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      cancelButton.heightAnchor.constraint(equalToConstant: 60),
      cancelButton.widthAnchor.constraint(equalToConstant: 166),

      createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      createButton.heightAnchor.constraint(equalToConstant: 60),
      createButton.widthAnchor.constraint(equalToConstant: 166),

      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
      tableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * tableList.count)),

      emojiCollectionView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 50),
      emojiCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      emojiCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      emojiCollectionView.heightAnchor.constraint(equalToConstant: 50),

      colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 24),
      colorCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      colorCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      colorCollectionView.heightAnchor.constraint(equalToConstant: 50)
    ])
  }

  private func createTable() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.layer.cornerRadius = 16
    tableView.separatorStyle = .singleLine
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    tableView.rowHeight = 76
    tableView.rowHeight = 76
    tableView.backgroundColor = .ypBackground
    tableView.isScrollEnabled = false
    tableView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(tableView)
  }

  func checkCreateButtonValidation() {
    if selectedCategory != nil && !enteredTrackerName.isEmpty {
      createButton.isEnabled = true
      createButton.backgroundColor = .ypBlack
      createButton.setTitleColor(.ypWhite, for: .normal)
    } else {
      createButton.isEnabled = false
      createButton.backgroundColor = .ypGray
      createButton.setTitleColor(.ypWhite, for: .normal)
    }
  }

  @objc func cancel() {
    print("Cancel")
    dismiss(animated: true)
  }

  @objc func create(_ sender: UIButton) {
    print("Create")
    let newTracker = Tracker(id: UUID(),
                             title: self.enteredTrackerName,
                             color: .cSelection2,
                             emoji: "☠️",
                             schedule: [Weekday.monday,
                                        Weekday.tuesday,
                                        Weekday.wednesday,
                                        Weekday.thursday,
                                        Weekday.friday,
                                        Weekday.saturday,
                                        Weekday.sunday])

    self.trackerVC.createNewTracker(tracker: newTracker)
    self.delegate?.didCreateNewEvent(newTracker)
    self.dismiss(animated: true)
  }
}
extension EventViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tableList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
    cell.accessoryType = .disclosureIndicator
    cell.backgroundColor = .ypBackground
    cell.textLabel?.text = tableList[indexPath.row]
    cell.detailTextLabel?.text = selectedCategory?.title.rawValue
    cell.detailTextLabel?.textColor = .ypGray
    cell.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .medium)
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let selectedItem = tableList[indexPath.row]
    if selectedItem == "Категория" {
      let categoryViewController = CategoryViewController()
      categoryViewController.delegate = self
      let navigatonVC = UINavigationController(rootViewController: categoryViewController)
      present(navigatonVC, animated: true)
    }
  }
}

extension EventViewController: CategoryViewControllerDelegate {
  func categoryScreen(_ screen: CategoryViewController, didSelectedCategory category: TrackerCategory) {
    selectedCategory = category
    tableView.reloadData()
    checkCreateButtonValidation()
  }
}

extension EventViewController: UITextFieldDelegate {

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
    enteredTrackerName = textField.text ?? ""
    checkCreateButtonValidation()
    return true
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    enteredTrackerName = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
    checkCreateButtonValidation()
    return true
  }
}

extension EventViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == emojiCollectionView {
      return emojiList.count
    } else {
      return colorList.count
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == emojiCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath)
      let emojiLabel = UILabel()
      emojiLabel.text = emojiList[indexPath.row]
      emojiLabel.font = .systemFont(ofSize: 32)
      emojiLabel.textAlignment = .center
      cell.contentView.addSubview(emojiLabel)
      emojiLabel.translatesAutoresizingMaskIntoConstraints = false
      emojiLabel.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor).isActive = true
      emojiLabel.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
      cell.backgroundColor = colorList[indexPath.row]
      cell.layer.cornerRadius = 8
      cell.layer.masksToBounds = true
      return cell
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == emojiCollectionView {
      selectedEmoji = emojiList[indexPath.row]
    } else {
      selectedColor = colorList[indexPath.row]
    }
    checkCreateButtonValidation()
  }
}
