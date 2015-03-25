//
//  JiShuViewController.swift
//  itjh
//
//  Created by aiteyuan on 15/2/3.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

import UIKit

class JiShuViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    var atableView: UITableView!
    var JiShuCellID = "JiShuCell" as String
    //页码
    var PAGE_NUM  = 0
    //一页要现实的数量
    let SHOW_NUM = 12
    //文章列表数据
    var dataList:[Article] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        atableView = UITableView(frame: view.bounds, style: .Plain)
        if let theTableView = atableView{
            theTableView.registerClass(JiShuViewCell.self, forCellReuseIdentifier: "JiShuCell")
            theTableView.dataSource = self
            theTableView.delegate = self
            theTableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            view.addSubview(theTableView)
        }
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        var hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.tabBarController?.view, animated: true)
        hud.labelText = "正在加载";
        hud.dimBackground = true;
        getNetData(PAGE_NUM, size: SHOW_NUM)
        setupRefresh()
    }

    func setupRefresh(){
        self.atableView.addHeaderWithCallback({
            let delayInSeconds:Int64 =  1000000000  * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                    self.PAGE_NUM = 0
                println("PAGE_NUM =\(self.PAGE_NUM)")
                    self.getNetData(self.PAGE_NUM, size: self.SHOW_NUM)
                    self.atableView.headerEndRefreshing()
            })
        })
        
        self.atableView.addFooterWithCallback({
            let delayInSeconds:Int64 = 1000000000 * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                println("PAGE_NUM =\(self.PAGE_NUM)")
                self.getNetData(self.dataList.count, size: self.SHOW_NUM)
                self.atableView.footerEndRefreshing()
            })
            
        })
        
    }
    
    func getNetData(offset : Int, size : Int){
        var url:String = GET_ARTICLE_Category + "/2/"
        var articleUrl = url + "\(offset)/\(size)"
        let theurl:NSURL = NSURL(string: articleUrl)!
        let urlRequest = NSMutableURLRequest(URL: theurl)
        urlRequest.HTTPMethod = "GET"
        let queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(urlRequest,
            queue: queue,
            completionHandler: {(response: NSURLResponse!, data: NSData!, error: NSError!) in
                if data.length > 0 && error == nil{
                    //let returnStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    //println(returnStr)
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in 
//                        
//                        MBProgressHUD.hideAllHUDsForView(self.tabBarController?.view, animated: true)
//                    })
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        println("dd")
                        MBProgressHUD.hideAllHUDsForView(self.tabBarController?.view, animated: true)
                    })
                    self.retrieveJsonFromData(data)
                } else if data.length == 0 && error == nil{
                    println("Nothing was downloaded")
                } else if error != nil{
                    println("Error happened = \(error)")
                }
                MBProgressHUD.hideAllHUDsForView(self.tabBarController?.view, animated: true)
            }
        )

    }
    
    func retrieveJsonFromData(data: NSData){
        var error: NSError?
        let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data,
            options: .AllowFragments,
            error: &error)
        if  error == nil{
            if jsonObject is NSDictionary{
                let deserializedDictionary:NSDictionary = jsonObject as NSDictionary
                var currentArticleData:[Article] =  []
                //文章列表array
                let articlesArray:NSArray? = deserializedDictionary["content"] as? NSArray
                if articlesArray?.count < 1{
                    return
                }
                for currentArticle in articlesArray!{
                    let article = Article()
                    article.aid = currentArticle["aid"] as Int
                    article.title = currentArticle["title"] as String
                    article.date = currentArticle["date"] as String
                    article.img = currentArticle["img"] as String
                    article.author_id = currentArticle["author_id"] as Int
                    article.author = currentArticle["author"] as String
                    currentArticleData.append(article)
                }
                if PAGE_NUM == 0 {
                    self.dataList.removeAll(keepCapacity: true)
                    self.dataList += currentArticleData
                    PAGE_NUM += 1
                }else{
                    self.dataList += currentArticleData
                    PAGE_NUM += 1
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.atableView.reloadData()
                })
            }
            else if jsonObject is NSArray{
                let deserializedArray = jsonObject as NSArray
                println("Deserialized JSON Array = \(deserializedArray)")
            }
            else {
                /* Some other object was returned. We don't know how to
                deal with this situation as the deserializer only
                returns dictionaries or arrays */
            }
        }
        else if error != nil{
            println("An error happened while deserializing the JSON data.")
        }
        
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:JiShuViewCell = tableView.dequeueReusableCellWithIdentifier("JiShuCell", forIndexPath: indexPath) as JiShuViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.setdata(self.dataList[indexPath.row] as Article)
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        var detailController = JiShuDetailController()
        detailController.article = self.dataList[indexPath.row]
        detailController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailController, animated: true)
    }

    
}
