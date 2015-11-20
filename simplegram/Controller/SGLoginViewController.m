//
//  SGLoginViewController.m
//  simplegram
//
//  Created by Admin on 14.11.15.
//  Copyright © 2015 Manshilin. All rights reserved.
//

#import "SGLoginViewController.h"
#import "InstagramAPI.h"

@interface SGLoginViewController () <UIWebViewDelegate>

@end

@implementation SGLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginWebView.scrollView.bounces = NO;
    NSURL *authURL = [[InstagramAPI sharedInstance] autorizationURL];
    [self.loginWebView loadRequest:[NSURLRequest requestWithURL:authURL]];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [[InstagramAPI sharedInstance] receivedValidAccessTokenFromURL:request.URL];
    
    if([[InstagramAPI sharedInstance] isSessionValid])
       [self.navigationController popToRootViewControllerAnimated:NO];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
