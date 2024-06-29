//
//  TabBarController.swift
//  Tracker
//
//  Created by Alexander Salagubov on 29.06.2024.
//

import Foundation
import UIKit


class TabBarController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let traсkerViewController = TrackerViewController()
    traсkerViewController.tabBarItem = UITabBarItem(
      title: "Трекеры",
      image: UIImage(named: "trackers_active"),
      selectedImage: nil)

    let statisticsViewController = StatisticsViewController()
    statisticsViewController.tabBarItem = UITabBarItem(
      title: "Статистика",
      image: UIImage(named: "statistics_active"),
      selectedImage: nil)

    self.viewControllers = [traсkerViewController, statisticsViewController]

    tabBarBorder()
  }

  private func tabBarBorder() {
      let border = UIView()
      border.backgroundColor = .lightGray
      border.translatesAutoresizingMaskIntoConstraints = false
      tabBar.addSubview(border)

      NSLayoutConstraint.activate([
          border.topAnchor.constraint(equalTo: tabBar.topAnchor),
          border.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
          border.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
          border.heightAnchor.constraint(equalToConstant: 1)
      ])
  }

}
