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
    configureTabBar()
    tabBarBorder()
  }

  private func configureTabBar() {
    let trackerViewController = TrackerViewController()
    let statisticsViewController = StatisticsViewController()

    trackerViewController.title = localizedString(key:"trakerTitle")
    statisticsViewController.title = localizedString(key:"statisticTitle")

    trackerViewController.tabBarItem.image = UIImage(named: "trackers_active")
    statisticsViewController.tabBarItem.image = UIImage(named: "statistics_active")

    let trackerNavigationController = UINavigationController(rootViewController: trackerViewController)
    trackerNavigationController.navigationBar.prefersLargeTitles = true
    let statisticsNavigationController = UINavigationController(rootViewController: statisticsViewController)
    statisticsNavigationController.navigationBar.prefersLargeTitles = true

    setViewControllers([trackerNavigationController, statisticsNavigationController], animated: true)
  }

  private func tabBarBorder() {
    let border = UIView()
    border.backgroundColor = .lightGray
    border.translatesAutoresizingMaskIntoConstraints = false
    tabBar.addSubview(border)

      border.topAnchor.constraint(equalTo: tabBar.topAnchor).isActive = true
      border.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor).isActive = true
      border.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor).isActive = true
      border.heightAnchor.constraint(equalToConstant: 1).isActive = true
  }

}
