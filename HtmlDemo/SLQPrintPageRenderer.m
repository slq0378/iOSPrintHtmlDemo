//
//  PrintViewController.m
//  HtmlDemo
//
//  Created by MrSong on 17/2/15.
//  Copyright © 2017年 song. All rights reserved.
//


#define SIMPLE_LAYOUT 1

// 页眉页脚文本高度
#define HEADER_FOOTER_TEXT_HEIGHT     10

// 页眉页脚文字左边距
#define HEADER_LEFT_TEXT_INSET	      20

// 填充区域
#define HEADER_FOOTER_MARGIN_PADDING  5

// 页眉页脚文字右边距
#define FOOTER_RIGHT_TEXT_INSET	      20

// 页眉页脚距离文档的最小高度
#define MIN_HEADER_FOOTER_DISTANCE_FROM_CONTENT	10

// 最小边距
#define MIN_MARGIN 36



#import "SLQPrintPageRenderer.h"

@implementation SLQPrintPageRenderer
{
    NSRange pageRange;
}


- (instancetype)init {
    if (self = [super init]) {
        CGRect rect = CGRectMake(0, 0, self.A4PageWidth, self.A4PageHeight);
        // 纸张大小
        [self setValue:[NSValue valueWithCGRect:rect] forKey:@"paperRect"];
        
        // 打印区域，如果需要间距就这样CGRectInset(pageFrame, 10.0, 10.0))
//        [self setValue:[NSValue valueWithCGRect:rect] forKey:@"printableRect"];
        [self setValue:[NSValue valueWithCGRect:CGRectInset(rect, 10, 10)] forKey:@"printableRect"];
        // 页眉页脚
        self.headerHeight = 50.0;
        self.footerHeight = 50.0;
    }
    return self;
}


/*
 Compute an edge inset to produce the minimum margin based on the imageable area margin of the edge.
 */
static inline CGFloat EdgeInset(CGFloat imageableAreaMargin)
{
    /*
     Because the offsets specified to a print formatter are relative to printRect and we want our edges to be at least MIN_MARGIN from the edge of the sheet of paper, here we compute the necessary offset to achieve our margin. If the imageable area margin is larger than our MIN_MARGIN, we return an offset of zero which means that the imageable area margin will be used.
     */
    CGFloat val = MIN_MARGIN - imageableAreaMargin;
    return val > 0 ? val : 0;
}


/*
 Compute a height for the header or footer, based on the margin for the edge in question and the height of the text being drawn.
 */
static CGFloat HeaderFooterHeight(CGFloat imageableAreaMargin, CGFloat textHeight)
{
    /*
     Make the header and footer height provide for a minimum margin of MIN_MARGIN. We want the content to appear at least MIN_HEADER_FOOTER_DISTANCE_FROM_CONTENT from the header/footer text. If that requires a margin > MIN_MARGIN then we'll use that. Remember, the header/footer height returned needs to be relative to the edge of the imageable area.
     */
    CGFloat headerFooterHeight = imageableAreaMargin + textHeight +
    MIN_HEADER_FOOTER_DISTANCE_FROM_CONTENT + HEADER_FOOTER_MARGIN_PADDING;
    if(headerFooterHeight < MIN_MARGIN)
        headerFooterHeight = MIN_MARGIN - imageableAreaMargin;
    else {
        headerFooterHeight -= imageableAreaMargin;
    }
    
    return headerFooterHeight;
}

/*
 Override numberOfPages so we can compute the values for our UIPrintFormatter based on the paper used for the print job. When this is called, self.paperRect and self.printableRect reflect the paper size and imageable area of the destination paper.
 重写改方法，计算页数
 */
- (NSInteger)numberOfPages
{
    // We only have one formatter so obtain it so we can set its paramters.
    UIPrintFormatter *myFormatter = (UIPrintFormatter *)[self.printFormatters objectAtIndex:0];
    
    /*
     Compute insets so that margins are 1/2 inch from edge of sheet, or at the edge of the imageable area if it is larger than that. The EdgeInset function takes a margin for the edge being calculated.
     */
    CGFloat leftInset = EdgeInset(self.printableRect.origin.x);
    CGFloat rightInset = EdgeInset(self.paperRect.size.width - CGRectGetMaxX(self.printableRect));
    
    // Top inset is only used if we want a different inset for the first page and we don't.
    // The bottom inset is never used by a viewFormatter.
    myFormatter.contentInsets = UIEdgeInsetsMake(0, leftInset, 0, rightInset);
    
    // Now compute what we want for the header size and footer size.
    // These determine the size and placement of the content height.
    
    // First compute the title height.
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:HEADER_FOOTER_TEXT_HEIGHT];
    // We'll use the same title height for the header and footer.
    // This is the minimum height the footer can be.
    CGFloat titleHeight = [@"询问笔录" sizeWithFont:font].height;
    
    /*
     We want to calculate these heights so that the content top and bottom edges are a minimum distance from the edge of the sheet and are inset at least MIN_HEADER_FOOTER_DISTANCE_FROM_CONTENT from the header and footer.
     */
    self.headerHeight = HeaderFooterHeight(CGRectGetMinY(self.printableRect), titleHeight);
    self.footerHeight = HeaderFooterHeight(self.paperRect.size.height - CGRectGetMaxY(self.printableRect), titleHeight);
    
    // Just to be sure, never allow the content to go past our minimum margins for the content area.
    myFormatter.maximumContentWidth = self.paperRect.size.width - 2*MIN_MARGIN;
    myFormatter.maximumContentHeight = self.paperRect.size.height - 2*MIN_MARGIN;
    
    
    /*
     Let the superclass calculate the total number of pages. Since this UIPrintPageRenderer only uses a UIPrintFormatter, the superclass knows the number of pages based on the formatter metrics and the paper/printable rects.
     
     Note that since this code only uses a single print formatter we could just as easily use myFormatter.pageCount to obtain the total number of pages. But it would be more complex than that if we had multiple printformatters for our job so we're using a more general approach here for illustration and it is correct for 1 or more formatters.
     */
    return [super numberOfPages];
}


/*
 Our pages don't have any intrinsic notion of page number; our footer will number the pages so that users know the order. So for us, we will always render the first page printed as page 1, even if the range is n-m. So we track which page in the range is the first index as well as the total length of our range.
 */
- (void)prepareForDrawingPages:(NSRange)range
{
    pageRange = range;
    [super prepareForDrawingPages:range];
}

// 绘制页眉
//- (void)drawHeaderForPageAtIndex:(NSInteger)pageIndex inRect:(CGRect)headerRect {
//    // Specify the header text.
//    NSString *headerText = @"第1次";
//    
//    // Set the desired font.
//    UIFont *font = [UIFont systemFontOfSize:15];
//    // Specify some text attributes we want to apply to the header text.
//    NSDictionary *textAttributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blackColor],NSKernAttributeName:@7.5};
//    // Calculate the text size.
//    CGSize textSize = [self getTextSize:headerText font:font att:textAttributes];
//    // Determine the offset to the right side.
//    CGFloat offsetX = 20.0;
//    // Specify the point that the text drawing should start from.
//    CGFloat pointX = headerRect.size.width - textSize.width - offsetX;
//    CGFloat pointY = headerRect.size.height/2 - textSize.height/2;
//    // Draw the header text.
//    [headerText drawAtPoint:CGPointMake(pointX, pointY) withAttributes:textAttributes];
//}
// 绘制页脚
- (void)drawFooterForPageAtIndex:(NSInteger)pageIndex inRect:(CGRect)footerRect {
    NSString *footerText = [NSString stringWithFormat:@"第%lu页共%lu页",
                            pageIndex+1 - pageRange.location, (unsigned long)pageRange.length];
    NSDictionary *textAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize: 15] ,NSForegroundColorAttributeName:[UIColor blackColor],NSKernAttributeName:@7.5};
    CGSize textSize = [self getTextSize:footerText font:[UIFont systemFontOfSize:15] att:textAttributes];
    
//    CGFloat centerX = footerRect.size.width/2 - textSize.width/2;
//    CGFloat centerY = footerRect.origin.y + self.footerHeight/2 - textSize.height/2;
//
    // Specify the point that the text drawing should start from.
    CGFloat pointX = footerRect.size.width - textSize.width;
    CGFloat pointY = footerRect.origin.y + self.footerHeight/2;
    [footerText drawAtPoint:CGPointMake(pointX, pointY) withAttributes:textAttributes];
    
    // Draw a horizontal line.
    CGFloat lineOffsetX = 20.0;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 205.0/255.0, 205.0/255.0, 205.0/255, 1.0);
    CGContextMoveToPoint(context, lineOffsetX, footerRect.origin.y);
    CGContextAddLineToPoint(context, footerRect.size.width - lineOffsetX, footerRect.origin.y);
    CGContextStrokePath(context);
    
}
// 计算字符串尺寸
- (CGSize )getTextSize:(NSString *)text font:(UIFont *)font att:(NSDictionary *)att {

    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.paperRect.size.width, self.footerHeight)];
    if (att) {
        
        testLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:att];
    }else {
        testLabel.text = text;
        testLabel.font = font;
    }
    [testLabel sizeToFit];
    
    return testLabel.frame.size;
}
@end
