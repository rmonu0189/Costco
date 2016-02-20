//
//  CategoryVC.h
//  RenewalReminder
//
//  Created by Mac Book on 31/07/15.
//  Copyright (c) 2015 MonuRathor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryVCDelegate <NSObject>

- (void)selectedCategory:(NSDictionary *)category Index:(NSInteger)index;

@end

@interface CategoryVC : UIViewController
{
    __weak id<CategoryVCDelegate> delegate;
}
@property (nonatomic, weak) id<CategoryVCDelegate> delegate;
@end
