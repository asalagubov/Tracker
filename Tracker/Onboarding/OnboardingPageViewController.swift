//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Alexander Salagubov on 05.08.2024.
//

import Foundation
import UIKit

final class OnboardingPageViewController: UIViewController {
  private let imageView = UIImageView()
  private let label = UILabel()
  private let finishButton = UIButton()
  
  init(imageName: String, text: String) {
    super.init(nibName: nil, bundle: nil)
    imageView.image = UIImage(named: imageName)
    label.text = text
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupFinishButton()
  }
  
  private func setupUI() {
    view.backgroundColor = .white
    
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(imageView)
    
    label.font = .systemFont(ofSize: 24, weight: .bold)
    label.textColor = .black
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(label)
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: view.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -304)
    ])
  }
  
  private func setupFinishButton() {
    finishButton.setTitle(localizedString(key:"onboardTitle"), for: .normal)
    finishButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    finishButton.backgroundColor = .black
    finishButton.layer.cornerRadius = 16
    finishButton.layer.masksToBounds = true
    finishButton.translatesAutoresizingMaskIntoConstraints = false
    finishButton.addTarget(self, action: #selector(finishOnboarding), for: .touchUpInside)
    view.addSubview(finishButton)
    
    NSLayoutConstraint.activate([
      finishButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -84),
      finishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      finishButton.heightAnchor.constraint(equalToConstant: 60)
    ])
  }
  
  @objc private func finishOnboarding() {
    UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
      sceneDelegate.window?.rootViewController = TabBarController()
    }
  }
}
