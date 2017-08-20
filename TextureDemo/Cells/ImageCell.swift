/*
 * Created by Naeem Shaikh on 13/08/17.
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

import UIKit
import AsyncDisplayKit

class ImageCell: ASCellNode {
    let content: Content
    
    fileprivate let postImageNode: ASNetworkImageNode
    
     init(content: Content) {
        self.content = content
        
        postImageNode = ASNetworkImageNode()
        
        super.init()
        
        backgroundColor = UIColor.lightGray
        clipsToBounds = true
        
        // Post Image
        postImageNode.url = URL(string: content.v)!
        postImageNode.clipsToBounds = true
        postImageNode.delegate = self
        postImageNode.placeholderFadeDuration = 0.15
        postImageNode.contentMode = .scaleAspectFill
        postImageNode.shouldRenderProgressImages = true
        
        addSubnode(postImageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let ratio = (constrainedSize.min.height)/constrainedSize.max.width;
        let imageRatioSpec = ASRatioLayoutSpec(ratio: ratio, child: postImageNode)
        return imageRatioSpec
    }
}

// MARK: - ASNetworkImageNodeDelegate

extension ImageCell: ASNetworkImageNodeDelegate {
    func imageNode(_ imageNode: ASNetworkImageNode, didLoad image: UIImage) {
        
    }
}
