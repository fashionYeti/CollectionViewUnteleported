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
@property (weak, nonatomic) IBOutlet FXBlurView *blurView;
@property (assign, nonatomic) CGRect movedRectStartPosition;
@property (strong, nonatomic) CollectionViewCell *movedCell;
@property (strong, nonatomic) UIView *toolbar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pathArray = [self fillPathArray];
    self.supplementaryViewLabels = [self fillSupplementaryViewArray];
    [self createToolbar];
    
    // just adding same elements, to perform 5x10 collectionView
    [self.pathArray addObjectsFromArray:self.pathArray];
    
    [self.collectionView registerClass:[SupplementaryView class] forSupplementaryViewOfKind:@"supplementaryViewKind" withReuseIdentifier:@"cellLabel"];
    
    CollectionViewCustomLayout *myLayout = [[CollectionViewCustomLayout alloc] init];
    self.collectionView.collectionViewLayout = myLayout;
    
    [myLayout setSectionInset:UIEdgeInsetsMake(20, 10, 20, 10)];
    [myLayout setMinimumLineSpacing:35];
    [myLayout invalidateLayout];
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
    
//    SupplementaryView *suppView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"cellLabel" forIndexPath:indexPath];
//    
//    UILabel *suppLabel = [[UILabel alloc] initWithFrame:suppView.frame];
//    suppLabel.text = self.supplementaryViewLabels[indexPath.row];
//    
//    //[suppView addSubview:suppLabel];
    UICollectionReusableView *suppView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"cellLabel" forIndexPath:indexPath];
    
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
    
    CollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if (!self.movedCell) {
        
        self.movedCell = cell;
        CGRect cellRect = cell.frame;
        self.movedRectStartPosition = cellRect;
        
        CGRect finishRect = cellRect;
        
        if (cellRect.size.width < 100) {
            finishRect.origin.x = 50;
        } else {
            finishRect.origin.x = 15;
        }
        
        [collectionView bringSubviewToFront:cell];
        
        [UIView animateWithDuration:0.5 animations:^{
            cell.frame = finishRect;
        }];

    } else {
        cell = self.movedCell;
        CGRect currentRect = cell.frame;
        [UIView animateWithDuration:0.5 animations:^{
            cell.frame = self.movedRectStartPosition;
        }];
        
        self.movedCell = nil;
    }
}

#pragma mark - UICollectionView layout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect screenRect = self.view.superview.frame;
    CGSize cellSize;
    
    if ([self.supplementaryViewLabels[indexPath.row] hasPrefix:@"B"] || [self.supplementaryViewLabels[indexPath.row] hasPrefix:@"C"] || [self.supplementaryViewLabels[indexPath.row] hasPrefix:@"E"]) {
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

#pragma mark - addittional methods

- (void)createToolbar {
    CGRect screenRect = self.collectionView.superview.bounds;
    UIView *toolbar = [[UIView alloc] initWithFrame:CGRectMake(screenRect.size.width, 0, screenRect.size.width / 2, 130)];
    self.toolbar = toolbar;
}

@end
