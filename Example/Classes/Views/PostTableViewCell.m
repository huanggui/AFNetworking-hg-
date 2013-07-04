// TweetTableViewCell.m
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "PostTableViewCell.h"

#import "Post.h"
#import "User.h"

#import "UIImageView+AFNetworking.h"

@implementation PostTableViewCell {
@private
    __strong Post *_post;
}

@synthesize post = _post;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.textColor = [UIColor darkGrayColor];
    self.detailTextLabel.font = [UIFont systemFontOfSize:13.0f];
    self.detailTextLabel.numberOfLines = 0;//等于0表示行数不确定可随内容变化
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return self;
}

- (void)setPost:(Post *)post {
    _post = post;

    self.textLabel.text = _post.user.username;
    self.detailTextLabel.text = _post.text;
    //实现了对图像的异步下载和本地缓存
    [self.imageView setImageWithURL:_post.user.avatarImageURL placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
    
    [self setNeedsLayout];//默认调用layoutSubviews
}

//根据具体表单元的内容多少调整该行的高度
//字符串在指定区域内按照指定的字体显示时,需要的宽度和高度(而宽度在字符串只有一行时有用)
//一般用法:指定区域的宽度而高度用MAXFLOAT,则返回值包含对应的高度
//如果指定区域的宽度指定,而字符串要显示的区域的高度超过了指定区域的高度,则高度返回0
//核心:多行显示,指定宽度,获取高度
+ (CGFloat)heightForCellWithPost:(Post *)post {
    CGSize sizeToFit = [post.text sizeWithFont:[UIFont systemFontOfSize:12.0f] constrainedToSize:CGSizeMake(220.0f, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    
    return fmaxf(70.0f, sizeToFit.height + 45.0f);
}

#pragma mark - UIView

//在自己定制的视图中重载这个方法，用来调整子视图的尺寸和位置。
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10.0f, 10.0f, 50.0f, 50.0f);
    self.textLabel.frame = CGRectMake(70.0f, 10.0f, 240.0f, 20.0f);
    
    CGRect detailTextLabelFrame = CGRectOffset(self.textLabel.frame, 0.0f, 25.0f);
    detailTextLabelFrame.size.height = [[self class] heightForCellWithPost:_post] - 45.0f;
    self.detailTextLabel.frame = detailTextLabelFrame;
}

@end
