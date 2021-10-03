//
//  UIHelper.swift
//  GithubApp
//
//  Created by 김광준 on 2021/08/27.
//

import UIKit

// MARK:- struct 에서 enum으로 바꾼 이유?
/*
 Discussion: struct 에서 enum으로 바꾼 이유?
 처음 UIHelper를 만들 때에는 Structure(이하 struct)로 UIHelper를 구현했었다.
 UIHelper를 struct로 구현 할 경우 빈 UIHelper를 Initialized(초기화)할 수 있다.
 그 이유는 struct의 특성 때문이다. struct는 기본적으로 멤버와이즈 이니셜라이저가 구현되기 때문이다. (c.f:사용자 정의 이니셜라이저를 구현하고 싶다면 가능하다.)
 그러나 빈 UIHelper는 UIHelper를 구현하게 된 목적과 전혀 다르기 때문에 빈 UIHelper는 필요 없다.
 죽, 빈 UIHelper는 굳이 만들어 질 필요도 없으며 만들어지게 놔둬서도 안되는 것이다. (구현의 목적과 다르다는 뜻.)
 내가 UIHepler를 구현한 이유는 createThreeColumnFlowLayout 메소드를 활용하여 쉽게 UICollectionViewFlowLayout를 만드는 것이다
 그러므로 UIHelper.createThreeColumnFlowLayout(view: someView) 처럼 사용되길 바라기 때문에 enum으로 구현하고
 강제력을 준 것이다. 열거형이 대표적으로 사용되는 경우 3가지를 보면 1.제한된 선택지를 주고 싶을 때 2. 정해진 값 외에 값을 받고 싶지 않을 때 3. 예상된 입력 값이 한정되어 있을 때 이다
 이 3가지가 모두 합당하므로 enum으로 UIHelper를 구현하는 것이 맞다고 생각되어 structure에서 enum으로 refactoring 하게 되었다.
 */

enum UIHelper {
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
