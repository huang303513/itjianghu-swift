//
//  ShouYeDetailController.swift
//  itjh
//
//  Created by aiteyuan on 15/2/3.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

import UIKit

class ShouYeDetailController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    var article:Article!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "文章详情"
        
        
        var hud:MBProgressHUD = MBProgressHUD.showHUDAddedTo(self.tabBarController?.view, animated: true)
        hud.labelText = "正在加载";
        hud.dimBackground = true;
        let articleUrl = "\(GET_ARTICLE_ID)\(article.aid)"
        DataManager.requestData(".GET", url: articleUrl) { (thedata) -> () in
            if(thedata == nil){
                MBProgressHUD.hideAllHUDsForView(self.tabBarController?.view, animated: true)
                return
            }
            MBProgressHUD.hideAllHUDsForView(self.tabBarController?.view, animated: true)
            let data = JSON(thedata!)
            //println(data)
            //文章详情
            let articles = data["content"]
            
            //文章标题
            let atitle = articles["title"]
            //println(atitle)
            //发布时间
            var r = NSRange(location: 0,length: 11)
            
            let postDate:String = articles["date"].string!
            var postTime :NSString =   postDate as NSString
            
            postTime = postTime.substringWithRange(r)
            
            //发布时间
            
            //文章正文
            let articleContent = articles["content"]
            //作者
            let author = articles["author"]
            //显示文章
            let hr = "<hr class='rich_media_title'/>"
            let topHtml = "<html lang='zh-CN'><head><meta charset='utf-8'><meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'><title>\(atitle)</title><meta name='apple-itunes-app' content='app-id=639087967, app-argument=zhihudaily://story/4074215'><meta name='viewport' content='user-scalable=no, width=device-width'><link rel='stylesheet' href='http://203.195.152.45:8080/itjh/resource/zhihu.css'><script src='http://203.195.152.45:8080/itjh/resource/jquery.1.9.1.js'></script><base target='_blank'></head><body> <div class='main-wrap content-wrap'> <div class='content-inner'> <div class='question'> <h2 class='question-title' >\(atitle)</h2> <div class='answer'> <div class='meta' style='padding-bottom:10px;border-bottom:1px solid #e7e7eb '> <span class='bio'>\(postTime)</span> &nbsp; <span class='bio'>\(author)</span> </div> <div class='content'>"
            
            
            let footHtml = " </div> </div> </div>           </boby></script> </body> <script>$('img').attr('style', '');$('img').attr('width', '');$('img').attr('height', '');$('img').attr('class', '');$('img').attr('title', '');$('p').attr('style', '');</script></html>"
            
            self.webView.loadHTMLString("\(topHtml)\(articleContent)\(footHtml)", baseURL: nil)
        }
    }

    @IBAction func back(sender: UIButton) {
        println("点击返回")
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    @IBAction func share(sender: UIButton) {
       // println("点击了分享")
        
       // println("图片地址："+article.img)
        var url = NSURL(string: article.img)
        var saimg = UIImage(data: NSData(contentsOfURL: url!)!)
        
        UMSocialData.defaultData().extConfig.title = article.title
        
        UMSocialWechatHandler.setWXAppId("wxf17bc88ea6076de8", appSecret: "50f8da2f5a4756526b4a0b6574e2650a", url: shareUrl + "\(article.aid).html")
        
        //let snsArray = [UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToFacebook,UMShareToTwitter,UMShareToEmail]
        let snsArray = [UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline]
        
        UMSocialSnsService .presentSnsIconSheetView(self, appKey: "54238dc5fd98c501b5028d70", shareText:article.title+"  "+shareUrl + "\(article.aid).html", shareImage: saimg, shareToSnsNames: snsArray, delegate: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
