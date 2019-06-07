//
//  SearchedTextViewController.swift
//  FIll_search
//
//  Created by 中村　朝陽 on 2018/07/02.
//  Copyright © 2018年 asahi. All rights reserved.
//

import UIKit

class SearchedTextViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serch()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func serch(){
        if let path: String = Bundle.main.path(forResource: "VEP_words", ofType: "txt") {
            do {
                // ファイルの内容を取得する
                let content = try String(contentsOfFile: path)
                let ArrContent = content.components(separatedBy: .newlines)
                print("content: \(content)")
                resultLabel.numberOfLines = ArrContent.count
                resultLabel.text = content
            } catch  {
                print("ファイルの内容取得時に失敗")
            }
        }else {
            print("指定されたファイルが見つかりません")
            
        }
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
