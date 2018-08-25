import UIKit

class ViewController: UIViewController {
    
    var deck = PlayingCardDeck();

    
    @IBOutlet var cardViews: [PlayingCardView]!
    
    lazy var animator = UIDynamicAnimator(referenceView: view);
    
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior();
        behavior.translatesReferenceBoundsIntoBoundary = true;
        animator.addBehavior(behavior);
        return behavior;
    }();
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        var cards = Array<PlayingCard>();
        for _ in 1...(cardViews.count + 1) / 2 {
            if let card = deck.draw() {
                cards += [card, card];
            }
        }
        
        for cardView in cardViews {
            cardView.isFaceUp = false;
            let card = cards.remove(at: cards.count.arc4Random);
            cardView.rank = card.rank.order;
            cardView.suit = card.suit.rawValue;
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            collisionBehavior.addItem(cardView);
            let push = UIPushBehavior(items: [cardView], mode: .instantaneous);
            push.angle = (2 * CGFloat.pi).arc4Random
            push.magnitude = CGFloat(1.0) + CGFloat(2.0).arc4Random
            push.action = { [unowned push] in
                push.dynamicAnimator?.removeBehavior(push)
            }
            animator.addBehavior(push);
        }
        
    }
    
    private var faceUpCardViews: [PlayingCardView] {
        return cardViews.filter({$0.isFaceUp && !$0.isHidden})
    }
    
    private var faceUpCardViewMatch: Bool {
        print("\(faceUpCardViews.count)")
        return faceUpCardViews.count == 2 &&
            faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
            faceUpCardViews[0].suit == faceUpCardViews[1].suit;
    }
    
    @objc
    func flipCard(_ recognizer: UITapGestureRecognizer){
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView {
                UIView.transition(with: chosenCardView,
                                  duration: 0.6,
                                  options: [.transitionFlipFromLeft],
                                  animations: {
                                    chosenCardView.isFaceUp = !chosenCardView.isFaceUp;
                                  },
                                  completion: { finished in
                                        if self.faceUpCardViewMatch {
                                            UIViewPropertyAnimator.runningPropertyAnimator(
                                                withDuration: 0.6,
                                                delay: 0,
                                                options: [],
                                                animations: {
                                                    self.faceUpCardViews.forEach({
                                                        $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                                    })
                                            },
                                                completion:  { position in
                                                    if self.faceUpCardViewMatch {
                                                        UIViewPropertyAnimator.runningPropertyAnimator(
                                                            withDuration: 0.6,
                                                            delay: 0,
                                                            options: [],
                                                            animations: {
                                                                self.faceUpCardViews.forEach({
                                                                    $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                                    $0.alpha = 0;
                                                                })
                                                            },
                                                            completion: { position in
                                                                self.faceUpCardViews.forEach({
                                                                    $0.isHidden = true;
                                                                    $0.alpha = 1;
                                                                    $0.transform = .identity
                                                                })
                                                        }
                                                        )
                                                    }
                                            }
                                         )
                                        }
                                        
                                        else if self.faceUpCardViews.count == 2 {
                                                self.faceUpCardViews.forEach({cardView in
                                                    UIView.transition(with: cardView,
                                                                      duration: 0.6,
                                                                      options: [.transitionFlipFromLeft],
                                                                      animations: {
                                                                        cardView.isFaceUp = false;
                                                                      },
                                                                      completion: {finished in
                                                                        
                                                    })
                                                })
                                            }
                                    })
            }
        default:
            break;
        }
    }
}

extension CGFloat {
    var arc4Random: CGFloat {
        if self > 0 {
            return CGFloat(arc4random_uniform(UInt32(self))); // self is the Int passed to this function
        }
        else if self < 0 {
            return -CGFloat(arc4random_uniform(UInt32(self)));
        }
        else {
            return 0;
        }
    }
}




