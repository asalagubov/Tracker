//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Alexander Salagubov on 10.07.2024.
//

import Foundation
import UIKit

protocol NewCategoryViewControllerDelegate: AnyObject {
    func newCategoryScreen(_ screen: NewCategoryViewController, didAddCategoryWithTitle title: String)
}

class NewCategoryViewController: UIViewController {
    weak var delegate: NewCategoryViewControllerDelegate?
    let textField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Новая категория"
        backGround()
        setupCategoryView()
        addButton()
    }

    private func backGround() {
        view.backgroundColor = .ypWhite
    }

    private func setupCategoryView() {
        textField.backgroundColor = .ypBackground
        textField.textColor = .ypBlack
        textField.placeholder = "Введите название категории"
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.rightView = paddingView
        textField.rightViewMode = .always
        textField.layer.cornerRadius = 16
        textField.layer.masksToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.hidesBackButton = true

        view.addSubview(textField)

        textField.heightAnchor.constraint(equalToConstant: 75).isActive = true
        textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
    }

    private func addButton() {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
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

        button.addTarget(self, action: #selector(addNewCategory), for: .touchUpInside)
    }

    @objc func addNewCategory() {
        guard let categoryTitle = textField.text, !categoryTitle.isEmpty else {
            // Показываем ошибку или сообщение пользователю
            return
        }
        delegate?.newCategoryScreen(self, didAddCategoryWithTitle: categoryTitle)
        navigationController?.popViewController(animated: true)
    }
}
