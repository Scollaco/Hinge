//
//  OfflineView.swift
//  HingeTest
//
//  Created by Saturnino Teixeira on 5/31/16.
//  Copyright © 2016 Green. All rights reserved.
//

import UIKit

protocol HNGOfflineViewDelegate {
    
    func reloadImages()
}

class HNGOfflineView: UIView {

    var delegate : HNGOfflineViewDelegate?
    @IBOutlet var contentView: UIView!

    private func commonInit() {
       
        NSBundle.mainBundle().loadNibNamed("HNGOfflineView", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(content)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBAction func reloadButtonPressed(sender: AnyObject) {
        self.delegate?.reloadImages()
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
