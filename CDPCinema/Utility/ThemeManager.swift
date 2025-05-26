//
//  ThemeManager.swift
//  CDPCinema
//
//  Created by Tanmay Deo on 26/05/25.
//

import Foundation
import UIKit

enum AppTheme {
    case light
    case dark
}

final class ThemeManager {
    static let shared = ThemeManager()
    
    private init() {
        currentTheme = .light
    }
    
    var currentTheme: AppTheme {
        didSet {
            NotificationCenter.default.post(name: .themeChanged, object: nil)
        }
    }
    
    var titleColor : UIColor {
        switch currentTheme {
        case .light:
            return UIColor.black
        case .dark:
            return UIColor.white
        }
    }
    
    var defaultBackgroundColor : UIColor {
        switch currentTheme {
        case .light:
            return UIColor.white
        case .dark:
            return UIColor.black
        }
    }
    
    var navigationBarColor: UIColor {
        switch currentTheme {
        case .light:
            return .white
        case .dark:
            return .black
        }
    }
    
    var tabBarColor: UIColor {
        switch currentTheme {
        case .light:
            return .white
        case .dark:
            return .black
        }
    }
    
    var barTintColor: UIColor {
        switch currentTheme {
        case .light:
            return .systemBlue
        case .dark:
            return .systemYellow
        }
    }
    
    var defaultTextColor: UIColor {
        switch currentTheme {
        case .light:
            return .black
        case .dark:
            return .white
        }
    }
    
    var secondaryTextColor: UIColor {
        switch currentTheme {
        case .light:
            return .darkGray
        case .dark:
            return .lightGray
        }
    }
    
    func toggleTheme() {
        currentTheme = (currentTheme == .light) ? .dark : .light
    }
    
    func applyTheme(navigationController: UINavigationController?, tabBarController: UITabBarController?) {
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = navigationBarColor
        navAppearance.titleTextAttributes = [.foregroundColor: defaultTextColor]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: defaultTextColor]
        
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
        UINavigationBar.appearance().tintColor = barTintColor
        
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = tabBarColor
        tabAppearance.stackedLayoutAppearance.selected.iconColor = barTintColor
        tabAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: barTintColor]
        tabAppearance.stackedLayoutAppearance.normal.iconColor = secondaryTextColor
        tabAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: secondaryTextColor]
        
        UITabBar.appearance().standardAppearance = tabAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        }
        
        if let navBar = navigationController?.navigationBar {
            navBar.standardAppearance = navAppearance
            navBar.scrollEdgeAppearance = navAppearance
            navBar.compactAppearance = navAppearance
            navBar.tintColor = barTintColor
            navBar.setNeedsLayout()
        }
        
        if let tabBar = tabBarController?.tabBar {
            tabBar.standardAppearance = tabAppearance
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = tabAppearance
            }
            tabBar.setNeedsLayout()
        }
    }
}

extension Notification.Name {
    static let themeChanged = Notification.Name("themeChanged")
}
