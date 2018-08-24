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
            cardView.isFaceUp = true;
            let card = cards.remove(at: cards.count.arc4Random);
            cardView.rank = card.rank.order;
            cardView.suit = card.suit.rawValue;
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
        }
        
    }
    
    @objc
    func flipCard(_ recognizer: UITapGestureRecognizer){
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView {
                chosenCardView.isFaceUp = !chosenCardView.isFaceUp;
            }
        default:
            break;
        }
    }
}
