//
//  SLQPreViewController
//  NanhaiPoliceM
//
//  Created by MrSong on 17/1/16.
//  Copyright © 2017年 slq. All rights reserved.
//  
#pragma mark - 布局
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define NavigationBarHeight 64

#import "SLQPreViewController.h"
#import "SLQPrintPageRenderer.h"
#import <MessageUI/MessageUI.h>
#import <UIKit/UIPrinterPickerController.h>


@interface SLQPreViewController ()<UIWebViewDelegate,MFMailComposeViewControllerDelegate>
/**<#注释#>*/
@property (nonatomic, strong) NSURLRequest *res;
/**<#注释#>*/
@property (nonatomic, strong) NSString *pdfFileName;
@end

@implementation SLQPreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//
    self.title = @"预览";
    // A4 595 841
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 0)];
    [self.view addSubview:web];
    _webView = web;
    web.delegate = self;
    web.backgroundColor = [UIColor greenColor];
    web.scalesPageToFit = YES;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"打印" style:UIBarButtonItemStylePlain target:self action:@selector(selectRightAction:)];
    UIBarButtonItem *rightButton1 = [[UIBarButtonItem alloc] initWithTitle:@"邮件" style:UIBarButtonItemStylePlain target:self action:@selector(selectEmailAction:)];
    self.navigationItem.rightBarButtonItems = @[rightButton,rightButton1];
    // Do any additional setup after loading the view.
}

- (void)setUrl:(NSString *)url {
    _url = url;

    [self.webView loadHTMLString:url baseURL:nil];
}

- (void)selectRightAction:(UIBarButtonItem *)btnItem {
    NSLog(@"打印");
    [self printWebPage];
}

#pragma mark - 打印html
// 打印html
- (void)printWebPage
{
    UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
    if(!controller){
        NSLog(@"Couldn't get shared UIPrintInteractionController!");
        return;
    }
    
    UIPrintInteractionCompletionHandler completionHandler =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if(!completed && error){
            NSLog(@"FAILED! due to error in domain %@ with error code %ld", error.domain, (long)error.code);
        }
    };
    
    
    // 设置打印机的一些默认信息
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    // 输出类型
    printInfo.outputType = UIPrintInfoOutputGeneral;
    // 打印队列名称
    printInfo.jobName = @"HtmlDemo";
    // 是否单双面打印
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    // 设置默认打印信息
    controller.printInfo = printInfo;
    
    // 显示页码范围
    controller.showsPageRange = YES;
    
    // 预览设置
    SLQPrintPageRenderer *myRenderer = [[SLQPrintPageRenderer alloc] init];

    // To draw the content of each page, a UIViewPrintFormatter is used.
    // 生成html格式
    UIViewPrintFormatter *viewFormatter = [self.webView viewPrintFormatter];
    [myRenderer addPrintFormatter:viewFormatter startingAtPageAtIndex:0];
    // 渲染html
    controller.printPageRenderer = myRenderer;
    
    [controller presentAnimated:YES completionHandler:completionHandler];
}

- (void)selectEmailAction:(UIBarButtonItem *)btnItem {
    NSLog(@"Email");
//    [self exportHtml];
//    [self displayComposerSheet];
    
    NSString *allDataStr = @"记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对";
    // A4 width 595
    // 实际字符串宽度 595-40=555
//    NSString *addJS = @"<table cellpadding=\"0\" cellspacing=\"0\" class=\"note-edit-table\">\
//    <tbody><tr style=\"height:40px;\">\
//    <td style=\"\"><div class=\"note-edit-content\"><font id=\"addrDetail\">记得将基督教的基督教点击对记得将的基督教点击对</font>&nbsp;</div></td>\
//    </tr>\
//    <tr style=\"height:40px;\">\
//    <td style=\"\"><div class=\"note-edit-content\"><font id=\"addrDetail\">记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对记得将基督教的基督教点击对记得将的基督教点击对</font>&nbsp;</div></td>\
//    </tr>\
//    </tbody>\
//    </table>\";";
    NSString *addJS = @"<table cellpadding=\"0\" cellspacing=\"0\" class=\"note-edit-table\">\
    <tbody><tr style=\"height:40px;\">\
    <td style=\"width:100px;\"><div class=\"note-edit-tips\">户籍所在地</div></td>\
    <td style=\"\"><div class=\"note-edit-content\"><font id=\"homePlacr\"></font>&nbsp;</div></td>\
    </tr>\
    </tbody></table>";
    
    
    NSString *js = [NSString stringWithFormat:@"document.getElementById(\"startTimeYear\").innerHTML=\"2017\";\
                    document.getElementById(\"startTimeMonth\").innerHTML=\"5\";\
                    document.getElementById(\"startTimeDay\").innerHTML=\"6\";\
                    document.getElementById(\"startTimeHour\").innerHTML=\"5\";\
                    document.getElementById(\"startTimeMinute\").innerHTML=\"34\";\
                    document.getElementById(\"endTimeYear\").innerHTML=\"2017\";\
                    document.getElementById(\"endTimeMonth\").innerHTML=\"6\";\
                    document.getElementById(\"endTimeDay\").innerHTML=\"4\";\
                    document.getElementById(\"endTimeHour\").innerHTML=\"3\";\
                    document.getElementById(\"endTimeMinute\").innerHTML=\"4\";\
                    document.getElementById(\"askAddr\").innerHTML=\"广东省佛山市翠亨区\";\
                    document.getElementById(\"spyMan\").innerHTML=\"张三上\";\
                    document.getElementById(\"askMan\").innerHTML=\"赖柳\";\
                    document.getElementById(\"askAddr\").innerHTML=\"广东省佛山市翠亨区\";\
                    document.getElementById(\"spyUnit\").innerHTML=\"广东省佛山市南海区\";\
                    document.getElementById(\"createMan\").innerHTML=\"王章\";\
                    document.getElementById(\"createUnit\").innerHTML=\"广东省广州市\";\
                    document.getElementById(\"askedName\").innerHTML=\"小汪\";\
                    document.getElementById(\"askedSex\").innerHTML=\"男\";\
                    document.getElementById(\"askedAge\").innerHTML=\"34\";\
                    document.getElementById(\"askedBirthDate\").innerHTML=\"17890922\";\
                    document.getElementById(\"askedManId\").innerHTML=\"身份证 43839391919393948949\";\
                    document.getElementById(\"askedDeputy\").innerHTML=\"□是■否\";\
                    document.getElementById(\"addrDetail\").innerHTML=\"广东省佛山市翠亨区\";\
                    document.getElementById(\"contact\").innerHTML=\"1829292929299\";\
                    document.getElementById(\"homePlacr\").innerHTML=\"广东省佛山市\";\
                    document.getElementById(\"ZDTAStartMonth\").innerHTML=\"5\";\
                    document.getElementById(\"ZDTAStartDay\").innerHTML=\"3\";\
                    document.getElementById(\"ZDTAStartHour\").innerHTML=\"12\";\
                    document.getElementById(\"ZDTAStartMinute\").innerHTML=\"44\";\
                    document.getElementById(\"ZDTAEndMonth\").innerHTML=\"6\";\
                    document.getElementById(\"ZDTAEndDay\").innerHTML=\"7\";\
                    document.getElementById(\"ZDTAEndHour\").innerHTML=\"7\";\
                    document.getElementById(\"ZDTAEndMinute\").innerHTML=\"7\";\
                    document.getElementById(\"ZDTASign\").innerHTML=\"嫌疑犯\";\
                    "];
    [self.webView stringByEvaluatingJavaScriptFromString:js];

    

    NSString *js2 = [NSString stringWithFormat:@"document.getElementById(\"noteContent\").innerHTML+=\"%@\"",addJS];
    [self.webView stringByEvaluatingJavaScriptFromString:js2];
//    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"ZDTASign\").innerHTML=\"Hello World\";"];

}

- (void)exportHtml {
    
}

// 始发送请求（加载数据）时调用这个方法
- (void)webViewDidStartLoad:(UIWebView *)webView {
//    [SVProgressHUD showWithStatus:@"正在加载数据" maskType:SVProgressHUDMaskTypeBlack];
}
// 请求完毕（加载数据完毕）时调用这个方法
- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    [SVProgressHUD dismiss];
//    [SVProgressHUD showSuccessWithStatus:@"加载成功"];
    
//    NSString *js = @"alert('hello world');";
//    [webView stringByEvaluatingJavaScriptFromString:js];
}
// 请求错误时调用这个方法
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    [SVProgressHUD showErrorWithStatus:@"数据错误，请稍后再试！"];
}
// UIWebView在发送请求之前，都会调用这个方法，如果返回NO，代表停止加载请求，返回YES，代表允许加载请求
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}


- (void)setData {
    
}


#pragma mark - 设置邮件基本信息
// 设置邮件基本信息
-(void)displayComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    //设置主题
    [picker setSubject:@"HTMLDemo"];
    
    //设置收件人
    NSArray *toRecipients = [NSArray arrayWithObjects:@"xxxx@163.com",nil];
    
    [picker setToRecipients:toRecipients];
    
    //设置附件为pdf
    NSData *myData = [NSData dataWithContentsOfFile:self.pdfFileName];
    if (myData) {
        [picker addAttachmentData:myData mimeType:@"application/pdf" fileName:@"HTMLDemo"];
    }
    
    // 设置邮件发送内容
    NSString *emailBody = @"哈哈尽快哈就合法进口分哈萨克黄齑淡饭";
    [picker setMessageBody:emailBody isHTML:NO];
    
    //邮件发送的模态窗口
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - MFMailComposeViewControllerDelegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: //取消
            NSLog(@"MFMailComposeResultCancelled-取消");
            break;
        case MFMailComposeResultSaved: // 保存
            NSLog(@"MFMailComposeResultSaved-保存邮件");
            break;
        case MFMailComposeResultSent: // 发送
            NSLog(@"MFMailComposeResultSent-发送邮件");
            break;
        case MFMailComposeResultFailed: // 尝试保存或发送邮件失败
            NSLog(@"MFMailComposeResultFailed: %@...",[error localizedDescription]);
            break;
    }
    
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
