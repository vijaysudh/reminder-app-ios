//  ApplicationConfiguration.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/21/23.
//  
//

import Foundation

protocol ApplicationConfig {
    var environment: AppSystem { get }
}

enum AppSystem: String {
    case mock = "mock"
    case test  = "test"
    case production = "production"
}

fileprivate struct MockAppConfig: ApplicationConfig {
    var environment: AppSystem = .mock
    // TODO: Add additional parameters required for the App for Factory Injection
}

fileprivate struct TestAppConfig: ApplicationConfig {
    var environment: AppSystem = .test
    // TODO: Add additional parameters required for the App for Factory Injection
}

fileprivate struct ProductionAppConfig: ApplicationConfig {
    var environment: AppSystem = .production
    // TODO: Add additional parameters required for the App for Factory Injection
}

class ApplicationConfiguration {
    static let sharedInstance = ApplicationConfiguration()
    
    func getApplicationConfig() -> ApplicationConfig {
        guard let infoDictionary = Bundle.main.infoDictionary, 
                let appConfig = infoDictionary["ApplicationConfiguration"] as? String,
              let appSystem = AppSystem(rawValue: appConfig)
        else {
            return MockAppConfig()
        }

        switch(appSystem) {
        case .mock:
            return MockAppConfig()
        case .test:
            return TestAppConfig()
        case .production:
            return ProductionAppConfig()
        }
    }
}

