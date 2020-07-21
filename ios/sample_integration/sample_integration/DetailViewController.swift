//
//  DetailViewController.swift
//  sample_integration
//
//  Created by Eric Lanz on 6/4/20.
//  Copyright © 2020 Embrace. All rights reserved.
//

import UIKit
import Embrace

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!


    func configureView() {
        // Update the user interface for the detail item.
        guard let detail = detailItem else { return }
        guard let label = detailDescriptionLabel else { return }
        label.text = detail.description
    }
    
    // EMBRACE HINT:
    // Here we are again using the light weight breadcrumb event to track navigation in our application
    // Notice we've implemented viewWillDisappear solely for this purpose.  It is important to find
    // Navigation and branching points that your users care about and ensure you have breadcrumbs for
    // those events, even if that means adding API to ensure you capture them.
    override func viewWillDisappear(_ animated: Bool) {
        let msg = String(format: "Returning from detail page for: \(String(describing: self.detailItem))")
        Embrace.sharedInstance().logBreadcrumb(withMessage: msg)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    var detailItem: Date? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

