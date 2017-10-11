//
//  ViewController.swift
//  iOSStep3
//
//  Created by Michel Bouchet on 2017/10/10.
//  Copyright © 2017 Michel Bouchet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    enum appMode {
        case modeOne
        case modeTwo
        case modeThree
    }
    let centerSquare = UIView(),
    highSider = UISlider(), lowSider = UISlider(),
    topLeftSquare = UIView(), topRightSquare = UIView(),
    botmLeftSquare = UIView(), botmRightSquare = UIView(),
    swipeSquare = UIView()
    var modeChoice:UISegmentedControl!,
    allComponents:[UIView]!, currentMode:appMode!,
    leftSwipe,rightSwipe,upSwipe,downSwipe:UISwipeGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGray
        currentMode = .modeOne
        
        modeChoice = UISegmentedControl(items: ["One", "Two", "Three"])
        allComponents = [modeChoice, centerSquare, highSider, lowSider, swipeSquare,
                         topLeftSquare, topRightSquare, botmLeftSquare, botmRightSquare]
        
        for component in allComponents {
            component.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(component)
        }
        
        allComponents.remove(at: 0) // From now on we have another use for this array.
        
        // Let us customize and initialize modeChoice.
        modeChoice.tintColor = UIColor.darkGray
        let attributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 29.0)]
        UISegmentedControl.appearance().setTitleTextAttributes(attributes, for: .normal)
        modeChoice.selectedSegmentIndex = 0
        modeChoice.addTarget(self,
                             action: #selector(choiceSwitcher),
                             for: .valueChanged)
        
        // Let us initialize centerSquare.
        centerSquare.backgroundColor = UIColor.black

        leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
        rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
        upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
        downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        upSwipe.direction = .up
        downSwipe.direction = .down
        
        for gestureRecz in [leftSwipe,rightSwipe,upSwipe,downSwipe] {
            swipeSquare.addGestureRecognizer(gestureRecz!)
        }

        setComponentsLayOut()
        choiceSwitcher() // This is a convenient way to make sure everything is in place.
    }


    func setComponentsLayOut() {
        for component in [modeChoice, highSider, lowSider, centerSquare, swipeSquare] {
            view.addConstraint(NSLayoutConstraint(item: component,
                                                  attribute: .centerX,
                                                  relatedBy: .equal,
                                                  toItem: view,
                                                  attribute: .centerX,
                                                  multiplier: 1.0,
                                                  constant: 0.0))
        }
        
        for component in [highSider, lowSider] {
            view.addConstraint(NSLayoutConstraint(item: component,
                                                  attribute: .width,
                                                  relatedBy: .equal,
                                                  toItem: view,
                                                  attribute: .width,
                                                  multiplier: 0.8,
                                                  constant: 0.0))
        }
        
        view.addConstraints([
            NSLayoutConstraint(item: modeChoice,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: 50.0),
            NSLayoutConstraint(item: lowSider,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: -30.0),
            NSLayoutConstraint(item: highSider,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: lowSider,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: -30.0),
            NSLayoutConstraint(item: centerSquare,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .width,
                               multiplier: 0.8,
                               constant: 0.0),
            NSLayoutConstraint(item: centerSquare,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .centerY,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: centerSquare,
                               attribute: .height,
                               relatedBy: .equal,
                               toItem: centerSquare,
                               attribute: .width,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: swipeSquare,
                               attribute: .width,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .width,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: swipeSquare,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: modeChoice,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: 30.0),
            NSLayoutConstraint(item: swipeSquare,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: view,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: 0.0)
          ])
    }
    
    
    @objc func choiceSwitcher() {
        let neededComponents:[UIView]
        
        switch modeChoice.selectedSegmentIndex {
        case 0:
            currentMode = .modeOne
            neededComponents = [centerSquare, highSider, lowSider]
        case 1:
            currentMode = .modeTwo
            neededComponents = [topLeftSquare, topRightSquare, botmLeftSquare, botmRightSquare,
                                highSider, lowSider]
       case 2:
            currentMode = .modeThree
            neededComponents = [swipeSquare]
            swipeSquare.backgroundColor = UIColor.white
        default:
            neededComponents = []
           break
        }
        
        for component in allComponents {
            if neededComponents.contains(component)
            {component.isHidden = false}
            else {component.isHidden = true}
        }
    }
        
    @objc func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        print(#function)
        switch sender {
        case leftSwipe:
            swipeSquare.backgroundColor = UIColor.green
        case rightSwipe:
            swipeSquare.backgroundColor = UIColor.yellow
        case upSwipe:
            swipeSquare.backgroundColor = UIColor.red
        case downSwipe:
            swipeSquare.backgroundColor = UIColor.blue
        default: // This should never happen.
            swipeSquare.backgroundColor = UIColor.black
        }
    }
}

