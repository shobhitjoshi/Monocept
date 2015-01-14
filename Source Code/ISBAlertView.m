//
//  ISBAlertView.m
//  IRCTC SMS Booking
//
//  Created by Nanda Ballabh on 14/08/13.
//  Copyright (c) 2013 Monocept. All rights reserved.
//

#import "ISBAlertView.h"

@interface ISBAlertView()
@property (copy, nonatomic) ISBCancelBlock  alertCancelBlock;
@property (copy, nonatomic) ISBOtherBlock  alertOtherBlock;

@end

@implementation ISBAlertView

@synthesize alertCancelBlock = _alertCancelBlock;
@synthesize alertOtherBlock = _alertOtherBlock;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles,nil];
    if(self) {
    }
    return self;
}

+(void) showAlertWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle cancelBlock:(ISBCancelBlock)cancelBlock otherButtontitle:(NSString*)otherButtontitle otherBlock:(ISBOtherBlock)otherBlock {
    
    ISBAlertView *alert = [[ISBAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtontitle, nil];
    [alert setAlertCancelBlock:cancelBlock];
    [alert setAlertOtherBlock:otherBlock];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{[alert show];}];
}

#pragma mark -
#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    //only supporting 1 or 2 button alerts.
    if (buttonIndex == 0) {
        
        if (self.alertCancelBlock)
            self.alertCancelBlock();
    }
    
    if (buttonIndex == 1) {
        
        if (self.alertOtherBlock)
            self.alertOtherBlock();
    }
}

@end