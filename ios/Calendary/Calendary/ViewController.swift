//
//  ViewController.swift
//  Calendary
//
//  Created by 김기현 on 23/08/2019.
//  Copyright © 2019 김기현. All rights reserved.
//

import UIKit
import FSCalendar

class ViewController: UIViewController {
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        editButton.layer.cornerRadius = 35
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addDiary" {
            let addDiaryViewContollrer = segue.destination as? AddDiaryViewController
            addDiaryViewContollrer?.date = calendar.selectedDate ?? Date()
        }
    }

}

