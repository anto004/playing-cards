import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad();
        
        var deck = PlayingCardDeck();
        for _ in 1...10 {
            if let card = deck.draw() {
                print("\(card)");
            }
        }
    }
}

