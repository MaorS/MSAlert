//
//  MSAlert.swift
//  Created by Maor Shams on 07/04/2017.
//  Copyright © 2017 Maor Shams. All rights reserved.
//
import UIKit
import AVFoundation

class MSAlert: UIAlertController {
    
    class MSAlertAction : UIAlertAction{
        
        var type : MSAlert.ActionType?
        
        convenience init(actionTitle: String,
                         style: UIAlertActionStyle,
                         image : UIImage? = nil,
                         actionType : MSAlert.ActionType? = nil,
                         handler: @escaping ((UIAlertAction) -> Void) ){
            
            self.init(title: actionTitle, style: style, handler: handler)
            
            self.setValue(image, forKey: "image")
            self.type = actionType
        }
    }
    
    enum ActionType {
        
        case cancel
        case ok
        case yes
        case no
        
        var title : String{
            switch self {
            case .cancel      : return "Cancel"
            case .ok          : return "Ok"
            case .yes         : return "Yes"
            case .no          : return "No"
            }
        }
        
        var image : UIImage?{
            switch self {
            default : return #imageLiteral(resourceName: "icons8-ok")
            }
        }
        
    }
    
    override var preferredStyle: UIAlertControllerStyle {
        return .alert
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    convenience init(viewController : UIViewController,
                     sourceView : UIView? ,
                     arrowDirections : UIPopoverArrowDirection = [.any],
                     title: String? = nil,
                     message: String? = nil) {
        self.init()
        initialize(viewController: viewController,sourceView: sourceView, title: title, message: message)
    }
    
    // Configuration for alert
    private func initialize(viewController : UIViewController? = nil,
                            sourceView : UIView? = nil,
                            arrowDirections : UIPopoverArrowDirection = [.any],
                            title: String? = nil,
                            message: String? = nil) {
        
        if let title = title {
            self.title = title
        }
        
        if let message = message {
            self.message = message
        }
        
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        currentvViewController = (viewController == nil) ? rootVC : viewController
        self.sourceView = sourceView
        
        self.popoverPresentationController?.permittedArrowDirections = arrowDirections
    }
    
    fileprivate var currentvViewController : UIViewController?
    fileprivate var handler : ((MSAlert.ActionType?) -> Void)?
    private var sourceView : UIView?
    private var player: AVAudioPlayer?
    
    /// Add new custom alert action.
    /// - parameters:
    ///   - title: The title of the action
    ///   - isDestructive: (_optional_) - The style of the alert action, by default the value is false.
    ///   - image: (_optional_) - The image of the alert action, by default nil (no image)
    ///   - handler: (_optional_) - Completion for the alert action.
    func add(title : String,
             isDestructive : Bool = false,
             image : UIImage? = nil,
             handler : (()->Void)? = nil) -> MSAlert{
        
        
        let customButtonAction = MSAlertAction(actionTitle: title, style: self.isDestructive(isDestructive) , image: image) { _ in
            handler?()
        }
        return self.add(action: customButtonAction)
    }
    
    /// Add new alert action to the action sheet.
    /// - parameters:
    ///   - type: - The type of the alert action
    ///   - title: (_optional_) - The title of the alert action, by default the values from MSActionsSheet.ActionType
    ///   - style: (_optional_) - The style of the alert action, by default the value is .default. If the type of the action sheet is .cancel, and the style is nil, the style will set as .cancel
    ///   - image: (_optional_) - The image of the alert action, by default nil (no image)
    ///   - defaultImage: (_optional_) - The default image based on the type from MSActionsSheet.ActionType
    func add(_ type : ActionType,
             title : String? = nil,
             style : UIAlertActionStyle? = nil,
             image : UIImage? = nil,
             defaultImage : Bool = false) -> MSAlert{
        
        let newTitle : String = (title == nil) ? type.title : title!
        let newImage : UIImage? = defaultImage == true ? type.image : image
        let newStyle : UIAlertActionStyle = (type == .cancel && style == nil) ? .cancel : style == nil ? .default : style!
        
        let action = MSAlertAction(actionTitle: newTitle,
                                   style: newStyle,
                                   image: newImage,
                                   actionType: type,
                                   handler: alertAction)
        
        return self.add(action: action)
    }
    
    /// Set color for the alert
    /// - parameters:
    ///   - color: The tint color of the alert
    func setTint(color : UIColor) -> MSAlert{
        self.view.tintColor = color
        return self
    }
    
    /// Set sound that will play with the alert
    func setSound(from resourceURL : URL) -> MSAlert{
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try? AVAudioSession.sharedInstance().setActive(true)
        player = try? AVAudioPlayer(contentsOf: resourceURL)
        return self
    }
    
    /// Presents the ActionSheet on the view controller.
    /// (Make sure this is the last method called!)
    /// - parameters:
    ///   - completion: (_optional ActionType) The selected alert action.
    func show(completion: ((MSAlert.ActionType?) -> Void)? = nil){
        
        self.handler = completion
        
        if UIDevice.current.userInterfaceIdiom == .pad, let source = sourceView{
            self.popoverPresentationController?.sourceView = source
            self.popoverPresentationController?.sourceRect = source.bounds
        }
        
        if let player = player {
            player.play()
        }
        
        currentvViewController?.present(self, animated: true, completion: nil)
    }
    
    
    private func alertAction(_ action : UIAlertAction){
        
        guard let action = action as? MSAlertAction else {
            return
        }
        
        self.handler?(action.type)
        
    }
    
    private func add(action: MSAlertAction) -> MSAlert{
        self.addAction(action)
        return self
    }
    
    private func isDestructive(_ destructive : Bool) -> UIAlertActionStyle {
        return destructive ? .destructive : .default
    }
    
}




