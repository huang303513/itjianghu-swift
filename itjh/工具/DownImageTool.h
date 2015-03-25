//
//  DownImageTool.h
//  com.haoxinren.manager
//
//  Created by aiteyuan on 15/1/7.
//  Copyright (c) 2015年 艾特远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+WebCache.h"

@interface DownImageTool : NSObject
+(void)downImageWithPath:(id)path imageview:(UIImageView *)imageview;
@end
