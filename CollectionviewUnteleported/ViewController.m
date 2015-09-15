//
//  ViewController.m
//  CollectionviewUnteleported
//
//  Created by User4 on 14.09.15.
//  Copyright (c) 2015 Dmitry. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *pathArray;
@property (strong, nonatomic) NSMutableArray *supplementaryViewLabels;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pathArray = [self fillPathArray];
    self.supplementaryViewLabels = [self fillSupplementaryViewArray];
    
    // just adding same elements, to perform 5x10 collectionView
    [self.pathArray addObjectsFromArray:self.pathArray];
    
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

@end
