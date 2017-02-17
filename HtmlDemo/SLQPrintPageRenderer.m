//
//  PrintViewController.m
//  HtmlDemo
//
//  Created by MrSong on 17/2/15.
//  Copyright © 2017年 song. All rights reserved.
//

/*
 Setting SIMPLE_LAYOUT to 1 uses a layout that involves less application code and
 produces a layout where the web view content has margins that are relative to
 the imageable area of the paper.
 
 Setting SIMPLE_LAYOUT to 0 uses a layout that involves more computation and setup
 and produces a layout where the webview content is inset 1/2 from the edge of the
 paper (assuming it can be without being clipped). See the comments in
 APLPrintPageRenderer.m immediately after #if !SIMPLE_LAYOUT.
 */
#define SIMPLE_LAYOUT 1

// The point size to use for the height of the text in the
// header and footer.
#define HEADER_FOOTER_TEXT_HEIGHT     10

// The left edge of text in the header will be offset from the left
// edge of the imageable area of the paper by HEADER_LEFT_TEXT_INSET.
#define HEADER_LEFT_TEXT_INSET	      20

// The header and footer will be inset this much from the edge of the
// imageable area just to avoid butting up right against the edge that
// will be clipped.
#define HEADER_FOOTER_MARGIN_PADDING  5

// The right edge of text in the footer will be offset from the right
// edge of the imageable area of the paper by FOOTER_RIGHT_TEXT_INSET.
#define FOOTER_RIGHT_TEXT_INSET	      20



// The header and footer content will be no closer than this distance
// from the web page content on the printed page.
#define MIN_HEADER_FOOTER_DISTANCE_FROM_CONTENT	10

// Enforce a minimum 1/2 inch margin on all sides.
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
 For the case where we are not doing SIMPLE_LAYOUT, this code does the following:
 1) Makes the minimum margin for the content of the content portion of the printout (i.e. the webpage) at least 1/4" away from the edge of the paper. If the hardware margins of the paper are greater than that, then the hardware margins will force the content margins to be as large as they allow.
 2) Because this format is relative to the edge of the sheet rather than the imageable area, we need to compute these values once we know the paper size and printableRect. This is known in the numberOfPages method and that is the reason this code overrides that method.
 3) Since the header and footer heights of a UIPrintFormatter plays a part in determining height of of the content area, this code computes those heights, taking into account that we want the minimum 1/4" margin on the content.
 4) This code also enforces a minimum distance (MIN_HEADER_FOOTER_DISTANCE_FROM_CONTENT) between the header and footer and the content area.
 5) Note that the insets used for the contentInsets property of a UIPrintFormatter are relative to the imageable area of the paper being printed upon. The header and footer height are also imposed relative to the edge of the top and bottom hardware margin.
 */


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
- (void)drawHeaderForPageAtIndex:(NSInteger)pageIndex inRect:(CGRect)headerRect {
    // Specify the header text.
    NSString *headerText = @"第1次";
    
    // Set the desired font.
    UIFont *font = [UIFont systemFontOfSize:15];
    // Specify some text attributes we want to apply to the header text.
    NSDictionary *textAttributes = @{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor blackColor],NSKernAttributeName:@7.5};
    // Calculate the text size.
    CGSize textSize = [self getTextSize:headerText font:font att:textAttributes];
    // Determine the offset to the right side.
    CGFloat offsetX = 20.0;
    // Specify the point that the text drawing should start from.
    CGFloat pointX = headerRect.size.width - textSize.width - offsetX;
    CGFloat pointY = headerRect.size.height/2 - textSize.height/2;
    // Draw the header text.
    [headerText drawAtPoint:CGPointMake(pointX, pointY) withAttributes:textAttributes];
}

- (void)drawFooterForPageAtIndex:(NSInteger)pageIndex inRect:(CGRect)footerRect {
    NSString *footerText = [NSString stringWithFormat:@"第 %lu 页 共 %lu 页",
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
