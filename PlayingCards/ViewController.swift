import UIKit

class ViewController: UIViewController {
    
    var deck = PlayingCardDeck();
    
    @IBOutlet var viewCards: [PlayingCardView]!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        for _ in 1...10 {
            if let card = deck.draw() {
                print("\(card)");
            }
        }
    }
}
