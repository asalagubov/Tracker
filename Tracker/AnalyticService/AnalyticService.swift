//
//  AnalyticService.swift
//  Tracker
//
//  Created by Alexander Salagubov on 19.08.2024.
//

import Foundation
import YandexMobileMetrica

struct AnalyticsService {
  static func activate() {
    let configuration = YMMYandexMetricaConfiguration(apiKey: "01867188-8964-4f57-862c-27cb89ab4c2e")
    guard let validConfiguration = configuration else {
      print("Failed to create YMMYandexMetricaConfiguration")
      return
    }
    
    YMMYandexMetrica.activate(with: validConfiguration)
  }

  func report(event: String, params: [AnyHashable: Any]) {
    YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
      print("REPORT ERROR: %@", error.localizedDescription)
    })
  }
}
