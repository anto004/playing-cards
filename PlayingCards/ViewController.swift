import UIKit

class ViewController: UIViewController {
    
    var deck = PlayingCardDeck();

    
    @IBOutlet var cardViews: [PlayingCardView]!
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
        }
        
    }
    
    private var faceUpCardViews: [PlayingCardView] {
        return cardViews.filter({$0.isFaceUp && !$0.isHidden})
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
                                        if self.faceUpCardViews.count == 2 {
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
