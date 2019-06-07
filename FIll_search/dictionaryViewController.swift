//
//  dictionaryViewController.swift
//  FIll_search
//
//  Created by 中村　朝陽 on 2018/07/05.
//  Copyright © 2018年 asahi. All rights reserved.
//

import UIKit

class dictionaryViewController: UIViewController, XMLParserDelegate  {
   
    var sendWord: String?
    //xmlタグと内容を入れる
    var ItemdDict: Dictionary = ["ErrorMessage": ""]
    //xmlタグ取得用
    var ID = ""
    //xmlの内容を一時保存するスタック
    var XmlStack = Stack<String>()
    
    @IBAction func `return`(_ sender: Any) {
        //前の画面へ遷移
        self.dismiss(animated: true, completion: nil)
    }
    //見出し語、SearchedTableViewControllerから受け取る
    @IBOutlet weak var textLabel: UILabel!
    
    var divText = ""
    @IBOutlet weak var contentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabel.text = sendWord
        //SearchedTableViewControllerから貰った単語をAPIに渡す
        getContent(serachWord: textLabel.text!)
        if(ItemdDict["TotalHitCount"] != "0"){
            getItemID(ItemID: ItemdDict["ItemID"]!)
        }else{
            divText = "ごめんなさい"
        }
        contentLabel.text = divText
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //ItemIDの取得とItemIDを渡して検索結果を受け取る
    func getContent(serachWord: String){
        let ItemIDurlString = "http://public.dejizo.jp/NetDicV09.asmx/SearchDicItemLite?Dic=EJdict&Word=\(serachWord)&Scope=HEADWORD&Match=EXACT&Merge=AND&Prof=JSON&PageSize=20&PageIndex=0"
        loadxml(urlString: ItemIDurlString)
        
    }
    
    func getItemID(ItemID: String){
        
        let contentUrlString = "http://public.dejizo.jp/NetDicV09.asmx/GetDicItemLite?Dic=EJdict&Item=\(ItemID)&Loc=&Prof=XHTML"
        loadxml(urlString: contentUrlString)
    }
    
    func getRequest(urlString: String){
        //let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        var request = URLRequest(url: URL(string: urlString)!)
        //getで送信
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            print("response: \(response!)")
            
            let phpOutput = String(data: data!, encoding: .utf8)!
            print("php output: \(phpOutput)")
        })
        task.resume()
    }
    
    func loadxml(urlString: String){
        guard let url = NSURL(string: urlString) else{
            return
        }
        
        // インターネット上のXMLを取得し、NSXMLParserに読み込む
        guard let parser = XMLParser(contentsOf: url as URL) else{
            return
        }
        parser.delegate = self;
        parser.parse()
    }
    
    
    // XML解析開始時に実行されるメソッド
    func parserDidStartDocument(_ parser: XMLParser) {
        print("XML解析開始しました")
    }
    
    // 解析中に要素の開始タグがあったときに実行されるメソッド
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        print("開始タグ:" + elementName)
        ID = elementName
    }
    
    // 開始タグと終了タグでくくられたデータがあったときに実行されるメソッド
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        print("要素:" + string)
        if(ID == "div"){
            if(string != "\n"){
                divText += string + "\n"
            }
            print(divText)
        }else{
            XmlStack.push(item: string)
        }
        
    }
    
    // 解析中に要素の終了タグがあったときに実行されるメソッド
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("終了タグ:" + elementName)
        ItemdDict[ID] = XmlStack.pop()
        ID = ""
    }
    
    // XML解析終了時に実行されるメソッド
    func parserDidEndDocument(_ parser: XMLParser) {
        print("XML解析終了しました")
        print(ItemdDict)
    }
    
    // 解析中にエラーが発生した時に実行されるメソッド
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("エラー:" + parseError.localizedDescription)
    }
    
    //英単語の原形を返すメソッド
    func toBaseVerb(word: String){
        var targetScheme = NSLinguisticTagScheme.lexicalClass;//品詞。英語のみ,Verb,Noun,SentenceTerminator
        
        
    }
    struct Stack<Element> {
        var items = [Element]()
        mutating func push(item: Element){
            items.append(item)
        }
        mutating func pop() ->Element {
            return items.removeLast()
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
