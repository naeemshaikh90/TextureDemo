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


import UIKit
import AsyncDisplayKit

private enum SectionType {
    case PostCell
}

private struct Section {
    var type: SectionType
    var items: Int
}

final class PostDatasource: NSObject, PostTableNodeDatasource {
    var posts: [Post] = []
    fileprivate var sections = [Section]()
    
    weak var tableNode: ASTableNode?
    weak var delegate: ASTableDelegate?
    
    required init(posts: [Post], tableNode: ASTableNode, delegate: ASTableDelegate) {
        self.posts = posts
        self.tableNode = tableNode
        self.delegate = delegate
        
        super.init()
        sections = [
            Section(type: .PostCell, items: posts.count)
        ]
        self.setupTableNode()
    }
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        let sectionCount = sections.first?.items
        if let sectionCount = sectionCount{
            return sectionCount
        } else {
            return 0
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        return post.content.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let post = posts[indexPath.section]
        let content = post.content[indexPath.row]
        
        return {
            var node: ASCellNode
            if content.t == 1 {
                node = TextCell(content: content)
            } else {
                node = ImageCell(content: content)
            }
            return node
        }
    }
    
    @objc(tableNode:constrainedSizeForRowAtIndexPath:)
    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        let min = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/3.0 * 2.0)
        let max = CGSize(width: UIScreen.main.bounds.size.width, height: CGFloat.greatestFiniteMagnitude)
        return ASSizeRange(min: min, max: max)
    }
}

/*
// MARK: - ASTableDelegate
class PostTableDelegate: NSObject, ASTableDelegate {
    let delegate: PostDelegate
    
    init(_ delegate: PostDelegate) {
        self.delegate = delegate
    }
    
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return true
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        delegate.didSelectPost(at: indexPath)
    }
}
*/
