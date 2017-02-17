//
//  ViewController.m
//  HtmlDemo
//
//  Created by MrSong on 17/2/15.
//  Copyright © 2017年 song. All rights reserved.
//

#pragma mark - 布局
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define NavigationBarHeight 64
#import "ViewController.h"
#import "SLQPreViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a
    self.title = @"HtmlDemo";
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, NavigationBarHeight, ScreenWidth, 44)];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"生成文档" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(createDoc) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createDoc {
    NSLog(@"生成文档");
    
    SLQPreViewController *vc = [SLQPreViewController new];
    NSString *urlPath = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/invoice.html",[NSBundle mainBundle].bundlePath] encoding:NSUTF8StringEncoding error:nil];
//    urlPath = [NSString stringWithContentsOfFile:[NSString stringWithFormat:@"%@/invoiceTable.html",[NSBundle mainBundle].bundlePath] encoding:NSUTF8StringEncoding error:nil];
    vc.view.backgroundColor = [UIColor redColor];
    // 处理URL
    vc.url = [self handleUrl:urlPath];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (NSString *)getStrWithCount:(NSInteger )count {
    NSMutableString *str = [NSMutableString string];
    for (NSInteger i = 0;  i < count;  i ++) {
        [str appendString:@"_"];
    }
    return str;
}
- (NSString *)mergeString:(NSString *)sourceStr baseStr:(NSString *)baseStr {
    NSString *str = [NSString stringWithFormat:@"%@%@",baseStr,sourceStr];
//    NSString *line = @"____________________________________________________________";// 60个_刚好一行,每个7.0宽度
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:16]];
//    CGSize fontSize = [@"点击" sizeWithFont:[UIFont systemFontOfSize:16]];
    NSLog(@"_：%f",[@"_" sizeWithFont:[UIFont systemFontOfSize:16]].width);//7.0
    NSLog(@"哈：%f",[@"哈" sizeWithFont:[UIFont systemFontOfSize:16]].width);//17.0
//    NSLog(@"%@",NSStringFromCGSize(size));// 最大宽度411
    NSLog(@"拼接前%f",size.width);
    if (size.width < 420) {
        CGFloat width =  420 - size.width;
        NSLog(@"拼接%f个'_'",width/7.0);
        if(width/7.0 > 1) {
            
            sourceStr = [sourceStr stringByAppendingString:[self getStrWithCount:width/7.0]];
        }
    }
    NSLog(@"拼接后：%f",[[NSString stringWithFormat:@"%@%@",baseStr,sourceStr] sizeWithFont:[UIFont systemFontOfSize:16]].width);
    return sourceStr;
}

- (NSString *)handleUrl:(NSString *)urlStr {

    NSString *line = @"____________________________________________________________";
    CGSize size = [line sizeWithFont:[UIFont systemFontOfSize:16]];
    NSLog(@"%@",NSStringFromCGSize(size));// 最大宽度411
    
//    <u>#XWBLStartYear#</u>年
//    <u>#XWBLStartMonth#</u>月
//    <u>#XWBLStartDay#</u>日
//    <u>#XWBLStartHour#</u>时
//    <u>#XWBLStartMinute#</u>分至
//    
//    <u>#XWBLEndYear#</u>年
//    <u>#XWBLEndMonth#</u>月
//    <u>#XWBLEndDay#</u>日
//    <u>#XWBLEndHour#</u>时
//    <u>#XWBLEndMinute#</u>分
    
    NSString * urlPath = [urlStr stringByReplacingOccurrencesOfString:@"#XWBLStartYear#" withString:@"2017"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#XWBLStartMonth#" withString:@"1"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#XWBLStartDay#" withString:@"11"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#XWBLStartHour#" withString:@"11"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#XWBLStartMinute#" withString:@"22"];
    
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#XWBLEndYear#" withString:@"2017"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#XWBLEndMonth#" withString:@"2"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#XWBLEndDay#" withString:@"13"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#XWBLEndHour#" withString:@"13"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#XWBLEndMinute#" withString:@"23"];
//    地点<u>#XWBLAddress#</u>
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#XWBLAddress#" withString:[self mergeString:@"基督教的基督教的激动地表格将不显示边框。有时这很有用，但是大多数时候，我们希望显示边框。" baseStr:@"地点 " ]];

//    询问人<u>#XWR1#</u>、<u>#XWR2#</u>工作单位<u>#XWRWorkingUnit#</u>
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#XWR1#" withString:@"张三地点"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#XWR2#" withString:@"李四"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#XWRWorkingUnit#" withString:[self mergeString:@"北京石景山计算机公司" baseStr:@"询问人张三地点、李四工作单位"]];
//    记录人<u>#JLR#</u>工作单位<u>#JLRWorkingUnit#</u>
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#JLR#" withString:@"小松的"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#JLRWorkingUnit#" withString:[self mergeString:@"北京石景山计算机公司" baseStr:@"记录人小松的工作单位"]];
    
//    被询问人<u>#BXWR1#</u>性别<u>#BXWRSex#</u>年龄<u>#BXWRAge#</u>出生日期<u>#BXWRBirthday#</u>
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#BXWR1#" withString:@"小王"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#BXWRSex#" withString:@"男"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#BXWRAge#" withString:@"34"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#BXWRBirthday#" withString:[self mergeString:@"19920102" baseStr:@"被询问人小王性别男年龄34出生日期"]];
   
//    身份证件种类及号码<u>#ShenFenZheng#</u>
//    <input type="checkbox" name="checkbox1" checked="#RenDaDaiBiaoYes#"> 是
//    <input type="checkbox" name="checkbox2" checked="#RenDaDaiBiaoNo#"> 否人大代表
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#ShenFenZheng#" withString:[self mergeString:@"身份证 4219828283838893489" baseStr:@"身份证件种类及号码是否人大代表哈哈"]];
    // 复选框复制在这里
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#RenDaDaiBiaoYes#" withString:@"checked=\"true\""];
//        urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#RenDaDaiBiaoNo#" withString:@"checked=\"true\""];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#RenDaDaiBiaoNo#" withString:@""];
//    现住址<u>#XianZhuDiZhi#</u>
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#XianZhuDiZhi#" withString:[self mergeString:@"广东省佛山市南海区南桂东路36号" baseStr:@"现住址"]];
    
//    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#XianZhuDiZhi#" withString:@"_____________________________________________________"];
//    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#XianZhuDiZhi1#" withString:@"____________________________________________________________"];
//    联系方式<u>#LianXiFangShi#</u>
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#LianXiFangShi#" withString: [self mergeString:@"010-11102029" baseStr:@"联系方式"]];
 
    //    户籍所在地<u>#HuJiSuoZaiDi#</u>
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#HuJiSuoZaiDi#" withString:[self mergeString:@"广东省佛山市南海区规桂城街道公安局南海分局" baseStr:@"户籍所在地"]];
    
//    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#HuJiSuoZaiDi111#" withString:[self mergeString:line baseStr:@""]];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#HuJiSuoZaiDi111#" withString:@"如果不定义边框属性，表格将不显示边框。有时这很有用，但是大多数时"];
//    （口头传唤的被询问人于
//    <u>#KTCHStartMonth#</u>月
//    <u>#KTCHStartDay#</u>日
//    <u>#KTCHStartHour#</u>时
//    <u>#KTCHStartMinute#</u>分到达，
//    <u>#KTCHEndMonth#</u>月
//    <u>#KTCHEndDay#</u>日
//    <u>#KTCHEndHour#</u>时
//    <u>#KTCHEndMinute#</u>分离开，本人签名确认：
//    <u>#KTCHSign#</u>)
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#KTCHStartMonth#" withString:@"3"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#KTCHStartDay#" withString:@"5"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#KTCHStartHour#" withString:@"6"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#KTCHStartMinute#" withString:@"45"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#KTCHEndMonth#" withString:@"3"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#KTCHEndDay#" withString:@"5"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#KTCHEndHour#" withString:@"12"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#KTCHEndMinute#" withString:@"55"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#KTCHSign#" withString:@"____________"];
//    口头传唤/被扭送/自动投案的被询问人/询问人于
//    <u>#ZDTAStartMonth#</u>月
//    <u>#ZDTAStartDay#</u>日
//    <u>#ZDTAStartHour#</u>时
//    <u>#ZDTAStartMinute#</u>分到达，
//    <u>#ZDTAEndMonth#</u>月
//    <u>#ZDTAEndDay#</u>日
//    <u>#ZDTAEndHour#</u>时
//    <u>#ZDTAEndMinute#</u>分离开，本人签名确认：
//    <u>#ZDTASign#</u>)
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#ZDTAStartMonth#" withString:@"3"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#ZDTAStartDay#" withString:@"5"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#ZDTAStartHour#" withString:@"3"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#ZDTAStartMinute#" withString:@"34"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#ZDTAEndMonth#" withString:@"3"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#ZDTAEndDay#" withString:@"5"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#ZDTAEndHour#" withString:@"8"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#ZDTAEndMinute#" withString:@"34"];
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#ZDTASign#" withString:@"____________"];
    
    
//    <u>#OtherInfo#</u>
    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"#OtherInfo#" withString:[self mergeString:@"如果不定义边框属性，表格将不显示边框。有时这很有用，但是大多数时候，我们希望显示边框。对于创建PDF而言，无论现在的其他方案或者以后的新技巧，本文所提及的解决方案总会是标准、灵活和安全的之一。该方案惟一的缺点就是：我们需要编写那些HTML模版文件。不过对于我来说，这工作实在是物超所值。与花大量工作去手动绘制PDF相比，我坚信替换模版文件中的“占位符”的做法更加可取。除此之外，真实情况中的PDF文档绘制都是非常标准的，只需要对Demo中的代码进行部分调整就能实现复用了。不管怎样，我都希望本文中的方法能够真正的帮到你。对于创建PDF而言，无论现在的其他方案或者以后的新技巧，本文所提及的解决方案总会是标准、灵活和安全的之一。该方案惟一的缺点就是：我们需要编写那些HTML模版文件。不过对于我来说，这工作实在是物超所值。与花大量工作去手动绘制PDF相比，我坚信替换模版文件中的“占位符”的做法更加可取。除此之外，真实情况中的PDF文档绘制都是非常标准的，只需要对Demo中的代码进行部分调整就能实现复用了。不管怎样，我都希望本文中的方法能够真正的帮到你。对于创建PDF而言，无论现在的其他方案或者以后的新技巧，本文所提及的解决方案总会是标准、灵活和安全的之一。该方案惟一的缺点就是：我们需要编写那些HTML模版文件。不过对于我来说，这工作实在是物超所值。与花大量工作去手动绘制PDF相比，我坚信替换模版文件中的“占位符”的做法更加可取。除此之外，真实情况动绘制PDF相比，我坚信替换模版文件中的“占位符”的做法更加可取。除此之外，真实情况中的PDF文档绘制都是非常标准的，只需要对Demo中的代码进行部分调整就能实现复用了。不管怎样，我都希望本文中的方法能够真正的帮到你。对于创建PDF而言，无论现在的其他方案或者以后的新技巧，本文所提及的解决方案总会是标准、灵活和安全的之一。该方案惟一的缺点就是：我们需要编写那些HTML模版文件。不过对于我来说，这工作实在是物超所值。与花大量工作去手动绘制PDF相比，我坚信替换模版文件中的“占位符”的做法更加可取。除此之外，真实情况中的PDF文档绘制都是非常标准的，只需要对Demo中的代码进行部分调整就能实现复用了。不管怎样，我都希望本文中的方法能够真正的帮到你。对于创建PDF而言，无论现在的其他方案或者以后的新技巧，本文所提及的解决方案总会是标准、灵活和安全的之一。该方案惟一的缺点就是：我们需要编写那些HTML模版文件。不过对于我来说，这工作实在是物超所值。与花大量工作去手动绘制PDF相比，我坚信替换模版文件中的“占位符”的做法更加可取。除此之外，真实情况中的PDF文档绘制都是非常标准的，只需要对Demo中的代码进行部分调整就能实现复用了。不管怎样，我都希望本文中的方法能够真正的帮到你。对于创建PDF而言，无论现在的其他方案或者以后的新技巧，本文所提及的解决方案总会是标准、灵活和安全的之一。该方案惟一的缺点就是：我们需要编写那些HTML模版文件。不过对于我来说，这工作实在是物超所值。与花大量工作去手动绘制PDF相比，我坚信替换模版文件中的“占位符”的做法更加可取。除此之外，真实情况中的PDF文档绘制都是非常标准的，只需要对Demo中的代码进行部分调整就能实现复用了。不管怎样，我都希望本文中的方法能够真正的帮到你。对于创建PDF而言，无论现在的其他方案或者以后的新技巧，本文所提及的解决方案总会是标准、灵活和安全的之一。该方案惟一的缺点就是：我们需要编写那些HTML模版文件。不过对于我来说，这工作实在是物超所值。与花大量工作去手动绘制PDF相比，我坚信替换模版文件中的“占位符”的做法更加可取。除此之外，真实情况中的PDF文档绘制都是非常标准的，只需要对Demo中的代码进行部分调整就能实现复用了。不管怎样，我都希望本文中的方法能够真正的帮到你。" baseStr:@""]];
    ;
    return urlPath;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
