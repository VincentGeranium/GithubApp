//
//  UIHelper.swift
//  GithubApp
//
//  Created by 김광준 on 2021/08/27.
//

import UIKit

struct UIHelper {
    // c.f: If you want access to anywhere, declare keyword that static in front of func
    // MARK:- createThreeColumnFlowLayout
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        /*
         c.f:
         This 'width' is total width of screen and also the width is same things used in the all the iPhone version.
         In other words 'view.bounds.width' is means same that total width screen which any version of iPhone.
         */
        let width = view.bounds.width
        
        // c.f: padding is means give space that all around of edges which top, botton, leading and trailing.
        let padding: CGFloat = 12
        let minimumSpacing: CGFloat = 10
        
        // compute available width
        /*
         Discussion: About compute avaliable width
         
         1. why substract padding by two times?
         -> Because I want give space leading and trailing
         
         2. why substract minimumSpacing by two times?
         -> Because I will make collectionView Items are 3, in other word I will create three column
            So, I want give space between items.
            Three Items are have two space between each items.
            That's the reason I substract minimumSpacing by two times.
            In additional If, I want make 4 Items in the screen, I the space is 3.
         */
        let availableWidth = width - (padding * 2) - (minimumSpacing * 2)
        
        // c.f : Item width is actual cell
        let itemWidth = availableWidth / 3
        
        /*
         Discussion: Why cell height is gonna itemWidth + 40?
         Because the collection view cell get avatar image and 'name label'
         The name label size is 20, so I give more 20 padding each of the cell
         The point is why I did give +40 when create height size.
         The reason is cell have avatar image and also have '20 points size of name label'.
         */
        let itemHeight = itemWidth + 40
        
        /*
         Discussion: About FlowLayout
         The FlowLayout basically determinds the flow of collection view
         In other words give cell's paddind, width and height ect,,, that's determinds the flow of collection view.
         */
        // create UICollectionViewFlowLayout object.
        let flowLayout = UICollectionViewFlowLayout()
        
        // configure flowlayout
        // c.f: 'UIEdgeInsets' is give padding all around of edge
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        // this is cell size
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        return flowLayout
    }
}
