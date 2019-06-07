//
//  SearchedTableViewController.swift
//  FIll_search
//
//  Created by 中村　朝陽 on 2018/07/03.
//  Copyright © 2018年 asahi. All rights reserved.
//

import UIKit
import Foundation

class SearchedTableViewController: UITableViewController , UISearchBarDelegate{
    
    @IBOutlet var coreTextTableView: UITableView!
    @IBOutlet weak var wordSerchBar: UISearchBar!
    
    var searchResults:[String] = []
    //データ保持
    var ArrContent: [String] = []
    var pattern = ""
    var word: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadtext()
        wordSerchBar.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadtext(){
        if let path: String = Bundle.main.path(forResource: "VEP_words", ofType: "txt") {
            do {
                // ファイルの内容を取得する
                let content = try String(contentsOfFile: path)
                //ファイルを配列に変換
                ArrContent = content.components(separatedBy: .newlines)
                //print("content: \(content)")
            } catch  {
                print("ファイルの内容取得時に失敗")
            }
        }else {
            print("指定されたファイルが見つかりません")
            
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if wordSerchBar.text != "" {
            return searchResults.count
        } else {
            return ArrContent.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = coreTextTableView.dequeueReusableCell(withIdentifier: "wordsCell", for: indexPath)
        if wordSerchBar.text != "" {
            cell.textLabel?.text = "\(searchResults[indexPath.row])"
        } else {
            cell.textLabel?.text = ArrContent[indexPath.row]
        }
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell: \(indexPath.row) words : \(ArrContent[indexPath.row])")
        if wordSerchBar.text != "" {
            word = searchResults[indexPath.row]
        } else {
            word = ArrContent[indexPath.row]
        }
        
        self.performSegue(withIdentifier: "dict",sender: self.word)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dict" {
            let DictionaryViewController = segue.destination as! dictionaryViewController
            DictionaryViewController.sendWord = sender as! String
        }
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dictionaryViewController = segue.destination as! dictionaryViewController
        dictionaryViewController.sendWord = word
        
    }*/
    
    /* // 検索ボタンが押された時に呼ばれる
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.showsCancelButton = true
        self.searchResults = ArrContent.filter{
            // 大文字と小文字を区別せずに検索
            $0.lowercased().contains(searchBar.text!.lowercased())
        }
        self.tableView.reloadData()
    }
 */
    
    func searchBar(_ searchBar: UISearchBar, textDidChange serachText: String) {
        //self.view.endEditing(true)
        searchBar.showsCancelButton = true
        self.searchResults = getMatchStrings(targetArray: ArrContent, searchText: (wordSerchBar.text)!)
        self.tableView.reloadData()
    }
    
    // キャンセルボタンが押された時に呼ばれる
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.view.endEditing(true)
        searchBar.text = ""
        self.tableView.reloadData()
    }
    
    // テキストフィールド入力開始前に呼ばれる
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    func getMatchStrings(targetArray: [String], searchText: String) -> [String]{
        var matchStrings:[String] = []
    
        let pattern = searchText.replacingOccurrences(of: " ", with: "[a-z]")
        print("\(pattern)")
        do{
            //正規表現に使うStringのセット
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            for targetString in targetArray{
                //捜査する範囲の指定
                let targetStringRange = NSRange(location: 0, length: (targetString as NSString).length)
                //???????????????????????????????????
                let matches = regex.matches(in: targetString, options: [], range: targetStringRange)
                
                for match in matches{
                    //これもうわかんねえなぁ
                    let range = match.range(at: 0)
                    let result = (targetString as NSString).substring(with: range)
                    if(targetString[..<targetString.index(targetString.startIndex, offsetBy: result.count)] == result){
                        matchStrings.append(targetString)
                    }
                }
                
            }
            return matchStrings
        }catch{
            print("not get")
        }
        return []
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
