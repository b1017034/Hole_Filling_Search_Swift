//
//  MainpageViewController.swift
//  FIll_search
//
//  Created by 中村　朝陽 on 2018/06/14.
//  Copyright © 2018年 asahi. All rights reserved.
//

import UIKit

class MainpageViewController: UIViewController {

    @IBAction func openMenuBar(_ sender: Any) {
        guard let RootViewController = RootViewController() else {return}
        RootViewController.presentMenuViewController()
        print("ok")
    }
    @IBAction func toMenu(_ sender: Any) {
        guard let RootViewController = RootViewController() else {return}
        RootViewController.presentMenuViewController()
        print("ok")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
