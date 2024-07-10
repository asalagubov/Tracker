//
//  ViewController.swift
//  Tracker
//
//  Created by Alexander Salagubov on 28.06.2024.
//

import UIKit

class TrackerViewController: UIViewController {

  var categories: [TrackerCategory] = []
  var completedTrackers: [TrackerRecorder] = []

  private let trackerList = ["Поливать растения", "Кошка заслонила камеру на созвоне", "Бабушка прислала открытку в вотсапе"]
  private let daysList = ["9 дней", "2 дня", "8 дней"]
  private let emojiList = ["❤️️️️️️️", "😻", "🌺"]
  private let colorList : [UIColor] = [.cSelection4, .cSelection11, .cSelection18]

  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .ypWhite
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.showsVerticalScrollIndicator = false
    collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    return collectionView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    backGround()
    setupTrackerView()
    setupDatePicker()
    setupCollectionView()
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

    stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
    stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    image.heightAnchor.constraint(equalToConstant: 80).isActive = true
    image.widthAnchor.constraint(equalToConstant: 80).isActive = true

  }
  private func setupDatePicker() {
    let datePicker = UIDatePicker()
    datePicker.preferredDatePickerStyle = .compact
    datePicker.datePickerMode = .date
    datePicker.locale = Locale(identifier: "ru_RU")
    datePicker.tintColor = .ypBlue
    datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)

    view.addSubview(datePicker)

    datePicker.translatesAutoresizingMaskIntoConstraints = false
    datePicker.widthAnchor.constraint(equalToConstant: 120).isActive = true

    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
  }

  private func setupCollectionView() {
    view.addSubview(collectionView)

    collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
  }

  @objc func plusButtonTapped() {
    print("PlusButtonTapped")
    let newTrackerVC = NewTrackerViewController()
    let navigationController = UINavigationController(rootViewController: newTrackerVC)
    navigationController.modalPresentationStyle = .popover
    present(navigationController, animated: true, completion: nil)
  }
  @objc func datePickerChanged() {
    print("CalendarTapped")
  }
}
extension TrackerViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    trackerList.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCollectionViewCell else { return UICollectionViewCell() }
    cell.configurePrimaryColor(colorList[indexPath.item])
    cell.configureEmojiLabel(emojiList[indexPath.item])
    cell.configureLabel(trackerList[indexPath.item])
    cell.configureDayLabel(daysList[indexPath.item])
    return cell
  }
}
  extension TrackerViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let itemCount : CGFloat = 2
      let space: CGFloat = 9
      let width : CGFloat = (collectionView.bounds.width - space - 32) / itemCount
      let height : CGFloat = 148
      return CGSize(width: width , height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      return 9
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
    }

  }


