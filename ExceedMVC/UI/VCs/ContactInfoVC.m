//
//  ContactInfoVC.m
//  ExceedMVC
//
//  Created by yangjh on 13-6-6.
//  Copyright (c) 2013年 yjh4866. All rights reserved.
//

#import "ContactInfoVC.h"
#import "CoreEngine.h"
#import "UserInfo.h"

@interface ContactInfoVC () {
    
    UIImageView *_imageViewAvatar;
    
    UserInfo *_userInfo;
}

@end

@implementation ContactInfoVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"详细资料";
        _userInfo = [[UserInfo alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    UIBarButtonItem *updateItem = [[UIBarButtonItem alloc] initWithTitle:@"更新" style:UIBarButtonItemStylePlain target:self action:@selector(clickUpdate:)];
    self.navigationItem.rightBarButtonItem = updateItem;
    [updateItem release];
    
    if (nil == _imageViewAvatar) {
        _imageViewAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(40.0f, 40.0f, 100.0f, 100.0f)];
        _imageViewAvatar.backgroundColor = [UIColor lightGrayColor];
    }
    [self.view addSubview:_imageViewAvatar];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
    [defaultCenter addObserver:self selector:@selector(notifUserInfoSuccess:)
                          name:NetUserInfoSuccess object:nil];
    
    if ([self.dataSource respondsToSelector:@selector(contactInfoVC:loadUserInfo:)]) {
        [self.dataSource contactInfoVC:self loadUserInfo:_userInfo];
        self.title = _userInfo.userName;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //
    [_imageViewAvatar release];
    //
    [_userInfo release];
    
    [super dealloc];
}


#pragma mark - Notification

- (void)notifUserInfoSuccess:(NSNotification *)notif
{
    UInt64 userID = [[notif.userInfo objectForKey:@"userid"] longLongValue];
    NSString *userName = [notif.userInfo objectForKey:@"username"];
    //
    if (self.userID == userID) {
        self.title = userName;
        // 显示头像
        _userInfo.avatarUrl = [notif.userInfo objectForKey:@"avatar"];
        [_imageViewAvatar loadImageFromCachePath:nil orPicUrl:_userInfo.avatarUrl];
    }
}


#pragma mark - ClickEvent

- (void)clickUpdate:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(contactInfoVCGetUserInfo:)]) {
        [self.delegate contactInfoVCGetUserInfo:self];
    }
}

@end
