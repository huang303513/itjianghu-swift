//
//  ShouYeViewController.swift
//  itjh
//
//  Created by 黄成都 on 15/2/2.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

import UIKit
//import Haneke

class ShouYeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var atableView: UITableView!
    let tableNib = UINib(nibName: "ShouYeViewCell", bundle: nil)
    let tableCellID = "ShouYeCell" as String
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
            theTableView.registerNib(tableNib, forCellReuseIdentifier: tableCellID)
            theTableView.dataSource = self
            theTableView.delegate = self
            theTableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            view.addSubview(theTableView)
        }
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        var hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.tabBarController?.view, animated: true)
        hud.labelText = "正在加载";
        hud.dimBackground = true;

        
        DataManager.requestArticle(PAGE_NUM, size: SHOW_NUM, articleMenuType: .HomeArticle) { (items:[Article]) -> () in
            MBProgressHUD.hideAllHUDsForView(self.tabBarController?.view, animated: true)
            //if(items)
            if(items.count < 1)
            {
                return;
            }
            self.dataList = items;
            self.atableView .reloadData()
        }
        
        setupRefresh()
    }
    
    //添加头刷新
    func setupRefresh(){
        self.atableView.addHeaderWithCallback({
            //self.dataSource.removeAll(keepCapacity: true)
            
            
            let delayInSeconds:Int64 =  1000000000  * 2
            
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                
                //创新刷新数据时,先清楚旧数据
                //self.dataSource.removeAll(keepCapacity: Bool())
                //self.loadData(self.PAGE_NUM,size: self.SHOW_NUM)
                DataManager.requestArticle(0, size: self.SHOW_NUM, articleMenuType: .HomeArticle) { (items:[Article]) -> () in
                    self.dataList.removeAll(keepCapacity: true)
                    
                    self.PAGE_NUM = 0
                    
                    self.dataList = items;
                    println("页码》》》 \(self.PAGE_NUM)")
                    self.atableView .reloadData()
                }
                //dispatch_async(dispatch_get_main_queue(), {self.atableView.reloadData()})
                //self.atableView.reloadData()
                
                self.atableView.headerEndRefreshing()
                //self.atableView.stopPullToRefresh()
            })
        })
        
        self.atableView.addFooterWithCallback({
            let delayInSeconds:Int64 = 1000000000 * 2
            var popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW,delayInSeconds)
            dispatch_after(popTime, dispatch_get_main_queue(), {
                
                println("页码》》》 \(self.PAGE_NUM)")
                //self.loadData(self.PAGE_NUM,size: self.SHOW_NUM)
                DataManager.requestArticle(self.PAGE_NUM + 1, size: self.SHOW_NUM, articleMenuType: .HomeArticle) { (items:[Article]) -> () in
                    self.PAGE_NUM += 1
                    self.dataList += items;
                    self.atableView .reloadData()
                }
                //self.atableView.reloadData()
                self.atableView.footerEndRefreshing()
            })
            
        })
        
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:ShouYeViewCell = tableView.dequeueReusableCellWithIdentifier(tableCellID, forIndexPath: indexPath) as ShouYeViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textView.text = self.dataList[indexPath.row].title
        let url:NSURL = NSURL(string: self.dataList[indexPath.row].img)!
        
       // cell.pictureView.setImageWithURL(url, placeholderImage: UIImage(named: "default_showPic"))
        
        DownImageTool.downImageWithPath(url, imageview: cell.pictureView)
        
//        cell.pictureView.hnk_setImageFromURL(url, placeholder: UIImage(named: "default_showPic"), format: nil, failure: { (error:NSError?) -> () in
//                println("加载图片失败")
//            }) { (theimage:UIImage) -> () in
//                cell.pictureView.image = theimage
//                println("加载图片成功")
//        }
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        var detailController = ShouYeDetailController(nibName: "ShouYeDetailController",  bundle: nil)
        detailController.article = self.dataList[indexPath.row]
        detailController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailController, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
