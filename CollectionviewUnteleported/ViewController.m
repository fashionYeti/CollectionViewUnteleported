//
//  ViewController.m
//  CollectionviewUnteleported
//
//  Created by User4 on 14.09.15.
//  Copyright (c) 2015 Dmitry. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"
#import "CollectionViewCustomLayout.h"
#import "SupplementaryView.h"
#import "FXBlurView.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *pathArray;
@property (strong, nonatomic) NSMutableArray *supplementaryViewLabels;
@property (strong, nonatomic) CollectionViewCell *movedCell;
@property (strong, nonatomic) UIView *toolbar;
@property (strong, nonatomic) FXBlurView *blurView;
@property (assign, nonatomic) CGRect movedRectStartPosition;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pathArray = [self fillPathArray];
    self.supplementaryViewLabels = [self fillSupplementaryViewArray];
    
    // just adding same elements, to perform 5x10 collectionView
    [self.pathArray addObjectsFromArray:self.pathArray];
    
    [self.collectionView registerClass:[SupplementaryView class] forSupplementaryViewOfKind:@"supplementaryViewKind" withReuseIdentifier:@"cellLabel"];
    
    
    CollectionViewCustomLayout *myLayout = [[CollectionViewCustomLayout alloc] init];
    self.collectionView.collectionViewLayout = myLayout;
    
    [myLayout setSectionInset:UIEdgeInsetsMake(20, 10, 20, 10)];
    [myLayout setMinimumLineSpacing:35];
    [myLayout invalidateLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [self prepareBlur];
    [self prepareToolbar];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.blurView addGestureRecognizer:singleFingerTap];
}

#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.pathArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageWithContentsOfFile:self.pathArray[indexPath.row]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    SupplementaryView *suppView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"cellLabel" forIndexPath:indexPath];
    
    CGRect suppRect = suppView.bounds;
    UILabel *label = [[UILabel alloc] initWithFrame:suppRect];
    [label setText:self.supplementaryViewLabels[indexPath.row]];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth;
    label.textAlignment = 1;
    [suppView addSubview:label];
    
    return suppView;
}

#pragma mark - UICollectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (!self.movedCell) {
        CollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        
        [collectionView bringSubviewToFront:cell];
        
        self.movedCell = cell;
        
        self.movedRectStartPosition = cell.frame;
        
        //CGRect cellRect = cell.frame;
        CGRect finishRect = cell.frame;
        CGRect toolbarRect = self.toolbar.frame;
        
        if (finishRect.size.width < 100) {
            finishRect.origin.x = 50;
        } else {
            finishRect.origin.x = 15;
        }
        
        toolbarRect.size.height = 90;
        toolbarRect.size.width = 500;
        toolbarRect.origin = CGPointMake(finishRect.origin.x + finishRect.size.width + 15, -150);
        
        self.toolbar.frame = toolbarRect;
        
        toolbarRect.origin = CGPointMake(finishRect.origin.x + finishRect.size.width + 15, CGRectGetMidY(finishRect) - toolbarRect.size.height / 2);
        
        self.blurView.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            cell.frame = finishRect;
            self.toolbar.frame = toolbarRect;
            self.blurView.alpha = 1;
        }];
    }
}

#pragma mark - UICollectionView layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect screenRect = self.view.superview.frame;
    CGSize cellSize;
    
    if ([self.supplementaryViewLabels[indexPath.row] hasPrefix:@"B"] ||
        [self.supplementaryViewLabels[indexPath.row] hasPrefix:@"C"] ||
        [self.supplementaryViewLabels[indexPath.row] hasPrefix:@"E"]) {
        cellSize = CGSizeMake((screenRect.size.width - 11*10) / 10, (screenRect.size.width - 11*10) / 10);
    } else {
        cellSize = CGSizeMake((screenRect.size.width - 6*20) / 5, (screenRect.size.width - 6*20) / 5);
    }
    
    return cellSize;
}


#pragma mark - datasource filling
- (NSMutableArray *)fillPathArray {
    NSMutableArray *imagePaths = [[NSMutableArray alloc] init];
    
    NSArray *imageTypes = [NSArray arrayWithObjects:@"jpg", @"png", nil];
    
    for (NSString *imageType in imageTypes) {
        NSArray *imagesOfParticularType = [[NSBundle mainBundle]pathsForResourcesOfType:imageType
                                                                            inDirectory:@"images"];
        if (imagesOfParticularType)
            [imagePaths addObjectsFromArray:imagesOfParticularType];
    }
    return imagePaths;
}

- (NSMutableArray *)fillSupplementaryViewArray {
    NSArray *letters = @[@"A", @"B", @"C", @"D", @"E"];
    NSMutableArray *supplementaryView = [NSMutableArray array];
    for (NSString *letter in letters) {
        int i = 1;
        while (i <= 10) {
            [supplementaryView addObject:[NSString stringWithFormat:@"%@%i", letter, i++]];
        }
    }
    return supplementaryView;
}

#pragma mark - gestureRecognizer methods
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CollectionViewCell *cell = self.movedCell;
    CGRect toolbarStart = self.toolbar.frame;
    
    toolbarStart.origin = CGPointMake(toolbarStart.origin.x, -150);
    
    [UIView animateWithDuration:0.5 animations:^{
        cell.frame = self.movedRectStartPosition;
        self.toolbar.frame = toolbarStart;
        self.blurView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.collectionView sendSubviewToBack:cell];
        self.blurView.hidden = YES;
    }];
    
    self.movedCell = nil;
}

#pragma mark - addittional methods

- (void)prepareToolbar {
    UIView *toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.toolbar = toolbar;
    [self.collectionView addSubview:self.toolbar];
    [self.collectionView bringSubviewToFront:self.toolbar];
    self.toolbar.backgroundColor = [UIColor redColor];
    self.toolbar.alpha = 0.5f;
}

- (void)prepareBlur {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    FXBlurView *blurView = [[FXBlurView alloc] initWithFrame:screenRect];
    blurView.blurEnabled = YES;
    blurView.backgroundColor = [UIColor whiteColor];
    blurView.tintColor = [UIColor clearColor];
    blurView.alpha = 0.0f;
    blurView.hidden = YES;
    //[self.collectionView addSubview:blurView];
    self.blurView = blurView;
    [self.collectionView insertSubview:blurView atIndex:0];
}

@end
