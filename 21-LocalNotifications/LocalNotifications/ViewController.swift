//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Benjamin van den Hout on 04/05/2020.
//  Copyright © 2020 Benjamin van den Hout. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }

    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Granted")
            } else {
                print("Not granted: \(error?.localizedDescription ?? "nil")")
            }
        }
    }

    @objc func scheduleLocal() {
        let center = UNUserNotificationCenter.current()

        // TEST
        center.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "Wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData" : "fizzbuzz"]
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30

//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        // TEST
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)



    }

}

