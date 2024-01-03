import UIKit

enum Theme {
    case light
    case dark
}

class ThemeManager {
    static let shared = ThemeManager()

    var currentTheme: Theme = .dark {
        didSet {
            NotificationCenter.default.post(name: ThemeManager.themeChangedNotification, object: nil)
        }
    }

    static let themeChangedNotification = Notification.Name("ThemeChangedNotification")

    func toggleTheme() {
        currentTheme = (currentTheme == .dark) ? .light : .dark
    }

    }
