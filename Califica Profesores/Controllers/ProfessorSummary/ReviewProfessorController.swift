//
//  ReviewProfessorController.swift
//  Califica Profesores
//
//  Created by Dylan Tasat on 17/03/2019.
//  Copyright © 2019 Dylan Tasat. All rights reserved.
//

import UIKit
import BEMCheckBox
import Cosmos
import CardParts
import HGCircularSlider

class ReviewProfessorController: UIViewController, UITextViewDelegate, RealTimeCircularSliderDelegate, ReviewProfessorNetwork {

    var professor : ProfessorItem?
    var opinion : OpinionItem?
    var subjList : ProfessorReviewSubjectList?
    let roundingRule : FloatingPointRoundingRule = .toNearestOrAwayFromZero
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var anonymousCheckbox: BEMCheckBox!
    @IBOutlet weak var anonymousLabel: UILabel!
    @IBOutlet weak var norateCheckbox: BEMCheckBox!
    @IBOutlet weak var norateLabel: UILabel!
    @IBOutlet weak var rate: CosmosView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var subjectsContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var amabilidadSlider: RealTimeCircularSlider!
    @IBOutlet weak var clasesSlider: RealTimeCircularSlider!
    @IBOutlet weak var conocimientoSlider: RealTimeCircularSlider!
    @IBOutlet weak var conocimientoNumber: UILabel!
    @IBOutlet weak var clasesNumber: UILabel!
    @IBOutlet weak var amabilidadNumber: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // CONFIGURO LA INPUT DEL COMENTARIO
        textView.text = "Comentario..."
        textView.textColor = UIColor.lightGray
        textView.delegate = self
        // CONFIGURO LAS CHECKBOX
        let tap = UITapGestureRecognizer(target: self, action: #selector(ReviewSubjectController.switchAnonymous))
        anonymousLabel.addGestureRecognizer(tap)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(ReviewSubjectController.switchNorate))
        norateLabel.addGestureRecognizer(tap2)
        // ARREGLO EL BUG DEL TECLADO
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        // AGREGO PARA QUE SE CIERRE EL TECLADO TOCANDO AFUERA
        let tap3: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReviewSubjectController.dismissKeyboard))
        view.addGestureRecognizer(tap3)
        // CONFIGURO EL BOTON DE ENVIAR
        sendButton.isEnabled = false
        sendButton.alpha = 0.6
        // INICIALIZO LA LISTA DE MATERIAS
        subjList = children.first as? ProfessorReviewSubjectList
        subjList!.loadProfessor(prof: professor!)
        // CONFIGURO LOS SLIDERS
        amabilidadSlider.delegate = self
        amabilidadSlider.number = amabilidadNumber
        clasesSlider.delegate = self
        clasesSlider.number = clasesNumber
        conocimientoSlider.delegate = self
        conocimientoSlider.number = conocimientoNumber
        amabilidadSlider.endPointValue = 2.5
        clasesSlider.endPointValue = 2.5
        conocimientoSlider.endPointValue = 2.5
        updateRank()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        subjectsContainerHeight.constant = subjList!.collectionView.contentSize.height + 24
        subjList?.collectionView.isScrollEnabled = false
        // REVISO SI HAY DATOS CARGADOS
        if opinion != nil {
            configure()
        }
    }
    
    func configure() {
        amabilidadSlider.endPointValue = CGFloat(opinion!.amabilidad!)
        clasesSlider.endPointValue = CGFloat(opinion!.clases!)
        conocimientoSlider.endPointValue = CGFloat(opinion!.conocimiento!)
        updateRank()
        textViewDidBeginEditing(textView)
        textView.text = opinion!.content!
        norateCheckbox.setOn(!(opinion!.conTexto!), animated: false)
        anonymousCheckbox.setOn(opinion!.anonimo!, animated: false)
        noRankChanged(norateCheckbox)
        textViewDidChange(textView)
        textViewDidEndEditing(textView)
        for card in subjList!.cards {
            if let selectableCard = card as? SelectableSubjectCard {
                selectableCard.setSelected(selected: opinion!.materias[selectableCard.data!.id!] != nil)
            }
        }
        for slider in [amabilidadSlider, clasesSlider, conocimientoSlider] {
            self.updateTracking(element: slider!, number: slider?.number)
        }
    }
    
    @objc func dismissKeyboard(sender:UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func switchAnonymous(sender:UITapGestureRecognizer) {
        anonymousCheckbox.setOn(!anonymousCheckbox.on, animated: true)
    }
    
    @objc func switchNorate(sender:UITapGestureRecognizer) {
        norateCheckbox.setOn(!norateCheckbox.on, animated: true)
        noRankChanged(norateCheckbox)
    }
    
    @IBAction func sendButton(_ sender: UIButton) {
        let opinion = OpinionItem()
        opinion.anonimo = anonymousCheckbox.on
        if (opinion.anonimo!) {
            opinion.author = "Anónimo"
        } else {
            opinion.author = currentUser?.displayName
        }
        if (textView.textColor == UIColor.lightGray) {
            opinion.content = ""
        } else {
            opinion.content = textView.text
        }
        opinion.conTexto = !(norateCheckbox.on)
        opinion.likes = 0
        opinion.timestamp = Int(Date().timeIntervalSince1970 * 1000.0)
        opinion.amabilidad = Int(amabilidadSlider.endPointValue.rounded(roundingRule))
        opinion.clases = Int(clasesSlider.endPointValue.rounded(roundingRule))
        opinion.conocimiento = Int(conocimientoSlider.endPointValue.rounded(roundingRule))
        for card in subjList!.cards {
            if let selectableCard = card as? SelectableSubjectCard {
                if selectableCard.selected {
                    opinion.materias[selectableCard.data!.id!] = selectableCard.data!.ShownName!
                }
            }
        }
        sendReview(opinion: opinion, professorId: professor!.id!, userUID: currentUser!.uid)
    }
    
    func finishedSend(success: Bool) {
        if (success) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func loadProfessor(prof : ProfessorItem) {
        self.professor = prof
    }
    
    func loadOpinion(op: OpinionItem) {
        opinion = op
    }
    
    @IBAction func noRankChanged(_ sender: BEMCheckBox) {
        if sender.on {
            sendButton.isEnabled = true
            sendButton.alpha = 1
        } else if textView.text != nil && textView.text != "" {
            sendButton.isEnabled = false
            sendButton.alpha = 0.6
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text != nil && textView.text != "") || norateCheckbox.on {
            sendButton.isEnabled = true
            sendButton.alpha = 1
        } else {
            sendButton.isEnabled = false
            sendButton.alpha = 0.6
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Comentario..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func updateTracking(element: RealTimeCircularSlider, number: UILabel?) {
        number?.text = Int(element.endPointValue.rounded(roundingRule)).description
        updateRank()
    }
    
    func updateRank() {
        var rank : Double = 0
        let sliders = [conocimientoSlider, clasesSlider, amabilidadSlider]
        for slider in sliders {
            rank += Double(slider!.endPointValue.rounded(roundingRule))
        }
        rank /= 3.0
        self.rate.rating = rank
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let new_inset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardRect!.height, right: 0)
        scrollView.contentInset = new_inset
        scrollView.scrollIndicatorInsets = new_inset
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        let new_inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        scrollView.contentInset = new_inset
        scrollView.scrollIndicatorInsets = new_inset
    }
}

class ProfessorReviewSubjectList: CardsViewController {
    
    var cards: [CardController] = []
    var professor : ProfessorItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if professor == nil { return }
        cards = []
        for mat in professor!.Mat {
            let card = SelectableSubjectCard(data: mat)
            cards.append(card)
        }
        let linkCard = LinkSubjectCard()
        linkCard.loadProfessor(prof: professor)
        cards.append(linkCard)
        self.loadCards(cards: cards)
    }
    
    func loadProfessor(prof: ProfessorItem) {
        self.professor = prof
    }
}

class LinkSubjectCard : CardPartsViewController, RoundedCardTrait {
    var text = CardPartTextView(type: .normal)
    var professor : ProfessorItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        text.text = "¿Faltan materias?"
        text.textAlignment = .center
        setupCardParts([text])
        self.cardTapped {
            let controller = UIStoryboard(name: "Professors", bundle: nil).instantiateViewController(withIdentifier: "AddSubjectsToProfessor") as! AddSubjectsToProfessor
            controller.loadProfessor(prof: self.professor)
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func loadProfessor(prof: ProfessorItem?) {
        self.professor = prof
    }
    
    func cornerRadius() -> CGFloat {
        return 15.0
    }
}

class SelectableSubjectCard: CardPartsViewController, RoundedCardTrait, NoTopBottomMarginsCardTrait {
    
    var marginTop = CardPartSpacerView(height: 10)
    var marginBottom = CardPartSpacerView(height: 10)
    var subject = CardPartTextView(type: .normal)
    var separator = CardPartSeparatorView()
    var school = CardPartTextView(type: .normal)
    var data : SubjectItem?
    var selected : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 15.0
        subject.font = UIFont(name: "AmericanTypewriter-Bold", size: 19.0)
        school.font = UIFont(name: "ArialMT", size: 12.0)
        setupCardParts([marginTop, subject, separator, school, marginBottom])
        self.cardTapped {
            self.setSelected(selected: !self.selected)
        }
    }
    
    func setSelected(selected: Bool) {
        if selected {
            self.view.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
        } else {
            self.view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        }
        self.selected = selected
    }
    
    init(data : SubjectItem) {
        super.init(nibName: nil, bundle: nil)
        subject.text = data.ShownName
        school.text = data.FacultadName
        self.data = data
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cornerRadius() -> CGFloat {
        return 15.0
    }
    
}

protocol RealTimeCircularSliderDelegate {
    func updateTracking(element: RealTimeCircularSlider, number: UILabel?)
}

class RealTimeCircularSlider : CircularSlider {
    var delegate : RealTimeCircularSliderDelegate?
    var number : UILabel?
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if delegate != nil {
            delegate!.updateTracking(element: self, number: number)
        }
        return super.continueTracking(touch, with: event)
    }
}
