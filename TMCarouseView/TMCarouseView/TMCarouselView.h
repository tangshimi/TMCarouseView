//
//  TMCarouselView.h
//  
//
//  Created by tangshimi on 6/17/16.
//  Copyright © 2016 medtree. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TMCarouseClickBlock)(NSInteger);

@interface TMCarouselView : UIView

/**
 *  图片地址
 */

@property (nonatomic, copy) NSArray<NSString *> *imagesArray;

/**
 *  点击的回调
 */

@property (nonatomic, copy) TMCarouseClickBlock clickBlock;

/**
 *  默认显示图片(本地资源)
 */

@property (nonatomic, copy) NSString *defaultImage;

/**
 *  自动切换图片的时间,默认4s
 */

@property (nonatomic, assign) NSTimeInterval switchingTime;

@end

/**
 *  TMCarouselViewCollectionViewCell
 */

@interface TMCarouselViewCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *imageURL;
@property (nonatomic, copy) NSString *defaultImage;

@end
