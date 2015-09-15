//
//  CollectionViewCustomLayout.m
//  CollectionviewUnteleported
//
//  Created by Дмитрий Полишенко on 14.09.15.
//  Copyright (c) 2015 Dmitry. All rights reserved.
//

#import "CollectionViewCustomLayout.h"
#import "ViewController.h"

@implementation CollectionViewCustomLayout

- (CGSize)collectionViewContentSize {
    return [super collectionViewContentSize];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //first get a copy of all layout attributes that represent the cells. you will be modifying this collection.
    NSMutableArray *allAttributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    //go through each cell attribute
    for (UICollectionViewLayoutAttributes *attributes in [super layoutAttributesForElementsInRect:rect])
    {
        //add a title and a detail supp view for each cell attribute to your copy of all attributes
//        [allAttributes addObject:[self layoutAttributesForSupplementaryViewOfKind:SomeCellDetailsKind atIndexPath:[attributes indexPath]]];
        [allAttributes addObject:[self layoutAttributesForSupplementaryViewOfKind:@"supplementaryViewKind" atIndexPath:[attributes indexPath]]];
    }
    
    //return the updated attributes list along with the layout info for the supp views
    return allAttributes;
}

-(UICollectionViewLayoutAttributes*) layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //create a new layout attributes to represent this reusable view
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    
    if(attrs){
        
        //get the attributes for the related cell at this index path
        UICollectionViewLayoutAttributes *cellAttrs = [super layoutAttributesForItemAtIndexPath:indexPath];
        
        if([kind isEqual: @"supplementaryViewKind"]) {
            //position this reusable view relative to the cells frame
            CGRect frame = cellAttrs.frame;
            frame.origin.y += frame.size.height;
            frame.size.height = 20;
            attrs.frame = frame;
        }
        
//        if([kind  isEqual: @"supplementaryViewKind"]){
//            //position this reusable view relative to the cells frame
//            CGRect frame = cellAttrs.frame;
//            frame.origin.y -= 20; //+= frame.size.height; //( - frame.size.height;
//            frame.size.height = 20;
//            attrs.frame = frame;
//        }
    }
    
    return attrs;
}

@end
