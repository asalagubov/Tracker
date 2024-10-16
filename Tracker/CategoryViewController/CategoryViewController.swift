//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Alexander Salagubov on 10.07.2024.
//
import Foundation
import UIKit

protocol CategoryViewControllerDelegate: AnyObject {
  func categoryScreen(_ screen: CategoryViewController, didSelectedCategory category: TrackerCategory)
}

final class CategoryViewController: UIViewController, NewCategoryViewControllerDelegate {
  weak var delegate: CategoryViewControllerDelegate?
  private var viewModel: CategoryViewModel!
  
  private let tableView = UITableView()
  private let stackView = UIStackView()
  private let button = UIButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Категории"
    setupUI()
    setupViewModel()
    setupBindings()
    loadCategories()
  }
  
  private func setupUI() {
    view.backgroundColor = .ypWhite
    setupCategoryView()
    addButton()
    setupTableView()
  }
  
  private func setupViewModel() {
    viewModel = CategoryViewModel(store: TrackerCategoryStore())
  }
  
  private func setupBindings() {
    viewModel.onCategoriesChanged = { [weak self] categories in
      self?.tableView.reloadData()
      self?.mainScreenContent()
    }
    
    viewModel.onCategorySelected = { [weak self] category in
      guard let self = self else { return }
      self.delegate?.categoryScreen(self, didSelectedCategory: category)
    }
  }
  
  private func setupCategoryView() {
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
    label.text = "Привычки и события можно \nобъединить по смыслу"
    label.font = .systemFont(ofSize: 12, weight: .medium)
    label.numberOfLines = 0
    label.textAlignment = .center
    stackView.addArrangedSubview(label)
    
    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      image.heightAnchor.constraint(equalToConstant: 80),
      image.widthAnchor.constraint(equalToConstant: 80)
    ])
  }
  
  private func addButton() {
    button.setTitle("Добавить категорию", for: .normal)
    button.layer.cornerRadius = 16
    button.layer.masksToBounds = true
    button.backgroundColor = .ypBlack
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    button.setTitleColor(.ypWhite, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(button)
    
    button.addTarget(self, action: #selector(addCategory), for: .touchUpInside)
    
    NSLayoutConstraint.activate([
      button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      button.heightAnchor.constraint(equalToConstant: 60),
      button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
    ])
  }
  
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.layer.cornerRadius = 16
    tableView.rowHeight = 75
    tableView.isScrollEnabled = true
    tableView.showsVerticalScrollIndicator = false
    tableView.backgroundColor = .ypWhite
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseIdentifier)
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
      tableView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -16)
    ])
  }
  
  @objc private func addCategory() {
    let addNewCategoryVC = NewCategoryViewController()
    addNewCategoryVC.delegate = self
    navigationController?.pushViewController(addNewCategoryVC, animated: true)
  }
  
  func newCategoryScreen(_ screen: NewCategoryViewController, didAddCategoryWithTitle title: String) {
    viewModel.addCategory(title: title)
  }
  
  private func loadCategories() {
    viewModel.loadCategories()
  }
  
  private func mainScreenContent() {
    if viewModel.numberOfCategories() == 0 {
      tableView.isHidden = true
      stackView.isHidden = false
    } else {
      tableView.isHidden = false
      stackView.isHidden = true
    }
  }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfCategories()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseIdentifier, for: indexPath) as! CategoryTableViewCell
    let category = viewModel.category(at: indexPath.row)
    cell.configure(with: category)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.selectCategory(at: indexPath.row)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      self.dismiss(animated: true)
    }
  }
}
