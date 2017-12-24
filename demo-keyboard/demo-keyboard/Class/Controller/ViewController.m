//
//  ViewController.m
//  demo-keyboard
//
//  Created by WangDongya on 2017/12/23.
//  Copyright © 2017年 example. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *normalKeyboard;
@property (weak, nonatomic) IBOutlet UITextField *numberKeyboard;
@property (weak, nonatomic) IBOutlet UITextField *emailKeyboard;
@property (weak, nonatomic) IBOutlet UITextField *customKeyboard;
@property (weak, nonatomic) IBOutlet UITextField *bottomKeyboard;

@end

@implementation ViewController

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //当用户按下return键或者按回车键，keyboard消失
    [textField resignFirstResponder];
    switch (textField.returnKeyType) {
        case UIReturnKeySend:
            NSLog(@"UIReturnKeySend");
            break;
        case UIReturnKeySearch:
            NSLog(@"UIReturnKeySearch");
            break;
        case UIReturnKeyDone:
            NSLog(@"UIReturnKeyDone");
            break;
            
        default:
            break;
    }
    
    return YES;
}

////开始编辑输入框的时候，软键盘出现，执行此事件
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    CGRect frame = textField.frame;
//    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0); //键盘高度216
//
//    NSTimeInterval animationDuration = 0.30f;
//    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//
//    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
//    if(offset > 0)
//        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
//
//    [UIView commitAnimations];
//}
//
////输入框编辑完成以后，将视图恢复到原始状态
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//}


#pragma mark - 方法

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 监听正常按钮事件
    [self setupNormalKeyboard];
    
    // 在键盘上添加一个自定义按钮
    [self setupCustomKeyboard];
}

- (void)setupNormalKeyboard
{
    // 设置代理
    self.normalKeyboard.delegate = self;
    
    // 监听发送事件
    //    UIReturnKeyDefault,
    //    UIReturnKeyGo,
    //    UIReturnKeyGoogle,
    //    UIReturnKeyJoin,
    //    UIReturnKeyNext,
    //    UIReturnKeyRoute,
    //    UIReturnKeySearch,
    //    UIReturnKeySend,
    //    UIReturnKeyYahoo,
    //    UIReturnKeyDone,
    //    UIReturnKeyEmergencyCall,
    //    UIReturnKeyContinue NS_ENUM_AVAILABLE_IOS(9_0),
    self.normalKeyboard.returnKeyType = UIReturnKeySend;
    
    
    //
}


- (void)setupNote
{
    // 添加广播监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)keyboardFrameChange:(NSNotification *)notification
{
    // NSLog(@"%s", __func__);
    // 修改约束
    // CGFloat keyboardY = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat keyboardH = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGRect frame = self.view.frame;
    frame.size.height = [UIScreen mainScreen].bounds.size.height - keyboardH;
    
    // 执行动画
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)setupCustomKeyboard
{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleBlackTranslucent];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 5, 50, 25);
    [btn addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"完成"forState:UIControlStateNormal];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    [self.customKeyboard setInputAccessoryView:topView];
}

-(void)dealloc
{
    // 移除所有广播监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)dismissKeyBoard
{
    [self.customKeyboard resignFirstResponder];
}


@end
