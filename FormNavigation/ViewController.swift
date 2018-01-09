//
//  ViewController.swift
//  FormNavigation
//
//  Created by Alex Antonyuk on 1/4/18.
//  Copyright © 2018 Alex Antonyuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var textView: UITextView!
    let navigator = FormNavigator()

    override func viewDidLoad() {
        super.viewDidLoad()


        textFields.forEach { tf in
            self.navigator.add(control: tf)
        }
        navigator.add(control: textView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigator.updateToolbarWidth(view.bounds.width)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

