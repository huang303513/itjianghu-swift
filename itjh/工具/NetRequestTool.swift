//
//  NetRequestTool.swift
//  itjh
//
//  Created by 黄成都 on 15/2/2.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

import Foundation
import Alamofire


let GET_ARTICLE = "http://m.itjh.com.cn:8080/mitjh/ArticleServer/queryArticleListByNew/"
var GET_ARTICLE_ID = "http://m.itjh.com.cn:8080/mitjh/ArticleServer/queryArticleById/"
var GET_ARTICLE_Category = "http://m.itjh.com.cn:8080/mitjh/ArticleServer/queryArticleListByCategory"
var SAVE_USER = "http://192.168.99.176:8080/mitjh/PeopleServer/saveUser"

enum ArticleTableControllerType : Int{
    case HomeArticle //首页
    case Technology //技术
    case Experience //经验
    case Interesting // 趣文
    case Information // 资讯
    case Programmer //程序员
}

class DataManager {
    class func requestArticle(offset: Int, size: Int, articleMenuType:ArticleTableControllerType,listerer:([Article]) -> ()){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var url:String = urlString(articleMenuType)
            var articleUrl = url + "\(offset)/\(size)"
            //请求 数据
            Alamofire.request(.GET, articleUrl, parameters: nil)
                .responseJSON { (request, response, data, error) in
//                    println(request)
//                    println(response)
//                    println(error)
                var tempArticleList:[Article] =  []
                if((error) != nil){
                    SCLAlertView().showWarning("温馨提示", subTitle:"您的网络在开小差,赶紧制服它,精彩的文章在等你.", closeButtonTitle:"去制服")
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        listerer(tempArticleList)
                    })
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    return
                }
                let jsonData = JSON(data!)
                let articleArray = jsonData["content"].arrayValue
                    //println(articleArray)
                for currentArticle in articleArray{
                    let article = Article()
                    article.aid = currentArticle["aid"].int!
                    article.title = currentArticle["title"].string!
                    article.date = currentArticle["date"].string!
                    article.img = currentArticle["img"].string!
                    article.author_id = currentArticle["author_id"].int!
                    article.author = currentArticle["author"].string!
                    tempArticleList .append(article)
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    listerer(tempArticleList)
                })
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        })
    }
    
    class func requestArticleWithURL(articleUrl: String, listerer:([Article]) -> ()){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            println("ddd")
            Alamofire.request(.GET, articleUrl, parameters: nil)
                .responseJSON { (request, response, data, error) in
                    //                    println(request)
                    //                    println(response)
                    //                    println(error)
                    var tempArticleList:[Article] =  []
                    if((error) != nil){
                        SCLAlertView().showWarning("温馨提示", subTitle:"您的网络在开小差,赶紧制服它,精彩的文章在等你.", closeButtonTitle:"去制服")
                        listerer(tempArticleList)
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        return
                    }
                    let jsonData = JSON(data!)
                    let articleArray = jsonData["content"].arrayValue
                    //println(articleArray)
                    for currentArticle in articleArray{
                        let article = Article()
                        article.aid = currentArticle["aid"].int!
                        article.title = currentArticle["title"].string!
                        article.date = currentArticle["date"].string!
                        article.img = currentArticle["img"].string!
                        article.author_id = currentArticle["author_id"].int!
                        article.author = currentArticle["author"].string!
                        tempArticleList .append(article)
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        listerer(tempArticleList)
                    })
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        })
        
    }

    
    class func requestData(requestMethod: String , url: String, listerer:(AnyObject?) -> () ){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        Alamofire.request(.GET, url, parameters: nil).responseJSON { (request, response, data, error) -> Void in
            //println(request)
            //println(response)
            //println(error)
            if((error) != nil){
                SCLAlertView().showWarning("温馨提示", subTitle:"您的网络在开小差,赶紧制服它,精彩的文章在等你.", closeButtonTitle:"去制服")
                listerer(nil)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                return
            }
            
            listerer(data)
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}


func urlString(articleMenuType:ArticleTableControllerType) -> String
{
    if articleMenuType == .HomeArticle //首页
    {
        return GET_ARTICLE
    }
    else if articleMenuType == .Technology //技术
    {
        return GET_ARTICLE_Category + "/2/"
    }
    else if articleMenuType == .Experience
    {
        return GET_ARTICLE_Category + "/3/"
    }else{
        return GET_ARTICLE
    }
    
}

