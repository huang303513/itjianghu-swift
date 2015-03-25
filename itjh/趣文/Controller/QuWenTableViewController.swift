//
//  QuWenTableViewController.swift
//  itjh
//
//  Created by 黄成都 on 15/2/3.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

import UIKit

class QuWenTableViewController: UITableViewController {

    let tableCellID = "quwenCell" as String
    //页码
    var PAGE_NUM  = 0
    //一页要现实的数量
    let SHOW_NUM = 12
    //文章列表数据
    var dataList:[Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        
        var hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.tabBarController?.view, animated: true)
        hud.labelText = "正在加载";
        hud.dimBackground = true;
        var url:String = GET_ARTICLE_Category + "/4/"
        var articleUrl = url + "\(PAGE_NUM)/\(SHOW_NUM)"
        
        DataManager.requestArticleWithURL(articleUrl, listerer: { (articles) -> () in
            //println(articles)
            if articles.count == 0{
                MBProgressHUD.hideAllHUDsForView(self.tabBarController?.view, animated: true)
                return
            }
            MBProgressHUD.hideAllHUDsForView(self.tabBarController?.view, animated: true)
            self.dataList += articles
            self.tableView.reloadData()
        })
        setupRefresh()
    }

    
    func setupRefresh(){
        self.tableView.addHeaderWithCallback({
            let delayInSeconds:Int64 =  1000000000  * 2
            
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                self.PAGE_NUM = 0
                var url:String = GET_ARTICLE_Category + "/4/"
                var articleUrl = url + "\(self.PAGE_NUM)/\(self.SHOW_NUM)"
                
                DataManager.requestArticleWithURL(articleUrl, listerer: { (articles) -> () in
                    //println(articles)
                    if articles.count == 0{
                        return
                    }
                    if articles.count > 0{
                        self.dataList .removeAll(keepCapacity: true)
                    }
                    self.dataList += articles
                    self.tableView.reloadData()
                })
                
                self.tableView.headerEndRefreshing()
            })
        })
        
        self.tableView.addFooterWithCallback({
            let delayInSeconds:Int64 = 1000000000 * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                
                var url:String = GET_ARTICLE_Category + "/4/"
                var articleUrl = url + "\(self.dataList.count)/\(self.SHOW_NUM)"
                
                DataManager.requestArticleWithURL(articleUrl, listerer: { (articles) -> () in
                    //println(articles)
                    if articles.count == 0{
                        return
                    }
                    self.dataList += articles
                    self.tableView.reloadData()
                })

                self.tableView.footerEndRefreshing()
            })
            
        })
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        //println(self.dataList.count)
        return self.dataList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("quwenCell", forIndexPath: indexPath) as QuWenViewCell
        cell.quwentextView.text = self.dataList[indexPath.row].title
        ImageLoader.sharedLoader.imageForUrl(self.dataList[indexPath.row].img, completionHandler: { (image, url) -> () in
            cell.quwenPictureView.image = image
        })
        
        return cell
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        var detailController = JiShuDetailController()
        detailController.article = self.dataList[indexPath.row]
        detailController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailController, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
