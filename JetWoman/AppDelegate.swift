//
//  AppDelegate.swift
//  JetWoman
//
//  Created by Guilherme B V Bahia on 16/06/17.
//  Copyright © 2017 Planet Bang. All rights reserved.
//


import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
   @IBAction func resetScoreClicked(_ sender: Any) {
      print("resetScoreClicked")
      UserDefaults.standard.set(0, forKey: "highscore")
      if let vc = NSApplication.shared().windows.first?.contentViewController as? ViewController {
         if let scene = vc.skView.scene as? GameScene {
            scene.fillHighScore()
         }
      }
   }
}
