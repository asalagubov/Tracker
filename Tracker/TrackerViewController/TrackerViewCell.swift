//
//  TrackerViewCell.swift
//  Tracker
//
//  Created by Alexander Salagubov on 10.07.2024.
//

import Foundation
import UIKit

class TrackerCollectionViewCell: UICollectionViewCell {

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  lazy var bodyView: UIView = {
    let bodyView = UIView()
    bodyView.layer.cornerRadius = 16
    bodyView.translatesAutoresizingMaskIntoConstraints = false

    addSubview(bodyView)

    bodyView.heightAnchor.constraint(equalToConstant: 90).isActive = true
    bodyView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    bodyView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    bodyView.topAnchor.constraint(equalTo: topAnchor).isActive = true

    return bodyView
  }()

  lazy var emojiView: UIView = {
    let emojiView = UIView()
    emojiView.layer.cornerRadius = 12
    emojiView.layer.masksToBounds = true
    emojiView.backgroundColor = .white
    emojiView.alpha = 0.2
    emojiView.translatesAutoresizingMaskIntoConstraints = false

    addSubview(emojiView)

    emojiView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
    emojiView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
    emojiView.heightAnchor.constraint(equalToConstant: 24).isActive = true
    emojiView.widthAnchor.constraint(equalToConstant: 24).isActive = true

    return emojiView
  }()


  lazy var emojiLabel: UILabel = {
    let emojiLabel = UILabel()
    emojiLabel.font = .systemFont(ofSize: 12, weight: .medium)
    emojiLabel.translatesAutoresizingMaskIntoConstraints = false

    addSubview(emojiLabel)

    emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor).isActive = true
    emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor).isActive = true

    return emojiLabel
  }()

  lazy var titleLabel: UILabel = {
    let titleLabel = UILabel()
    titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
    titleLabel.textColor = .ypWhite
    titleLabel.numberOfLines = 2
    titleLabel.translatesAutoresizingMaskIntoConstraints = false

    addSubview(titleLabel)

    titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    titleLabel.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: -12).isActive = true

    return titleLabel
  }()

  lazy var dayCounter: UILabel = {
    let dayCounter = UILabel()
    dayCounter.font = .systemFont(ofSize: 12, weight: .medium)
    dayCounter.textColor = .ypBlack
    dayCounter.translatesAutoresizingMaskIntoConstraints = false

    addSubview(dayCounter)

    dayCounter.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
    dayCounter.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    dayCounter.topAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: 16).isActive = true

    return dayCounter
  }()

  lazy var plusButton: UIButton = {
    let plusButton = UIButton()
    plusButton.layer.cornerRadius = 17
    let buttonImage = UIImage(named: "plusButton")
    plusButton.setImage(buttonImage, for: .normal)
    plusButton.translatesAutoresizingMaskIntoConstraints = false

    addSubview(plusButton)

    plusButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
    plusButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
    plusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    plusButton.topAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: 8).isActive = true

    return plusButton
  }()


  func configureLabel(_ text: String) {
    titleLabel.text = text
  }

  func configureEmojiLabel(_ text: String) {
    emojiLabel.text = text
  }

  func configureDayLabel(_ text: String) {
    dayCounter.text = text
  }

  func configurePrimaryColor(_ color: UIColor) {
    bodyView.backgroundColor = color
    plusButton.tintColor = color
  }
}
