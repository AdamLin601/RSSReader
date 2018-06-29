//
//  RssParserDelegate.swift
//  RSSReader
//
//  Created by 林奕德 on 2018/4/9.
//  Copyright © 2018年 AppsAdamLin. All rights reserved.
//

import Foundation
class RssParserDelegate:NSObject,XMLParserDelegate{ //先為NSObject的子類別 才能服從XMLParserDelegate協定
    var currentItem:NewsItem?
    var currentElementValue:String?
    var resultsArray = [NewsItem]()
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "item"{
            //start a new item
           currentItem = NewsItem()
        }else if elementName == "title"{
            currentElementValue = nil
        }else if elementName == "link"{
            currentElementValue = nil
        }
    }//遇到開始標籤做
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item"{
            if currentItem != nil{
                resultsArray.append(currentItem!)
                currentItem = nil
            }else if elementName == "title"{
                currentItem?.title = currentElementValue
            }else if elementName == "link"{
                currentItem?.link = currentElementValue
            }
            currentElementValue = nil
        }
    }//遇到結束標籤做
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElementValue == nil{
           currentElementValue =  string
        }else {
           currentElementValue = currentElementValue! + string
        }
    }//解析到何資料時做
    func getResult()-> [NewsItem] {
        return resultsArray
    }
}
