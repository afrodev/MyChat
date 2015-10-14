//
//  IdentificacaoViewController.swift
//  MyChat
//
//  Created by Humberto Vieira de Castro on 7/7/15.
//  Copyright (c) 2015 Humberto Vieira de Castro. All rights reserved.
//

import UIKit

class IdentificacaoViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var txtNome: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtNome.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.txtNome.resignFirstResponder()
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        self.txtNome.resignFirstResponder()
        return true;
    }
    
    
    @IBAction func clickEntrar(sender: AnyObject) {
        if (txtNome.text == nil || txtNome.text == "") {
            let alertController = UIAlertController(title: "Digite um nome carai!", message: "Não foi colocado um nome", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        } else {
            Singleton.sharedInstance.name = self.txtNome.text
            performSegueWithIdentifier("segueChat", sender: sender)
            
//            let vc:AnyObject? = self.storyboard?.instantiateViewControllerWithIdentifier("ChatViewController")
//            self.presentViewController(vc as! UIViewController , animated: true, completion: nil)
            
        }
        
        
    }

    @IBOutlet var btnEntrar: UIButton!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
