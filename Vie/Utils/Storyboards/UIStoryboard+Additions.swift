//
//  UIStoryboard+Additions.swift
//  MyJoi
//
//  Created by Nermeen Mohamed on 11/26/18.
//  Copyright © 2018 Nermeen Mohamed. All rights reserved.
//

// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit

// swiftlint:disable file_length

protocol StoryboardType {
    static var storyboardName: String { get }
}

extension StoryboardType {
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: self.storyboardName, bundle: Bundle(for: BundleToken.self))
    }
}

struct SceneType<T: Any> {
    let storyboard: StoryboardType.Type
    let identifier: String
    
    func instantiate() -> T {
        guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
        }
        return controller
    }
}

struct InitialSceneType<T: Any> {
    let storyboard: StoryboardType.Type
    
    func instantiate() -> T {
        guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
            fatalError("ViewController is not of the expected class \(T.self).")
        }
        return controller
    }
}

protocol SegueType: RawRepresentable { }

extension UIViewController {
    func perform<S: SegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
        performSegue(withIdentifier: segue.rawValue, sender: sender)
    }
}

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
enum StoryboardScene {
    
    enum Main: StoryboardType {
        static let storyboardName = "Main"
        
        static let mapVC = SceneType<Vie.MapVC>(storyboard: Main.self, identifier: "MapVC")
        static let venueListNavigationController = SceneType<UINavigationController>(storyboard: Main.self, identifier: "venueListNavigationController")
        
        static let venueListVC = SceneType<Vie.VenueListVC>(storyboard: Main.self, identifier: "VenueListVC")
    }
}

enum StoryboardSegue {
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

private final class BundleToken {}
