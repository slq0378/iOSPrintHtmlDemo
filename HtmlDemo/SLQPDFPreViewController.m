//
//  SLQPDFPreViewController
//  NanhaiPoliceM
//
//  Created by MrSong on 17/1/16.
//  Copyright © 2017年 slq. All rights reserved.
//  
#pragma mark - 布局
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define NavigationBarHeight 64

#import "SLQPDFPreViewController.h"
#import "SLQPrintPageRenderer.h"
#import <MessageUI/MessageUI.h>
#import <UIKit/UIPrinterPickerController.h>

@interface SLQPDFPreViewController ()<UIWebViewDelegate,MFMailComposeViewControllerDelegate>
/**<#注释#>*/
@property (nonatomic, strong) NSURLRequest *res;
/**<#注释#>*/
@property (nonatomic, strong) NSString *pdfFileName;
@end

@implementation SLQPDFPreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//
    self.title = @"预览";
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 0)];
    [self.view addSubview:web];
    _webView = web;
    web.delegate = self;
    web.backgroundColor = [UIColor greenColor];
    web.scalesPageToFit = YES;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"PDF" style:UIBarButtonItemStylePlain target:self action:@selector(selectRightAction:)];
    UIBarButtonItem *rightButton1 = [[UIBarButtonItem alloc] initWithTitle:@"邮件" style:UIBarButtonItemStylePlain target:self action:@selector(selectEmailAction:)];
    self.navigationItem.rightBarButtonItems = @[rightButton,rightButton1];
    // Do any additional setup after loading the view.
}

- (void)setUrl:(NSString *)url {
    _url = url;

    [self.webView loadHTMLString:url baseURL:nil];
}

- (void)selectRightAction:(UIBarButtonItem *)btnItem {
    NSLog(@"PDF");
    
//    [self exportPDF];
//    NSData *pdfData = [NSData dataWithContentsOfFile:self.pdfFileName];
//    [self.webView loadData:pdfData MIMEType:@"application/pdf" textEncodingName:@"application/pdf" baseURL:[NSURL URLWithString:self.pdfFileName]];
    [self printWebPage];
}
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
    
    // This code uses a custom UIPrintPageRenderer so that it can draw a header and footer.
    SLQPrintPageRenderer *myRenderer = [[SLQPrintPageRenderer alloc] init];
    // The APLPrintPageRenderer class provides a jobtitle that it will label each page with.
//    myRenderer.jobTitle = printInfo.jobName;
    // To draw the content of each page, a UIViewPrintFormatter is used.
    UIViewPrintFormatter *viewFormatter = [self.webView viewPrintFormatter];
    
    [myRenderer addPrintFormatter:viewFormatter startingAtPageAtIndex:0];
    // Set our custom renderer as the printPageRenderer for the print job.
    controller.printPageRenderer = myRenderer;
    
    [controller presentAnimated:YES completionHandler:completionHandler];  // iPhone
}

- (void)selectEmailAction:(UIBarButtonItem *)btnItem {
    NSLog(@"Email");
    [self exportPDF];
    [self displayComposerSheet];
    
}

- (void)exportPDF {
    //UIPrintFormatter
    // UIPrintFormatter是打印格式的抽象基类。该类能够对打印内容进行布局，打印系统会自动将与打印格式绑定的内容打印出来。
    SLQPrintPageRenderer *vc = [[SLQPrintPageRenderer alloc] init];
    UIMarkupTextPrintFormatter *printFor = [[UIMarkupTextPrintFormatter alloc] initWithMarkupText:self.url];
//    printFor.markupText = @"<html>\
//    <body>\
//    <h1>My First Heading</h1>\
//    <p>My first paragraph.</p>\
//    </body>\
//    </html>";
    [vc addPrintFormatter:printFor startingAtPageAtIndex:0];
    NSData *pdfData = [self drawPDFUsingPrintPageRenderer:vc];
    
 
    NSString *pdfFilename = [[self documentsDirectory] stringByAppendingString:@"/Invoice\(invoiceNumber).pdf"];
    [pdfData writeToFile:pdfFilename atomically:YES];
    self.pdfFileName = pdfFilename;
    NSLog(@"文件路径：%@",pdfFilename);
}

- (NSData *)drawPDFUsingPrintPageRenderer:(SLQPrintPageRenderer *)pageRenter {
    NSDictionary *textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:30] ,NSForegroundColorAttributeName:[UIColor blackColor],NSKernAttributeName:@10};
    NSMutableData *data = [[NSMutableData alloc] init];

    UIGraphicsBeginPDFContextToData(data, CGRectZero, nil);

    UIGraphicsBeginPDFPage();
    NSLog(@"%@",NSStringFromCGRect(UIGraphicsGetPDFContextBounds()));
    
    [pageRenter prepareForDrawingPages:NSMakeRange(0, 1)];
    [pageRenter drawPageAtIndex:0 inRect:UIGraphicsGetPDFContextBounds()];
//    [pageRenter drawContentForPageAtIndex:0 inRect:UIGraphicsGetPDFContextBounds()];
    [@"哈哈哈" drawAtPoint:CGPointMake(100, 100) withAttributes:textAttributes];
    UIGraphicsEndPDFContext();
    
    return data;
}


-(NSString*)documentsDirectory{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}
- (void)popBack:(UIGestureRecognizer *)swipe {
    [self back];
}

- (void)navigationClickLeft {
    [self back];
}

- (void)back {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 始发送请求（加载数据）时调用这个方法
- (void)webViewDidStartLoad:(UIWebView *)webView {
//    [SVProgressHUD showWithStatus:@"正在加载数据" maskType:SVProgressHUDMaskTypeBlack];
}
// 请求完毕（加载数据完毕）时调用这个方法
- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    [SVProgressHUD dismiss];
//    [SVProgressHUD showSuccessWithStatus:@"加载成功"];
}
// 请求错误时调用这个方法
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//    [SVProgressHUD showErrorWithStatus:@"数据错误，请稍后再试！"];
}
// UIWebView在发送请求之前，都会调用这个方法，如果返回NO，代表停止加载请求，返回YES，代表允许加载请求
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return YES;
}


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
    [picker addAttachmentData:myData mimeType:@"application/pdf"
                     fileName:@"HTMLDemo"];
    
    // 设置邮件发送内容
//    NSString *emailBody = @"IOS中的个人博客地址:http://www.cnblogs.com/xiaofeixiang";
//    [picker setMessageBody:emailBody isHTML:NO];
    
    //邮件发送的模态窗口
    [self presentModalViewController:picker animated:YES];
}

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
