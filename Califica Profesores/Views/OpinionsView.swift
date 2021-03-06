//
//  OpinionsView.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 17/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import CardParts
import Cosmos
import XLPagerTabStrip
import LinearProgressView

class OpinionCard : CardPartsViewController, RoundedCardTrait, NoTopBottomMarginsCardTrait {
    
    var mainView : OpinionCardView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardParts([mainView!])
    }
    
    init(opinion: OpinionItem) {
        super.init(nibName: nil, bundle: nil)
        mainView = OpinionCardView(opinion: opinion)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cornerRadius() -> CGFloat {
        return 15.0
    }
}

public class OpinionCardView: UIView, CardPartView {
    public var margins: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var score: CosmosView!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var materias: UILabel!
    @IBOutlet weak var professorDataView: UIView!
    @IBOutlet weak var amabilidad: LinearProgressView!
    @IBOutlet weak var conocimiento: LinearProgressView!
    @IBOutlet weak var clases: LinearProgressView!
    @IBOutlet weak var professorDataHeight: NSLayoutConstraint!
    
    init(opinion: OpinionItem? = nil) {
        super.init(frame: CGRect.zero)
        configNib()
        commonInit(op: opinion)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configNib()
        commonInit(op: nil)
    }
    
    func configNib() {
        Bundle.main.loadNibNamed("OpinionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        contentView.layer.cornerRadius = 15.0
    }
    
    func commonInit(op: OpinionItem?) {
        leftView.layer.cornerRadius = 15.0
        if op != nil {
            let opinion = op!
            nameLabel.text = opinion.author
            content.text = opinion.content!
            content.sizeToFit()
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
            dateFormatter.locale = Locale(identifier: "es_ES")
            dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss" //Specify your format that you want
            timeLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: Double(opinion.timestamp!/1000)))
            if opinion.valoracion != nil {
                score.rating = Double(opinion.valoracion!)/2.0
                materias.text = ""
                professorDataView.isHidden = true
                professorDataHeight.constant = 0
            } else {
                score.rating = Double(opinion.clases! + opinion.amabilidad! + opinion.conocimiento!) / 3.0
                materias.text = ""
                for mat in opinion.materias.values {
                    materias.text!.append(contentsOf: mat)
                    materias.text!.append(contentsOf: "\n")
                }
                amabilidad.setProgress(Float(opinion.amabilidad!), animated: false)
                clases.setProgress(Float(opinion.clases!), animated: false)
                conocimiento.setProgress(Float(opinion.conocimiento!), animated: false)
            }
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 63 + professorDataHeight.constant + content.contentSize.height)
    }
}
