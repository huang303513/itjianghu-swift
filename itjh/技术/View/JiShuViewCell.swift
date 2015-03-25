//
//  JiShuViewCell.swift
//  itjh
//
//  Created by aiteyuan on 15/2/3.
//  Copyright (c) 2015年 黄成都. All rights reserved.
//

import UIKit
import Foundation

class JiShuViewCell: UITableViewCell, NSURLSessionDelegate {
    var textView: UITextView?
    var pictureView: UIImageView?
    var session: NSURLSession!
    
    /**
    用苹果原生态接口实现图片异地加载和本地缓存使用
    
    :param: article nil
    */
    func setdata(article: Article){
       
        self.textView!.text = article.title
        
        dispatch_async(GlobalUserInitiatedQueue, { () -> Void in
            let componentsOfUrl = article.img.componentsSeparatedByString("/")
            let fileNameFromUrl = componentsOfUrl[componentsOfUrl.count - 1] as String
            let destinationPath = NSTemporaryDirectory() + fileNameFromUrl
            let localpicdata = NSData(contentsOfFile: destinationPath)
            if localpicdata != nil && localpicdata?.length > 0{
                dispatch_async(GlobalMainQueue, { () -> Void in
                    println()
                    self.pictureView?.image = UIImage(data: localpicdata!)
                })
            }else{
                self.pictureView?.image = UIImage(named: "default_showPic")
                let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
                configuration.timeoutIntervalForRequest = 30.0
                self.session = NSURLSession(configuration: configuration,
                    delegate: nil,
                    delegateQueue: nil)
                
                let url = NSURL(string: article.img)
                let task = self.session.dataTaskWithURL(url!,
                    completionHandler: {[weak self] (data: NSData!,
                        response: NSURLResponse!,
                        error: NSError!) in
                        
                        dispatch_async(GlobalMainQueue, { () -> Void in
                            println()
                            self!.pictureView?.image = UIImage(data: data)
                        })
                        self!.session.finishTasksAndInvalidate()
                        
                        //NSLog("------%@-------%@", componentsOfUrl, fileNameFromUrl)
                        var error:NSError?
                        let written = data.writeToFile(destinationPath, atomically: true)
                        //println("destinationPath" + destinationPath)
                        if written{
                            //println("Successfully stored the file at path \(destinationPath)")
                        } else {
                            if let errorValue = error{
                                println("An error occurred: \(errorValue)")
                            }
                        }
                })
                task.resume()
            }

            
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        
        self.textView = UITextView(frame: CGRectMake(5, 10, screenWidth - 80, jishuCellHeight - 20))
        self.textView?.userInteractionEnabled = false
        self.textView?.backgroundColor = UIColor.clearColor()
        textView?.font = UIFont.systemFontOfSize(16)
        self.contentView.addSubview(self.textView!)
        
        self.pictureView = UIImageView(frame: CGRectMake(screenWidth - 80, 10, 60, jishuCellHeight - 20))
        self.pictureView?.contentMode = .ScaleToFill
        self.contentView.addSubview(self.pictureView!)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
