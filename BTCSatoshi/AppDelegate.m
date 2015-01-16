//
//  AppDelegate.m
//  BTCSatoshi
//
//  Created by Windirt Young on 15/1/16.
//  Copyright (c) 2015年 Windirt Young. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (weak) IBOutlet NSTextField *cnyPriceLabel;
@property (weak) IBOutlet NSTextField *usdPriceLabel;
@property (weak) IBOutlet NSWindow *window;

@property (weak) IBOutlet NSTextField *satoshiTextField;
@property (weak) IBOutlet NSTextField *cnyTextField;

@end

@implementation AppDelegate {
    NSDictionary *cnyTicker;
    float cnyPrice;
    float satoshiPrice;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self fetchTicker];
    [self UpdateInterface];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)fetchTicker
{
    NSData *cnyTickerData = nil;
    cnyTickerData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://www.okcoin.cn/api/v1/ticker.do?symbol=btc_cny"]];
    
    if (cnyTickerData) {
        NSError *cnyTickerError;
        cnyTicker = [NSJSONSerialization JSONObjectWithData:cnyTickerData options:kNilOptions error:&cnyTickerError];
    }
    
}
- (IBAction)refreshPrice:(id)sender {
    [self fetchTicker];
    [self UpdateInterface];
}

- (void)UpdateInterface
{
    cnyPrice = [[[cnyTicker objectForKey:@"ticker"] objectForKey:@"last"] floatValue];
    self.cnyPriceLabel.stringValue = [NSString stringWithFormat:@"%.2f",cnyPrice];
}
- (IBAction)clearTextField:(id)sender {
    self.satoshiTextField.stringValue = @"";
    self.cnyTextField.stringValue = @"";
}



- (void)controlTextDidChange:(NSNotification *)obj
{

    
}



-(IBAction)objectDidEndEditing:(id)editor
{
    if (editor == self.cnyTextField) {
        float cny = [self.cnyTextField.stringValue floatValue];
        self.satoshiTextField.stringValue = [NSString stringWithFormat:@"%.f", cny*100000000/cnyPrice];
    }
    
    if (editor == self.satoshiTextField) {
        float satoshi = [self.satoshiTextField.stringValue floatValue];
        self.cnyTextField.stringValue = [NSString stringWithFormat:@"%f",cnyPrice/100000000*satoshi];
    }
 
}
@end
