//
//  DownImageTool.m
//  com.haoxinren.manager
//
//  Created by aiteyuan on 15/1/7.
//  Copyright (c) 2015年 艾特远. All rights reserved.
//

#import "DownImageTool.h"


@implementation DownImageTool
+(void)downImageWithPath:(id)path imageview:(UIImageView *)imageview
{
    NSURL *picurl;
    if ([path isKindOfClass:[NSURL class]]) {
        picurl = path;
    }else if([path isKindOfClass:[NSString class]]){
         picurl = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }else{
        picurl = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    imageview.image = [UIImage imageNamed:@"default_showPic"];
    
        NSString *pathLastComponent = [picurl lastPathComponent];
    UIImage *myCachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:pathLastComponent];
    if (myCachedImage == nil) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadWithURL:picurl options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //NSLog(@"下载进度%d,%d",receivedSize,expectedSize);
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
            if (finished) {
                [[SDImageCache sharedImageCache] storeImage:image forKey:pathLastComponent];
                imageview.image = image;
            }
        }];
    }else{
        imageview.image =myCachedImage;
    }

}
@end
