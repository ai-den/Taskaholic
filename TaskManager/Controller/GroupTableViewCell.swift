//
//  GroupTableViewCell.swift
//  TaskManager
//
//  Created by Aiden on 01/12/2021.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var backgroundButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        groupNameLabel.font = UIFont(name: K.fonts.sfproRounded_Medium, size: 30)
        backgroundButton.layer.cornerRadius = backgroundButton.frame.height/9
//        backgroundButton.layoutSubviews()
//        backgroundButton.layer.layoutSublayers()
        backgroundButton.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

extension UIButton {

    open override func layoutSubviews() {
        super.layoutSubviews()
    }

    func updateGradientColors(_ colors: [UIColor]) {
        let gl = CAGradientLayer()
        gl.frame = self.layer.bounds
        gl.bounds = self.bounds
        gl.colors = colors.map { $0.cgColor }
        gl.locations = [0.0, 0.5, 0.1]
//        gl.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gl.endPoint = CGPoint(x: 1, y: 0.0)
        gl.cornerRadius = self.frame.height/9
        layer.insertSublayer(gl, below: self.layer)
    }
}
