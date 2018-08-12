import UIKit

class PlayingCardView: UIView {
    var rank: Int = 4 {
        didSet{
            setNeedsDisplay(); //call draw rect when it need to re-draw when rank changes
            setNeedsLayout() // re-draw subViews by calling layoutSubview()
            
        }
    };
    var suit: String = "❤️"{
        didSet{
            setNeedsDisplay();
            setNeedsLayout();
            
        }
    };
    var isFaceUp: Bool = true {
        didSet{
            setNeedsDisplay();
            setNeedsLayout();
            
        }
    };
    
    
    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize);
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font); //accessibility
        
        let paragraphStyle = NSMutableParagraphStyle();
        paragraphStyle.alignment = .center;
        
        return NSAttributedString(string: string, attributes: [.paragraphStyle: paragraphStyle, .font: font])
    }
    
    private var cornerString: NSAttributedString {
        return centeredAttributedString(rankString + "\n" + suit, fontSize: cornerFontSize);
    }
    
    private lazy var upperLeftCornerLabel = createCornerLabel();
    private lazy var lowerRightCornerLabel = createCornerLabel();
    
    //creating a UILabel in code
    private func createCornerLabel() -> UILabel {
        let label = UILabel();
        label.numberOfLines = 0;
        
        addSubview(label);
        return label;
    }
    
    private func configureCornerLabel(_ label: UILabel){
        label.attributedText = cornerString;
        label.frame.size = CGSize.zero; //expand both ways depending on the content
        label.sizeToFit();
        label.isHidden = !isFaceUp;
    }
    
    //for subview label autolayout
    override func layoutSubviews() {
        super.layoutSubviews();
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset);
        configureCornerLabel(upperLeftCornerLabel);
        
        configureCornerLabel(lowerRightCornerLabel)
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -lowerRightCornerLabel.frame.size.width, dy: -lowerRightCornerLabel.frame.size.height)
        lowerRightCornerLabel.transform = CGAffineTransform.identity.rotated(by: CGFloat.pi) //this would rotate around the origin i.e top left of this label
        //bring it down to the lower right
        lowerRightCornerLabel.transform = CGAffineTransform.identity.translatedBy(x: lowerRightCornerLabel.frame.size.width, y: lowerRightCornerLabel.frame.size.height)
        
        
        
    }
    
    override func draw(_ rect: CGRect) {
        //Draw some card with this parent view
        //Draw some card with subViews
        
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16.0);
        roundedRect.addClip();
        UIColor.white.setFill();
        roundedRect.fill();
        
    }
    
}






extension PlayingCardView {
    private struct SizeRatio {
        static let cornerFontSizesToBoundsHeight: CGFloat = 0.085;
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06;
        static let cornerOffsetToCornerRadius: CGFloat = 0.33;
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75;
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    };
    
    private var cornerOffset: CGFloat {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    private var cornerFontSize: CGFloat {
        return bounds.size.height * SizeRatio.cornerFontSizesToBoundsHeight
    }
    
    private var rankString: String {
        switch rank {
        case 1: return "A";
        case 2...10: return String(rank);
        case 11: return "J";
        case 12: return "Q";
        case 13: return "K";
        default:
            return "?"
        }
    }
}

extension CGRect {
    var leftHalf: CGRect {
        return CGRect(x: minX, y: minY, width: width/2, height: height/2);
    }
    
    var rightHalf: CGRect {
        return CGRect(x: midX, y: minY, width: width/2, height: height/2);
    }
    
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size);
    }
    
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale;
        let newHeight = height * scale;
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
    
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}


