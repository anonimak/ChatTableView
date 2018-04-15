//: Playground - noun: a place where people can play
// Maximo Lucosi: https://github.com/lucosi/ChatTableView

import UIKit
import PlaygroundSupport
import Foundation


// iPhone X screen resolution
let frame = CGRect(origin: .zero, size: CGSize.init(width: 375, height: 812))


// Messages for test
class Message {
    let message: String
    var incoming: Int
    let image: UIImage
    init(message: String, image: UIImage, incoming: Int) {
        self.message = message
        self.image = image
        self.incoming = incoming
    }
}

// Cell Id
private let cellId = "cellId"

// Basic view controller for the demo
class MyViewController: UIViewController {
    
    // Messages for test
    var messages: [Message] = []
    
    // Table View here + basic configuration
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .white
        view.separatorStyle = .none
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the screen size befor implement layour. NOTICE: Only for playground test
        self.view.frame = frame
        
        // Messages for test //
        self.messages.append(Message.init(message: "I'm working on a chat app with message bubbles.",
                                          image: UIImage.init(),
                                          incoming: 0))
        
        self.messages.append(Message.init(message: "What is your dificulte.",
                                          image: UIImage(),
                                          incoming: 1))
        
        self.messages.append(Message.init(message: "I'm having difficulty getting the chat bubbles to align to the left or right side of the view controller.",
                                          image: UIImage.init(),
                                          incoming: 0))
        
        self.messages.append(Message.init(message: "One more for me",
                                          image: UIImage(),
                                          incoming: 1))
        
        self.messages.append(Message.init(message: "I have already implemented a function that redraws UILabels with a passed ratio. So all I need to find is the text in UILabel from my view that would require the maximum ratio to redraw UILabels. So finally I need to do something like this:",
                                          image: UIImage(), incoming: 1))
        // End //
        
        
        // Add the tableView
        self.view.addSubview(tableView)
        
        // Register teh cell in the tableView
        self.tableView.register(ConversationCell.self, forCellReuseIdentifier: cellId)
        
        // Criate a contraint for the table view
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 44),
                tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ]
        )
    }
}


extension String {
    
    //* Calculeta the hight string Function
    func calculateTextFrameRect(
        objectsInPlaceHeight: CGFloat,
        objectsInPlaceWidth: CGFloat,
        fontSize: CGFloat,
        fontWeight: CGFloat) -> CGSize
    {
        let bounding = CGSize(width: UIScreen.main.bounds.width - objectsInPlaceWidth, height: .infinity)
        let rect = NSString(string: self).boundingRect(
            with: bounding,
            options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin),
            attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight(rawValue: fontWeight))],
            context: nil)
        return CGSize(width: UIScreen.main.bounds.width, height: rect.height + objectsInPlaceHeight )
    }
}


// Conform table view with delegate and data source
extension MyViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Change the hight of the cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Calculate the hight of the cell
        let text = self.messages[indexPath.item].message
        let frameSize = text.calculateTextFrameRect(
            objectsInPlaceHeight: 44 + 10,
            objectsInPlaceWidth: 20 + 44 + 20 + self.view.frame.width * 0.4,
            fontSize: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body).pointSize,
            fontWeight: UIFont.Weight.medium.rawValue)
        return frameSize.height
    }
    
    // Number os cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    // Return cell to display on the tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ConversationCell
        cell.messageData = self.messages[indexPath.item]
        return cell
        
    }
}


//****** Custom cell class  ******///
class ConversationCell: UITableViewCell {
    
    var messageData: Message? {
        didSet {
            // Umrap the value incide the cell
            if let message = messageData {
                
                // Confiture the constraints for cell
                if message.incoming == 0 {
                    // Text
                    self.messageTextView.textAlignment = .left
                    self.bubleImage.backgroundColor = .orange
                    
                    // Constraints
                    self.lefBubleConstraint.isActive = true
                    self.rightBubleConstraint.isActive = false
                
                } else {
                    // Text
                    self.messageTextView.textAlignment = .right
                    self.bubleImage.backgroundColor = .blue
 
                    // Constraints
                    self.lefBubleConstraint.isActive = false
                    self.rightBubleConstraint.isActive = true
                
                }
                
                if lefBubleConstraint.isActive == true {
                    
                    self.leftMessageLable.isActive = true
                    self.rightMessageLable.isActive = false
                
                } else {
                    
                    self.leftMessageLable.isActive = false
                    self.rightMessageLable.isActive = true
                
                }
                
                // Set the data
                self.messageTextView.text = message.message
                self.bubleImage.image = message.image
        
            }
        }
    }
    
    // Create and config the image
    let bubleImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        view.layer.cornerRadius = 22
        view.layer.masksToBounds = true
        return view
    }()
    
    // Create and config the lable for the text
    let messageTextView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        view.layer.cornerRadius = 10
        view.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    // Constraints for configuration on didSet data
    var lefBubleConstraint: NSLayoutConstraint!
    var rightBubleConstraint: NSLayoutConstraint!
    var leftMessageLable: NSLayoutConstraint!
    var rightMessageLable: NSLayoutConstraint!
    
    // Init the cell with local congiguration
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: nil)
        
        self.addSubview(bubleImage)
        self.addSubview(messageTextView)
        
        // Permanent constraints
        NSLayoutConstraint.activate(
            [
                self.bubleImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
                self.bubleImage.heightAnchor.constraint(equalToConstant: 44),
                self.bubleImage.widthAnchor.constraint(equalToConstant: 44),
                
                self.messageTextView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
                self.messageTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
                // NOTICE: Use the frame with as parameter for mesure the hight of cell on the main view
                self.messageTextView.widthAnchor.constraint(equalToConstant: self.frame.width * 0.7)
            ]
        )
        
        // Buble constraint for configuration
        self.lefBubleConstraint = self.bubleImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10)
        self.rightBubleConstraint = self.bubleImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10)
        
        // Message constrait for congiguration
        self.rightMessageLable = self.messageTextView.rightAnchor.constraint(equalTo: self.bubleImage.leftAnchor, constant: -10)
        self.leftMessageLable = self.messageTextView.leftAnchor.constraint(equalTo: self.bubleImage.rightAnchor, constant: 10)
        
    }
    // requerid init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

let windows = UIWindow()
windows.bounds = frame
let navigationController = UINavigationController(rootViewController: MyViewController())
windows.rootViewController = navigationController
windows.makeKeyAndVisible()

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = windows


