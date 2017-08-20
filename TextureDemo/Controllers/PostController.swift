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
import RealmSwift

// MARK: - View Life Cycle

class PostController: UIViewController {
    
    let tableNode = ASTableNode()
    var apiManager: NetworkAPICalls = NetworkAPIManger()
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //fetchSavePosts()
        
        if posts.isEmpty {
            fetchPosts()
        }
        
        setupTableNode()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tableNode.frame = self.view.bounds
    }
}

// MARK: - Netowrking

extension PostController {
    func fetchSavePosts() {
        do {
            let realm = try Realm()
            let offlinePosts = realm.objects(Post.self)
            for offlinePost in offlinePosts {
                posts.append(offlinePost)
            }
            
            if !posts.isEmpty {
                //self.setupTableNode(with: posts)
            }
        } catch let error as NSError {
            print(error)
        }
    }

    func fetchPosts() {
        apiManager.posts() { posts in
            if let posts = posts {
                //self.setupTableNode(with: posts)
                self.posts = posts
            }
        }
    }
}

// MARK: - ASTableNode

extension PostController {
    func setupTableNode() {
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
        self.tableNode.view.separatorStyle = .singleLineEtched
        self.view.addSubnode(tableNode)
    }
}

// MARK: - ASTableDelegate

extension PostController: ASTableDelegate {
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return true
    }
}

// MARK: - ASTableDataSource

extension PostController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return posts.count
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
