//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by iDeveloper on 17/07/16.
//  Copyright © 2016 iDeveloper. All rights reserved.
//

import UIKit
import Messages

import StoreKit


class MessagesViewController: MSMessagesAppViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
//    var list = [SKProduct]()
//    var p = SKProduct()
//    let inpp_strId = "com.kreate.DoggieSticker.allunlockdogs"
    let inpp_strId = "com.kreate.DoggieSticker.allunlock"
    
    var products = [SKProduct]()
    
    let kHappieDog = "kHappieDog"
    let kSickDog = "kSickDog"
    let kDirtyDog = "kDirtyDog"
    let kOldDog = "kOldDog"
    let kLoveDog = "kLoveDog"
    
    var g_bUnlockHappieDog : Bool = false
    var g_bUnlockSickDog : Bool = false
    var g_bUnlockDirtyDog : Bool = false
    var g_bUnlockOldDog : Bool = false
    var g_bUnlockLoveDog : Bool = false
    
    var g_bSendingHappieDog : Bool = false
    var g_bSendingSickDog : Bool = false
    var g_bSendingDirtyDog : Bool = false
    var g_bSendingOldDog : Bool = false
    var g_bSendingLoveDog : Bool = false
    
    let nHappieDogTag : Int = 10
    let nSickDogTag : Int = 11
    let nDirtyDogTag : Int = 12
    let nOldDogTag : Int = 13
    let nLoveDogTag : Int = 14
    
    var sizeSticker : CGSize = CGSize.zero
    var imgList = [UIImageView]()
    var menupScrollContentList = [MenuPoint]()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var constCotentH: NSLayoutConstraint!
    @IBOutlet weak var consContentW: NSLayoutConstraint!
    
    @IBOutlet weak var restoreButton: UIButton!
    
    var tapGestureItem: UITapGestureRecognizer! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        load()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.handlePurchaseNotification(_:)),
                                               name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                               object: nil)
        
        scrollView.isUserInteractionEnabled = true
        scrollView.delegate = self
//        consContentW.constant = self.view.frame.size.width
        
        tapGestureItem = UITapGestureRecognizer(target: self, action: #selector(onClickScrollItem(_:)))
        tapGestureItem.delegate = self
        scrollView.addGestureRecognizer(tapGestureItem)
        
        sizeSticker = CGSize(width: (self.view.frame.size.width - 100)/3 , height: (self.view.frame.size.width - 100)/3)
        
        drawInit()
        
        constCotentH.constant = sizeSticker.height * CGFloat( imgList.count / 3 + 1) + 10.0 + 35.0 * CGFloat( imgList.count / 3 + 1)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reload()
    }
    
    @IBAction func restorePurchase()
    {
//        if (SKPaymentQueue.canMakePayments()) {
//            SKPaymentQueue.default().restoreCompletedTransactions()
//        }
    }
    
    func drawInit()
    {
        for i in 0...10
        {
            var url = Bundle.main.url(forResource: "0\(i+1)", withExtension: "gif")
            if i == 6
            {
                url = Bundle.main.url(forResource: "Dogfinal2tails2", withExtension: "gif")
            }
            if i == 7
            {
                url = Bundle.main.url(forResource: "1", withExtension: "gif")
            }
            if i == 8
            {
                url = Bundle.main.url(forResource: "2", withExtension: "gif")
            }
            if i == 9
            {
                url = Bundle.main.url(forResource: "3", withExtension: "gif")
            }
            if i == 10
            {
                url = Bundle.main.url(forResource: "4", withExtension: "gif")
            }
            let imgView = UIImageView()
            imgView.image = UIImage.animatedImage(withAnimatedGIFURL: url!)
            
            if i < 3
            {
                imgView.frame = CGRect(x: CGFloat( 35 * (i + 1) ) + sizeSticker.width * CGFloat( i ),
                                       y: CGFloat( 5 * (i/3 + 1) ) + sizeSticker.width * CGFloat( i/3 + 50),
                                       width: sizeSticker.width,
                                       height: sizeSticker.height)
            }
            else
            {
                imgView.frame = CGRect(x: CGFloat( 35 * (i%3 + 1) ) + sizeSticker.width * CGFloat( i%3),
                                       y: CGFloat( 35 * (i/3 + 1) ) + sizeSticker.width * CGFloat( i/3 + 50),
                                       width: sizeSticker.width,
                                       height: sizeSticker.height)
            }
            
            self.contentView.addSubview(imgView)
            
            let menuPoint = MenuPoint()
            menuPoint.rec = imgView.frame
            menuPoint.img = imgView
            menuPoint.imgUrl = url
            menuPoint.nOrder = i
            
            menupScrollContentList.append(menuPoint)
            
            imgList.append(imgView)
            if i == 6
            {
                getHappieDog()
                if g_bUnlockHappieDog == false
                {
                    if imgList.count > 0
                    {
                        for j in 0...imgList.count-1
                        {
                            if imgList[j].tag == nHappieDogTag
                            {
                                imgList[j].removeFromSuperview()
                                imgList.remove(at: j)
                            }
                        }
                    }
                    
                    
                    let imgViewHappie = UIImageView()
                    imgViewHappie.image = UIImage(named: "play_lock.png")
                    imgViewHappie.frame = imgView.frame
                    imgViewHappie.tag = nHappieDogTag
                    self.contentView.addSubview(imgViewHappie)
                    
                    imgList.append(imgViewHappie)
                }
                else
                {
                    if imgList.count > 0
                    {
                        for j in 0...imgList.count-1
                        {
                            if imgList[j].tag == nHappieDogTag
                            {
                                imgList[j].removeFromSuperview()
                                imgList.remove(at: j)
                            }
                        }
                    }
                }
            }

            if i == 7
            {
                getSickDog()
                if g_bUnlockSickDog == false
                {
                    if imgList.count > 0
                    {
                        for j in 0...imgList.count-1
                        {
                            if imgList[j].tag == nSickDogTag
                            {
                                imgList[j].removeFromSuperview()
                                imgList.remove(at: j)
                            }
                        }
                    }
                    
                    
                    let imgViewHappie = UIImageView()
                    imgViewHappie.image = UIImage(named: "play_lock.png")
                    imgViewHappie.frame = imgView.frame
                    imgViewHappie.tag = nSickDogTag
                    self.contentView.addSubview(imgViewHappie)
                    
                    imgList.append(imgViewHappie)
                }
                else
                {
                    if imgList.count > 0
                    {
                        for j in 0...imgList.count-1
                        {
                            if imgList[j].tag == nSickDogTag
                            {
                                imgList[j].removeFromSuperview()
                                imgList.remove(at: j)
                            }
                        }
                    }
                }
            }
            
            if i == 8
            {
                getDirtyDog()
                if g_bUnlockDirtyDog == false
                {
                    if imgList.count > 0
                    {
                        for j in 0...imgList.count-1
                        {
                            if imgList[j].tag == nDirtyDogTag
                            {
                                imgList[j].removeFromSuperview()
                                imgList.remove(at: j)
                            }
                        }
                    }
                    
                    
                    let imgViewHappie = UIImageView()
                    imgViewHappie.image = UIImage(named: "play_lock.png")
                    imgViewHappie.frame = imgView.frame
                    imgViewHappie.tag = nDirtyDogTag
                    self.contentView.addSubview(imgViewHappie)
                    
                    imgList.append(imgViewHappie)
                }
                else
                {
                    if imgList.count > 0
                    {
                        for j in 0...imgList.count-1
                        {
                            if imgList[j].tag == nDirtyDogTag
                            {
                                imgList[j].removeFromSuperview()
                                imgList.remove(at: j)
                            }
                        }
                    }
                }
            }
            
            if i == 9
            {
                getOldDog()
                if g_bUnlockOldDog == false
                {
                    if imgList.count > 0
                    {
                        for j in 0...imgList.count-1
                        {
                            if imgList[j].tag == nOldDogTag
                            {
                                imgList[j].removeFromSuperview()
                                imgList.remove(at: j)
                            }
                        }
                    }
                    
                    
                    let imgViewHappie = UIImageView()
                    imgViewHappie.image = UIImage(named: "play_lock.png")
                    imgViewHappie.frame = imgView.frame
                    imgViewHappie.tag = nOldDogTag
                    self.contentView.addSubview(imgViewHappie)
                    
                    imgList.append(imgViewHappie)
                }
                else
                {
                    if imgList.count > 0
                    {
                        for j in 0...imgList.count-1
                        {
                            if imgList[j].tag == nOldDogTag
                            {
                                imgList[j].removeFromSuperview()
                                imgList.remove(at: j)
                            }
                        }
                    }
                }
            }
            
            if i == 10
            {
                getLoveDog()
                if g_bUnlockLoveDog == false
                {
                    if imgList.count > 0
                    {
                        for j in 0...imgList.count-1
                        {
                            if imgList[j].tag == nLoveDogTag
                            {
                                imgList[j].removeFromSuperview()
                                imgList.remove(at: j)
                            }
                        }
                    }
                    
                    
                    let imgViewHappie = UIImageView()
                    imgViewHappie.image = UIImage(named: "play_lock.png")
                    imgViewHappie.frame = imgView.frame
                    imgViewHappie.tag = nLoveDogTag
                    self.contentView.addSubview(imgViewHappie)
                    
                    imgList.append(imgViewHappie)
                }
                else
                {
                    if imgList.count > 0
                    {
                        for j in 0...imgList.count-1
                        {
                            if imgList[j].tag == nLoveDogTag
                            {
                                imgList[j].removeFromSuperview()
                                imgList.remove(at: j)
                            }
                        }
                    }
                }
            }
            
            //
        }
    }
    
    func reload() {
        products = []
        RageProducts.store.requestProducts{success, products in
            if success {
                self.products = products!

//                self.onClickScrollItem(self.tapGestureItem)

            }
        }
    }
    
    func handlePurchaseNotification(_ notification: Notification) {
        guard let productID = notification.object as? String else { return }
        
        var imgListTempCount = 0
        
        for (_, product) in products.enumerated() {
            guard product.productIdentifier == productID else { continue }
            
            g_bUnlockHappieDog = true
            setHappieDog()
            
            g_bUnlockSickDog = true
            setSickDog()
            
            g_bUnlockDirtyDog = true
            setDirtyDog()

            g_bUnlockOldDog = true
            setOldDog()
            
            g_bUnlockLoveDog = true
            setLoveDog()

//            g_bUnlockHappieDog = true
//            setHappieDog()
            if imgList.count > 0
            {
                imgListTempCount = imgList.count
                
                for j in 0...imgList.count - 2
                {
                    if imgList[j].tag == nHappieDogTag
                    {
                        imgList[j].removeFromSuperview()
                        imgList.remove(at: j)
                    }
                }
                
                if imgListTempCount == imgList.count
                {
                    imgList[imgListTempCount - 1].removeFromSuperview()
                    imgList.remove(at: imgListTempCount - 1)
                }
            }
            
//            g_bUnlockSickDog = true
//            setSickDog()
            if imgList.count > 0
            {
                imgListTempCount = imgList.count
                for j in 0...imgList.count - 2
                {
                    if imgList[j].tag == nSickDogTag
                    {
                        imgList[j].removeFromSuperview()
                        imgList.remove(at: j)
                    }
                }
                
                if imgListTempCount == imgList.count
                {
                    imgList[imgListTempCount - 1].removeFromSuperview()
                    imgList.remove(at: imgListTempCount - 1)
                }
            }
            
//            g_bUnlockDirtyDog = true
//            setDirtyDog()
            if imgList.count > 0
            {
                imgListTempCount = imgList.count
                for j in 0...imgList.count - 2
                {
                    if imgList[j].tag == nDirtyDogTag
                    {
                        imgList[j].removeFromSuperview()
                        imgList.remove(at: j)
                    }
                }
                
                if imgListTempCount == imgList.count
                {
                    imgList[imgListTempCount - 1].removeFromSuperview()
                    imgList.remove(at: imgListTempCount - 1)
                }
            }
            
//            g_bUnlockOldDog = true
//            setOldDog()
            if imgList.count > 0
            {
                imgListTempCount = imgList.count
                for j in 0...imgList.count - 2
                {
                    if imgList[j].tag == nOldDogTag
                    {
                        imgList[j].removeFromSuperview()
                        imgList.remove(at: j)
                    }
                }
                
                if imgListTempCount == imgList.count
                {
                    imgList[imgListTempCount - 1].removeFromSuperview()
                    imgList.remove(at: imgListTempCount - 1)
                }
            }
            
//            g_bUnlockLoveDog = true
//            setLoveDog()
            if imgList.count > 0
            {
                imgListTempCount = imgList.count
                for j in 0...imgList.count - 2
                {
                    if imgList[j].tag == nLoveDogTag
                    {
                        imgList[j].removeFromSuperview()
                        imgList.remove(at: j)
                    }
                }
                
                if imgListTempCount == imgList.count
                {
                    imgList[imgListTempCount - 1].removeFromSuperview()
                    imgList.remove(at: imgListTempCount - 1)
                }
            }

            drawInit()
        }
    }
    
    func onClickScrollItem(_ sender: UIGestureRecognizer)
    {
        let touchPoint : CGPoint = sender.location(in: scrollView)
//      print("touchpoint x : \(touchPoint.x) touchpoint y : \(touchPoint.y)")
        
        if menupScrollContentList.count > 0
        {
            for i in 0...menupScrollContentList.count-1
            {
                let imgCV = menupScrollContentList[i]
                
                if (imgCV.img.frame.contains(touchPoint))
//                if (true)
                {
                    print(imgCV.nOrder)
                    
                    if imgCV.nOrder == 6
                    {
                        getHappieDog()
                        if g_bUnlockHappieDog == true
                        {
                            if let conversation = activeConversation {
                                
                                do {
                                    let sticker = try MSSticker(contentsOfFileURL: imgCV.imgUrl!, localizedDescription: "")
                                    conversation.insert(sticker, completionHandler: { (erros) in
                                        print(erros)
                                        if erros == nil
                                        {
                                            self.g_bSendingHappieDog = true
                                        }
                                    })
                                    
                                } catch {
                                    print(error)
                                }
                            }
                        }
                        else
                        {
                            buyItem(inpp_strId)
                        }
                    }
                    else if imgCV.nOrder == 7
                    {
                        getSickDog()
                        if g_bUnlockSickDog == true
                        {
                            if let conversation = activeConversation {
                                
                                do {
                                    let sticker = try MSSticker(contentsOfFileURL: imgCV.imgUrl!, localizedDescription: "")
                                    conversation.insert(sticker, completionHandler: { (erros) in
                                        print(erros)
                                        if erros == nil
                                        {
                                            self.g_bSendingSickDog = true
                                        }
                                    })
                                    
                                } catch {
                                    print(error)
                                }
                            }
                        }
                        else
                        {
                            buyItem(inpp_strId)
                        }
                    }
                    else if imgCV.nOrder == 8
                    {
                        getDirtyDog()
                        if g_bUnlockDirtyDog == true
                        {
                            if let conversation = activeConversation {
                                
                                do {
                                    let sticker = try MSSticker(contentsOfFileURL: imgCV.imgUrl!, localizedDescription: "")
                                    conversation.insert(sticker, completionHandler: { (erros) in
                                        print(erros)
                                        if erros == nil
                                        {
                                            self.g_bSendingDirtyDog = true
                                        }
                                    })
                                    
                                } catch {
                                    print(error)
                                }
                            }
                        }
                        else
                        {
                            buyItem(inpp_strId)
                        }
                    }
                    else if imgCV.nOrder == 9
                    {
                        getOldDog()
                        if g_bUnlockOldDog == true
                        {
                            if let conversation = activeConversation {
                                
                                do {
                                    let sticker = try MSSticker(contentsOfFileURL: imgCV.imgUrl!, localizedDescription: "")
                                    conversation.insert(sticker, completionHandler: { (erros) in
                                        print(erros)
                                        if erros == nil
                                        {
                                            self.g_bSendingOldDog = true
                                        }
                                    })
                                    
                                } catch {
                                    print(error)
                                }
                            }
                        }
                        else
                        {
                            buyItem(inpp_strId)
                        }
                    }
                    else if imgCV.nOrder == 10
                    {
                        getLoveDog()
                        if g_bUnlockLoveDog == true
                        {
                            if let conversation = activeConversation {
                                
                                do {
                                    let sticker = try MSSticker(contentsOfFileURL: imgCV.imgUrl!, localizedDescription: "")
                                    conversation.insert(sticker, completionHandler: { (erros) in
                                        print(erros)
                                        if erros == nil
                                        {
                                            self.g_bSendingLoveDog = true
                                        }
                                    })
                                    
                                } catch {
                                    print(error)
                                }
                            }
                        }
                        else
                        {
                            buyItem(inpp_strId)
                        }
                    }
                    else
                    {
                        if let conversation = activeConversation {
                            
                            do {
                                let sticker = try MSSticker(contentsOfFileURL: imgCV.imgUrl!, localizedDescription: "")
                                conversation.insert(sticker, completionHandler: { (erros) in
                                    print(erros)
                                })
                                
                            } catch {
                                print(error)
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
//    func numberOfStickers(in stickerBrowserView: MSStickerBrowserView) -> Int {
//        return stickers.count
//    }
//    
//    func stickerBrowserView(_ stickerBrowserView: MSStickerBrowserView, stickerAt index: Int) -> MSSticker {
//        return stickers[index]
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
        if g_bSendingHappieDog || g_bSendingSickDog || g_bSendingDirtyDog
        {
            g_bSendingHappieDog = false
            g_bUnlockHappieDog = false
            setHappieDog()
            
            g_bSendingSickDog = false
            g_bUnlockSickDog = false
            setSickDog()
            
            g_bSendingDirtyDog = false
            g_bUnlockDirtyDog = false
            setDirtyDog()
            
            g_bSendingOldDog = false
            g_bUnlockOldDog = false
            setOldDog()
            
            g_bSendingLoveDog = false
            g_bUnlockLoveDog = false
            setLoveDog()
            
            drawInit()
        }
        
        
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }
    
    
    
    //MARK: in-app
    
    
//    func initPayment()
//    {
//        if(SKPaymentQueue.canMakePayments()) {
//            print("IAP is enabled, loading")
//            let productID:NSSet = NSSet(objects: inpp_strId)
//            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
//            
//            request.delegate = self
//            request.start()
//        } else {
//            print("please enable IAPS")
//        }
//    }
//    
    func buyItem(_ strItem: String) {
        for i in 0...products.count-1
        {
            let product = products[i]
            let prodID = product.productIdentifier
            if(prodID == strItem) {
                RageProducts.store.buyProduct(product)
                break;
            }
        }
    }
//
//    func buyProduct() {
//        print("buy " + p.productIdentifier)
//        let pay = SKPayment(product: p)
//        SKPaymentQueue.default().add(self)
//        SKPaymentQueue.default().add(pay as SKPayment)
//    }
//    
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        print("product request")
//        let myProduct = response.products
//        if list.count > 0
//        {
//            list.removeAll()
//        }
//        for product in myProduct {
//            print("product added")
//            print(product.productIdentifier)
//            print(product.localizedTitle)
//            print(product.localizedDescription)
//            print(product.price)
//            
//            list.append(product )
//        }
//        
//    }
//    
//    
//    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
//        print("transactions restored")
//        
//        for transaction in queue.transactions {
//            let t: SKPaymentTransaction = transaction
//            
//            let prodID = t.payment.productIdentifier as String
//            
//            
//        }
//    }
//    
//    
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        print("add payment")
//        
//        for transaction:AnyObject in transactions {
//            let trans = transaction as! SKPaymentTransaction
//            print(trans.error)
//            
//            switch trans.transactionState {
//                
//            case .purchased:
//                print("buy, ok unlock iap here")
//                print(p.productIdentifier)
//                
//                let prodID = p.productIdentifier as String
//                switch prodID {
//                case inpp_strId:
//                    print("inapp all")
//                    g_bUnlockHappieDog = true
//                    setHappieDog()
//                    if imgList.count > 0
//                    {
//                        for j in 0...imgList.count-1
//                        {
//                            if imgList[j].tag == nHappieDogTag
//                            {
//                                imgList[j].removeFromSuperview()
//                                imgList.remove(at: j)
//                            }
//                        }
//                    }
//                    
//                    g_bUnlockSickDog = true
//                    setSickDog()
//                    if imgList.count > 0
//                    {
//                        for j in 0...imgList.count-1
//                        {
//                            if imgList[j].tag == nSickDogTag
//                            {
//                                imgList[j].removeFromSuperview()
//                                imgList.remove(at: j)
//                            }
//                        }
//                    }
//                    
//                    g_bUnlockDirtyDog = true
//                    setDirtyDog()
//                    if imgList.count > 0
//                    {
//                        for j in 0...imgList.count-1
//                        {
//                            if imgList[j].tag == nDirtyDogTag
//                            {
//                                imgList[j].removeFromSuperview()
//                                imgList.remove(at: j)
//                            }
//                        }
//                    }
//                    
//                    g_bUnlockOldDog = true
//                    setOldDog()
//                    if imgList.count > 0
//                    {
//                        for j in 0...imgList.count-1
//                        {
//                            if imgList[j].tag == nOldDogTag
//                            {
//                                imgList[j].removeFromSuperview()
//                                imgList.remove(at: j)
//                            }
//                        }
//                    }
//                    
//                    g_bUnlockLoveDog = true
//                    setLoveDog()
//                    if imgList.count > 0
//                    {
//                        for j in 0...imgList.count-1
//                        {
//                            if imgList[j].tag == nLoveDogTag
//                            {
//                                imgList[j].removeFromSuperview()
//                                imgList.remove(at: j)
//                            }
//                        }
//                    }
//
//                default:
//                    print("IAP not setup")
//                }
//                
//                queue.finishTransaction(trans)
//                break;
//            case .failed:
//                print("buy error")
//                queue.finishTransaction(trans)
//                break;
//            default:
//                print("default")
//                break;
//                
//            }
//        }
//    }
//    
//    func finishTransaction(_ trans:SKPaymentTransaction)
//    {
//        print("finish trans")
//        SKPaymentQueue.default().finishTransaction(trans)
//    }
//    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction])
//    {
//        print("remove trans");
//    }
    
    func load()
    {
        let userDefault = UserDefaults.standard
        let bLoad : Bool = userDefault.bool(forKey: "DoggieSticker_2017")
        if ( !bLoad )
        {
            userDefault.set(true, forKey: "DoggieSticker_2017")
            g_bUnlockHappieDog = false
            userDefault.set(g_bUnlockHappieDog, forKey: kHappieDog)
            
            g_bUnlockSickDog = false
            userDefault.set(g_bUnlockSickDog, forKey: kSickDog)
            
            g_bUnlockDirtyDog = false
            userDefault.set(g_bUnlockDirtyDog, forKey: kDirtyDog)
            
            g_bUnlockOldDog = false
            userDefault.set(g_bUnlockOldDog, forKey: kOldDog)
            
            g_bUnlockLoveDog = false
            userDefault.set(g_bUnlockLoveDog, forKey: kLoveDog)
            
            userDefault.synchronize()
        }
        else
        {
            
            g_bUnlockHappieDog = userDefault.bool(forKey: kHappieDog)
            g_bUnlockSickDog = userDefault.bool(forKey: kSickDog)
            g_bUnlockDirtyDog = userDefault.bool(forKey: kDirtyDog)
            g_bUnlockOldDog = userDefault.bool(forKey: kOldDog)
            g_bUnlockLoveDog = userDefault.bool(forKey: kLoveDog)
            
        }
        
    }
    
    func setHappieDog()
    {
        let userDefault = UserDefaults.standard
        userDefault.set(g_bUnlockHappieDog, forKey: kHappieDog)
        userDefault.synchronize()
    }
    
    func getHappieDog()
    {
        let userDefault = UserDefaults.standard
        g_bUnlockHappieDog = userDefault.bool(forKey: kHappieDog)
    }
    
    func setSickDog()
    {
        let userDefault = UserDefaults.standard
        userDefault.set(g_bUnlockSickDog, forKey: kSickDog)
        userDefault.synchronize()
    }
    
    func getSickDog()
    {
        let userDefault = UserDefaults.standard
        g_bUnlockSickDog = userDefault.bool(forKey: kSickDog)
    }
    
    func setDirtyDog()
    {
        let userDefault = UserDefaults.standard
        userDefault.set(g_bUnlockDirtyDog, forKey: kDirtyDog)
        userDefault.synchronize()
    }
    
    func getDirtyDog()
    {
        let userDefault = UserDefaults.standard
        g_bUnlockDirtyDog = userDefault.bool(forKey: kDirtyDog)
    }
    
    func setOldDog()
    {
        let userDefault = UserDefaults.standard
        userDefault.set(g_bUnlockOldDog, forKey: kOldDog)
        userDefault.synchronize()
    }
    
    func getOldDog()
    {
        let userDefault = UserDefaults.standard
        g_bUnlockOldDog = userDefault.bool(forKey: kOldDog)
    }
    
    func setLoveDog()
    {
        let userDefault = UserDefaults.standard
        userDefault.set(g_bUnlockLoveDog, forKey: kLoveDog)
        userDefault.synchronize()
    }
    
    func getLoveDog()
    {
        let userDefault = UserDefaults.standard
        g_bUnlockLoveDog = userDefault.bool(forKey: kLoveDog)
    }

}
