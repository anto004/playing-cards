//
//  CardBehavior.swift
//  PlayingCards
//
//  Created by Antonio Bang on 8/25/18.
//  Copyright © 2018 UCLAExtension. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior();
        behavior.translatesReferenceBoundsIntoBoundary = true;
        return behavior;
    }();
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior();
        behavior.allowsRotation = false;
        behavior.elasticity = 1.0;
        behavior.resistance = 0; //outer space like
        return behavior;
    }()
    
    private func push(_ item: UIDynamicItem){
        //Push behavior
        let push = UIPushBehavior(items: [item], mode: .instantaneous);
        push.angle = (2 * CGFloat.pi).arc4Random
        push.magnitude = CGFloat(1.0) + CGFloat(2.0).arc4Random
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    func addItem(_ item: UIDynamicItem){
        collisionBehavior.addItem(item);
        itemBehavior.addItem(item);
        push(item)
    }
    
    func removeItem(_ item: UIDynamicItem){
        collisionBehavior.removeItem(item);
        itemBehavior.removeItem(item);
        //push is removed up
    }
    
    override init(){
        super.init();
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator){
        self.init()
        animator.addBehavior(self)
    }
}
