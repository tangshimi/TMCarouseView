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
 *  Image array
 */

@property (nonatomic, copy) NSArray<NSString *> *imagesArray;

/**
 *  The callback
 */
@property (nonatomic, copy) TMCarouseClickBlock clickBlock;

/**
 *  Default image
 */
@property (nonatomic, copy) NSString *defaultImage;

/**
 *  The default switch time is 4s
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
