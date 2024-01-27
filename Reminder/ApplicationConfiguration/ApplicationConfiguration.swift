//  ApplicationConfiguration.swift
//  Reminder
//
//  Created by Vijaysudh M on 12/21/23.
//  
//

import Foundation

protocol ApplicationConfig {
    var environment: AppSystem { get }
    var reminderRepository: any ReminderRepositoryInterface { get }
    var categoryListRepository: any CategoryListRepositoryInterface { get }
}

enum AppSystem: String {
    case mock
    case test
    case production
}

private struct MockAppConfig: ApplicationConfig {
    var environment: AppSystem = .mock
    // TODO: Need to change to MOCK

    var reminderRepository: any ReminderRepositoryInterface = CoreDataReminderManager(alarmDetailManager:
                                                                                        CoreDataAlarmDetailManager())
    var categoryListRepository: any CategoryListRepositoryInterface = CoreDataCategoryListManager()
}

private struct TestAppConfig: ApplicationConfig {
    var environment: AppSystem = .test
    // TODO: Need to change to In Memory
    var reminderRepository: any ReminderRepositoryInterface = CoreDataReminderManager(alarmDetailManager:
                                                                                        CoreDataAlarmDetailManager())
    var categoryListRepository: any CategoryListRepositoryInterface = CoreDataCategoryListManager()
}

private struct ProductionAppConfig: ApplicationConfig {
    var environment: AppSystem = .production
    var reminderRepository: any ReminderRepositoryInterface = CoreDataReminderManager(alarmDetailManager:
                                                                                        CoreDataAlarmDetailManager())
    var categoryListRepository: any CategoryListRepositoryInterface = CoreDataCategoryListManager()
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

        switch appSystem {
        case .mock:
            return MockAppConfig()
        case .test:
            return TestAppConfig()
        case .production:
            return ProductionAppConfig()
        }
    }
}
