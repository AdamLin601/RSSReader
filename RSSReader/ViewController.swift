//
//  ViewController.swift
//  RSSReader
//
//  Created by 林奕德 on 2018/4/9.
//  Copyright © 2018年 AppsAdamLin. All rights reserved.
//

import UIKit
struct NewsItem {
    var title :String?
    var link : String?
}

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var objects = [NewsItem]() //小括號產生一個陣列 裡面準備存NewsItem
    let XmlAddress = "https://www.cnet.com/rss/news/"
    
    var session = URLSession(configuration: .default) //產生一個URLSession實體
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
//        let naws1 = NewsItem(title: "first news", link: "http://www.apple.com")
//        let naws2 = NewsItem(title: "second news", link: "https://google.com")
//        let naws3 = NewsItem(title: "third news", link: "https://twitch.tv")
//
//        objects = [naws1,naws2,naws3]
        downloadXML(withXMLAddress: XmlAddress)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       
        cell.textLabel?.text =  objects[indexPath.row].title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //選到tableView的其中一列就會實作
        tableView.deselectRow(at: indexPath, animated: true)//取消選取
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInfo"{
            if  let dvc = segue.destination as? WebViewController{
               
                if let selectedRow = myTableView.indexPathForSelectedRow?.row{
                  dvc.linkFromViewOne = objects[selectedRow].link //網址
                }
            }
        }
    }
    func downloadXML(withXMLAddress xmlAddress:String){ //withXMLAddress 外部參數
        if let url = URL(string: xmlAddress){
            let task =  session.dataTask(with: url,completionHandler: {
                (data, response, error) in
                if error != nil{
                    DispatchQueue.main.async {
                        self.popAlert(withTitle: "Sorry")
                    }
                    return
                    }
                if  let okData = data{
                    let parser = XMLParser(data: okData) //parse 分析
//                   print(NSString(data: okData, encoding: String.Encoding.utf8.rawValue))//  encoding編碼方式  rawValue 轉成數字
                   let rssParserDelegate = RssParserDelegate()
                    parser.delegate = rssParserDelegate
                    if parser.parse() == true{
                       self.objects = rssParserDelegate.getResult()
                        DispatchQueue.main.async {
                            self.myTableView.reloadData()
                        }
                    }else{
                        print("parse fail")
                    }
                }
            })
            task.resume()
        }
    }
    func popAlert(withTitle title :String) {
        let alert = UIAlertController(title: title, message: "Please try again later", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

