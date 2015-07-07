//
//  ViewController.swift
//  MyChat
//
//  Created by Humberto Vieira de Castro on 7/6/15.
//  Copyright (c) 2015 Humberto Vieira de Castro. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet var messageTableView: UITableView!
    
    @IBOutlet var viewSend: UIView!
    @IBOutlet var messagesTextField: UITextField!
    
    @IBOutlet var btnSend: UIButton!
    var messagesArray = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tableViewTapped")
        
        self.messagesTextField.addGestureRecognizer(tapGesture)
        
        // Do any additional setup after loading the view, typically from a nib.
        self.messageTableView.dataSource = self
        self.messageTableView.delegate = self
        
        self.messagesTextField.delegate = self
        
        
        
        self.retrieveMessages()
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("retrieveMessages"), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableViewTapped() {
        self.messagesTextField.resignFirstResponder()

    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.messagesTextField.resignFirstResponder()
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Cria a celula
        let cell = self.messageTableView.dequeueReusableCellWithIdentifier("MessageCell") as! UITableViewCell
        
        
        // Altera a célula
        cell.textLabel?.text = self.messagesArray[indexPath.row]
        
        //Retorna a celula
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    @IBAction func clickEnviar(sender: AnyObject) {
        
        self.view.layoutIfNeeded()
        
        //Trava os campos para que não consiga enviar
        self.messagesTextField.enabled = false
        self.btnSend.enabled = false
        
        
        //Envia para o banco
        var newMessageObject:PFObject = PFObject(className: "Message")
        newMessageObject["Text"] = Singleton.sharedInstance.name + ": " + self.messagesTextField.text
        
        newMessageObject.saveInBackgroundWithBlock { (success, error) -> Void in
            
            if (success) {
                println("Mensagem foi inserida")
                
                
                
                
                self.retrieveMessages()
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.messagesTextField.enabled = true
                    self.btnSend.enabled = true
                    self.messagesTextField.text = ""
                }
                
                
            }else{
                println("Mensagem foi NAO inserida")
               
            }
            
            
        }
        
        UIView.animateWithDuration(0.5, animations: {
            self.view.layoutIfNeeded()
            self.messagesTextField.endEditing(true)
            }, completion: nil)
        
    }
    
    func retrieveMessages()
    {
        var query:PFQuery = PFQuery(className: "Message")
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            self.messagesArray = [String]()
            
            for messageObject in objects! {
                let messageString: String = messageObject["Text"] as! String
                
                if messageString != "" {
                    self.messagesArray.append(messageString)
                }
            }
            
            dispatch_async(dispatch_get_main_queue() ){
                self.messageTableView.reloadData()
            }
        }
        
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        animateViewMoving(true, moveValue: 255)
    }
    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
        animateViewMoving(false, moveValue: 255)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        var movementDuration:NSTimeInterval = 0.3
        var movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
}

