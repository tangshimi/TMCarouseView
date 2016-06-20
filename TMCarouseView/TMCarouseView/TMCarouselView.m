//
//  TMCarouselView.m
//
//
//  Created by tangshimi on 6/17/16.
//  Copyright © 2016 medtree. All rights reserved.
//

#import "TMCarouselView.h"
#import "UIImageView+WebCache.h"

static NSString *const collectionViewCellReuesID = @"collectionViewCellReuesID";
static NSInteger kTimeInterval = 4;

@interface TMCarouselView () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *showImagesArray;

@end

@implementation TMCarouselView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _showImagesArray = [[NSMutableArray alloc] init];
        
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
        
        self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = @{ @"collectionView" : self.collectionView, @"pageControl" :  self.pageControl };
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[collectionView]-0-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[collectionView]-0-|" options:0 metrics:nil views:views]];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[pageControl]-|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[pageControl]-4-|" options:0 metrics:nil views:views]];
    }
    return self;
}

#pragma mark -
#pragma mark - UICollectionViewDelegate / UICollectionViewDataSource -

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.showImagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TMCarouselViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellReuesID
                                                                                       forIndexPath:indexPath];
    cell.defaultImage = self.defaultImage;
    [cell setImageURL:self.showImagesArray[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.clickBlock) {
        return;
    }
    
    self.clickBlock(indexPath.row - 1);
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self showNext];
}

#pragma mark -
#pragma mark - UIScrollViewDelegate -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
     [self changePageControlCurrentIndex];
    
    if (scrollView.contentOffset.x >= CGRectGetWidth(self.frame) * (self.showImagesArray.count - 1)) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:NO];
        
    }
    
    if (scrollView.contentOffset.x <= 0) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.showImagesArray.count - 2 inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:NO];
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self showNext];
}

#pragma mark -
#pragma mark - helper -

- (void)showNext
{
    if (self.showImagesArray.count <= 1) {
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [self performSelector:@selector(show)
               withObject:nil
               afterDelay:self.switchingTime ?: kTimeInterval
                  inModes:@[ NSDefaultRunLoopMode ]];
}

- (void)show
{
    NSInteger currentIndex = [[self.collectionView indexPathsForVisibleItems] firstObject].row;
    NSInteger nextIndex;
    
    BOOL isAnimated = YES;
    if (currentIndex ==  self.showImagesArray.count - 1) {
        isAnimated = NO;
    }
    
    nextIndex = currentIndex + 1;
    
    if (currentIndex == self.showImagesArray.count - 1) {
        nextIndex = 1;
    }
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextIndex inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:YES];
    
    [self showNext];
}

- (void)changePageControlCurrentIndex
{
    NSInteger currentPage = self.collectionView.contentOffset.x / CGRectGetWidth(self.frame);
    
    if (currentPage == 0) {
        self.pageControl.currentPage = self.showImagesArray.count;
    } else if (currentPage == self.showImagesArray.count + 1) {
        self.pageControl.currentPage = 0;
    } else {
        self.pageControl.currentPage = currentPage - 1;
    }
}

#pragma mark -
#pragma mark - setter and getter -

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = ({
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            flowLayout.minimumInteritemSpacing = 0.0;
            flowLayout.minimumLineSpacing = 0.0;
            flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            
            UICollectionView *view = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
            view.showsHorizontalScrollIndicator = NO;
            view.backgroundColor = [UIColor whiteColor];
            view.pagingEnabled = YES;
            [view registerClass:[TMCarouselViewCollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellReuesID];
            view.delegate = self;
            view.dataSource = self;
            view;
        });
    }
    return _collectionView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = ({
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            pageControl.pageIndicatorTintColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
            pageControl;
        });
    }
    return _pageControl;
}

- (void)setImagesArray:(NSArray<NSString *> *)imagesArray
{
    _imagesArray = [imagesArray copy];
    
    if (imagesArray.count == 0) {
        return;
    }
    
    [self.showImagesArray removeAllObjects];
    
    [self.showImagesArray addObjectsFromArray:imagesArray];
    if (imagesArray.count > 1) {
        [self.showImagesArray insertObject:imagesArray.lastObject atIndex:0];
        [self.showImagesArray addObject:imagesArray.firstObject];
    }
    
    [self.collectionView reloadData];
    
    if (imagesArray.count > 1) {
        self.pageControl.numberOfPages = imagesArray.count;
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0 ]
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:NO];
        
        [self showNext];
    }
}

@end

/**
 *  TMCarouselViewCollectionViewCell
 */

@interface TMCarouselViewCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation TMCarouselViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *views = @{ @"imageView" : self.imageView };
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[imageView]-0-|" options:0 metrics:nil views:views]];
    }
    return self;
}

#pragma mark -
#pragma mark - setter and getter -

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView =  ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView;
        });
    }
    return _imageView;
}

-(void)setImageURL:(NSString *)imageURL{
    _imageURL = [imageURL copy];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL]
                      placeholderImage:[UIImage imageNamed:self.defaultImage]];
}


@end
