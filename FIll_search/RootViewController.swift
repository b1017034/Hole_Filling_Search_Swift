//
//  RootViewController.swift
//  FIll_search
//
//  Created by 中村　朝陽 on 2018/06/14.
//  Copyright © 2018年 asahi. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    var MenuViewCountroller:UIViewController!
    var MainpageViewController:UIViewController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("RootViewController.init(coder)");
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("RootViewController.init(nibName, bundle)");
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("RootViewController.awakeFromNib");
        //viewcontrollerのロード
        self.MainpageViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainpage")
        self.MenuViewCountroller = self.storyboard?.instantiateViewController(withIdentifier: "menu")
        
        
        //menuviewcontrollerを子として設定
        self.addChildViewController(self.MenuViewCountroller)
        //自身のsubviewにmanuのsubviewをセット
        self.view.addSubview(self.MenuViewCountroller.view)
        //
        self.MenuViewCountroller.didMove(toParentViewController: self)
        
        self.addChildViewController(self.MainpageViewController)
        self.view.addSubview(self.MainpageViewController.view)
        self.MainpageViewController.didMove(toParentViewController: self)
        
        //メニューは非表示
        self.MenuViewCountroller.view.isHidden = true
        //メニューを上に
        self.view.bringSubview(toFront: self.MenuViewCountroller.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        print("RootViewController.viewDidLoad");
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("RootViewController.viewWillAppear\(animated))");
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("RootViewController.viewDidAppear(\(animated))");
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("RootViewController.viewWillDisappear(\(animated))");
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("RootViewController.viewDidDisappear(\(animated))");
    }
    //メニューの表示
    func presentMenuViewController(){
        MenuViewCountroller.beginAppearanceTransition(true, animated: true)
        self.MenuViewCountroller.view.isHidden = false
        self.MenuViewCountroller.view.frame = MenuViewCountroller.view.frame.offsetBy(dx: -MenuViewCountroller.view.frame.size.width / 2, dy: 0)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: UIViewAnimationOptions.curveEaseOut, animations:{
            let bounds = self.MenuViewCountroller.view.bounds
            self.MenuViewCountroller.view.frame = CGRect(x: -bounds.size.width / 2 , y:0 , width:bounds.size.width, height:bounds.size.height)
        }, completion: {_ in
            self.MenuViewCountroller.endAppearanceTransition()
        })
    }
    //メニューの非表示
    func dismissMuneViewController(){
        self.MenuViewCountroller.beginAppearanceTransition(false, animated: true)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.MenuViewCountroller.view.frame = self.MenuViewCountroller.view.frame.offsetBy(dx: -self.MenuViewCountroller.view.bounds.size.width / 2, dy: 0)
        }, completion: {_ in
            self.MenuViewCountroller.view.isHidden = true
            self.MenuViewCountroller.endAppearanceTransition()
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func set(mainpageViewController: UIViewController){
        // 既存コンテンツと新コンテンツが同じであれば無視する.
        if let currentMainpageViewController = self.MainpageViewController {
            guard type(of:currentMainpageViewController) != type(of:mainpageViewController) else { return }
        }
        
        // 既存コンテンツの開放
        self.MainpageViewController.willMove(toParentViewController: nil)
        self.MainpageViewController.view.removeFromSuperview()
        self.MainpageViewController.removeFromParentViewController()
        
        // 新コンテンツのセット
        self.MainpageViewController = mainpageViewController
        self.view.addSubview(mainpageViewController.view)
        self.view.bringSubview(toFront: self.MenuViewCountroller.view)
        self.addChildViewController(mainpageViewController)
        
        // 新コンテンツフェードイン
        mainpageViewController.view.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            mainpageViewController.view.alpha = 1
        }, completion: { _ in
            mainpageViewController.didMove(toParentViewController: self)
        })
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


extension UIViewController{
    func RootViewController() -> RootViewController? {
        var vc = self.parent
        while(vc != nil) {
            guard let viewController = vc else {return nil}
            if viewController is RootViewController{
                return viewController as? RootViewController
            }
            vc = viewController.parent
        }
        return nil
    }
}
