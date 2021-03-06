/*
 * Created by Naeem Shaikh on 15/08/17.
 *
 * Copyright © 2017-present Naeem G Shaikh. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


import Foundation
import AsyncDisplayKit

class TextCell: ASCellNode {
    let content: Content
    
    fileprivate let postTextNode: ASTextNode
    
    init(content: Content) {
        self.content = content
        
        postTextNode = ASTextNode()
        
        super.init()
        
        backgroundColor = UIColor.lightGray
        clipsToBounds = true
        
        //Post Text
        postTextNode.attributedText = NSAttributedString(string: content.v)
        postTextNode.backgroundColor = UIColor.clear
        postTextNode.placeholderEnabled = true
        postTextNode.placeholderFadeDuration = 0.15
        postTextNode.placeholderColor = UIColor(white: 0.777, alpha: 1.0)
        addSubnode(postTextNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let ratio = (constrainedSize.min.height)/constrainedSize.max.width;
        let textRatioSpec = ASRatioLayoutSpec(ratio: ratio, child: postTextNode)
        return textRatioSpec
    }
}
