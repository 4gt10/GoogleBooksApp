//
//  AppDelegate.swift
//  GoogleBooksApp
//
//  Created by Artur Chernov on 07/04/2018.
//  Copyright © 2018 Artur Chernov. All rights reserved.
//

import UIKit
import PluggableAppDelegate

@UIApplicationMain
final class AppDelegate: PluggableApplicationDelegate {

    override var services: [ApplicationService] {
        return [
            URLHandlableApplicationService()
        ]
    }
}

