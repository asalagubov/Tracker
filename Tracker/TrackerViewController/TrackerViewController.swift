//
//  ViewController.swift
//  Tracker
//
//  Created by Alexander Salagubov on 28.06.2024.
//

import UIKit

protocol ReloadCollectionProtocol: AnyObject {
  func reloadCollection()
}

class TrackerViewController: UIViewController {

  var completedTrackers: [TrackerRecorder] = []


  private let trackerRepo = TrackerRepo.shared

  let datePicker = UIDatePicker()
  let stackView = UIStackView()
  let label = UILabel()
  let image = UIImageView()
  let currentDate = Calendar.current

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
    mainScreenContent(Date())
  }

  private func mainScreenContent(_ date: Date) {
    showTrackersInDate(date)
    reloadHolders()
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

    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 8
    view.addSubview(stackView)

    image.translatesAutoresizingMaskIntoConstraints = false
    image.image = UIImage(named: "tracker_stub")
    stackView.addArrangedSubview(image)

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

  private func reloadHolders() {
    let allTrackersEmpty = trackerRepo.checkIsTrackerRepoEmpty()
    let visibleTrackersEmpty = trackerRepo.checkIsVisibleEmpty()

    if allTrackersEmpty || visibleTrackersEmpty {
      collectionView.isHidden = true
      image.isHidden = false
      label.isHidden = false
      stackView.isHidden = false
    } else {
      collectionView.isHidden = false
      image.isHidden = true
      label.isHidden = true
      stackView.isHidden = true
    }
  }

  @objc func plusButtonTapped() {
    print("PlusButtonTapped")
    let newTrackerVC = NewTrackerViewController()
      newTrackerVC.habitDelegate = self
    let navigationController = UINavigationController(rootViewController: newTrackerVC)
    navigationController.modalPresentationStyle = .popover
    present(navigationController, animated: true, completion: nil)
  }

  @objc func datePickerChanged() {
    print("CalendarTapped")
    mainScreenContent(datePicker.date)
  }

  private func checkIsTrackerCompletedToday(id: UUID) -> Bool {
    completedTrackers.contains { trackerRecord in
      let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
      return trackerRecord.id == id && isSameDay
    }
  }

  private func showTrackersInDate(_ date: Date) {
    trackerRepo.removeAllVisibleCategory()
    let weekday = currentDate.component(.weekday, from: date)
    trackerRepo.appendTrackerInVisibleTrackers(weekday: weekday)
    collectionView.reloadData()
  }
}

extension TrackerViewController: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    trackerRepo.getNumberOfCategories()
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    trackerRepo.getNumberOfItemsInSection(section: section)
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCollectionViewCell else { return UICollectionViewCell() }
    let tracker = trackerRepo.getTrackerDetails(section: indexPath.section, item: indexPath.item)
    cell.delegate = self
    let isCompletedToday = checkIsTrackerCompletedToday(id: tracker.id)
    let completedDays = completedTrackers.filter { $0.id == tracker.id }.count
    cell.configureCell(tracker: tracker,
                       isCompletedToday: isCompletedToday,
                       completedDays: completedDays,
                       indexPath: indexPath
    )

    if datePicker.date > Date() {
      cell.plusButton.isHidden = true
    }  else {
      cell.plusButton.isHidden = false
    }

    return cell
  }
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let itemCount: CGFloat = 2
    let space: CGFloat = 9
    let width: CGFloat = (collectionView.bounds.width - space - 32) / itemCount
    let height: CGFloat = 148
    return CGSize(width: width, height: height)
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

extension TrackerViewController: TrackerDoneDelegate {
  func completeTracker(id: UUID, indexPath: IndexPath) {
    let trackerRecord = TrackerRecorder(id: id, date: datePicker.date)
    completedTrackers.append(trackerRecord)
    collectionView.reloadItems(at: [indexPath])
  }

  func uncompleteTracker(id: UUID, indexPath: IndexPath) {
    completedTrackers.removeAll { trackerRecord in
      let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
      return trackerRecord.id == id && isSameDay
    }
    collectionView.reloadItems(at: [indexPath])
  }
}

extension TrackerViewController: NewTrackerToTrckerVcDelegate {
    func didDelegateNewTracker(_ tracker: Tracker) {
        print("didCreateNewHabit asked")
        mainScreenContent(Date())
    }
}
