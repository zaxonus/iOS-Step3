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
    
    /* We create all the components here. Six of type UIView, two of type UISlider
     and one of type UISegmentedControl. Strictly speaking we only declare the
     UISegmentedControl component and we create it later inside viewDidLoad().
     Beside we also declare a few other (somewhat more abstract) components:
     two of type NSLayoutConstraint and four of type UISwipeGestureRecognizer. */
    let centerSquare = UIView(), centerSquareSizeFactor:CGFloat = 0.9,
    highSider = UISlider(), lowSider = UISlider(),
    topLeftSquare = UIView(), topRightSquare = UIView(),
    botmLeftSquare = UIView(), botmRightSquare = UIView(),
    cornerSquareSizeFactor:CGFloat = 0.46,
    swipeSquare = UIView()
    var modeChoice:UISegmentedControl!, ctrSqWidCons,cornerSqWidCons:NSLayoutConstraint!,
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
        
        // Let us initialize the corner squares (topLeftSquare,topRightSquare,botmLeftSquare,botmRightSquare).
        topLeftSquare.backgroundColor = UIColor.red
        topRightSquare.backgroundColor = UIColor.green
        botmLeftSquare.backgroundColor = UIColor.yellow
        botmRightSquare.backgroundColor = UIColor.blue

        // Let us customize and initialize highSider and lowSider.
        // The default minimum and maximum values are respectively 0.0 ad 1.0.
        highSider.tintColor = UIColor.darkGray
        lowSider.tintColor = UIColor.darkGray
        
        for slider in [highSider, lowSider] {
            slider.addTarget(self, action: #selector(slideHandler(_:)), for: .valueChanged)
        }

        // Let us set up the Swipe Gesture Recognizers.
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

        setComponentsLayOut() // Lay out all the components.
        choiceSwitcher() // This is a convenient way to make sure everything is in place.
    }
    
    
    func centerSquareWidthConstraint(_ multiplyCoef: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: centerSquare,
                                  attribute: .width,
                                  relatedBy: .equal,
                                  toItem: view,
                                  attribute: .width,
                                  multiplier: multiplyCoef,
                                  constant: 0.0)
    }


    func cornerSquareWidthConstraint(_ multiplyCoef: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: topLeftSquare,
                                  attribute: .width,
                                  relatedBy: .equal,
                                  toItem: centerSquare,
                                  attribute: .width,
                                  multiplier: multiplyCoef,
                                  constant: 0.0)
    }
    
    
    func setComponentsLayOut() {
        // This function lays out all the components on the display the way we want them to appear.
        
        for component in [modeChoice, highSider, lowSider, centerSquare, swipeSquare] {
            view.addConstraint(NSLayoutConstraint(item: component,
                                                  attribute: .centerX,
                                                  relatedBy: .equal,
                                                  toItem: view,
                                                  attribute: .centerX,
                                                  multiplier: 1.0,
                                                  constant: 0.0))
        }
        
        for slider in [highSider, lowSider] {
            view.addConstraint(NSLayoutConstraint(item: slider,
                                                  attribute: .width,
                                                  relatedBy: .equal,
                                                  toItem: view,
                                                  attribute: .width,
                                                  multiplier: 0.8,
                                                  constant: 0.0))
        }
        
        let topSpacer = UIView(), botmSpacer = UIView()
        for spacer in [topSpacer, botmSpacer] {
            spacer.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(spacer)
        }

        ctrSqWidCons = centerSquareWidthConstraint(centerSquareSizeFactor)
        
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
            ctrSqWidCons,
            NSLayoutConstraint(item: centerSquare,
                               attribute: .height,
                               relatedBy: .equal,
                               toItem: centerSquare,
                               attribute: .width,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: topSpacer,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: modeChoice,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: topSpacer,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: centerSquare,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: botmSpacer,
                               attribute: .top,
                               relatedBy: .equal,
                               toItem: centerSquare,
                               attribute: .bottom,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: botmSpacer,
                               attribute: .bottom,
                               relatedBy: .equal,
                               toItem: highSider,
                               attribute: .top,
                               multiplier: 1.0,
                               constant: 0.0),
            NSLayoutConstraint(item: topSpacer,
                               attribute: .height,
                               relatedBy: .equal,
                               toItem: botmSpacer,
                               attribute: .height,
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
                               constant: 0.0)])
        
        for component in [topLeftSquare, topRightSquare] {
            view.addConstraint(NSLayoutConstraint(item: component,
                                                  attribute: .top,
                                                  relatedBy: .equal,
                                                  toItem: centerSquare,
                                                  attribute: .top,
                                                  multiplier: 1.0,
                                                  constant: 0.0))
        }
 
        for component in [botmLeftSquare, botmRightSquare] {
            view.addConstraint(NSLayoutConstraint(item: component,
                                                  attribute: .bottom,
                                                  relatedBy: .equal,
                                                  toItem: centerSquare,
                                                  attribute: .bottom,
                                                  multiplier: 1.0,
                                                  constant: 0.0))
        }
        
        for component in [topLeftSquare, botmLeftSquare] {
            view.addConstraint(NSLayoutConstraint(item: component,
                                                  attribute: .left,
                                                  relatedBy: .equal,
                                                  toItem: centerSquare,
                                                  attribute: .left,
                                                  multiplier: 1.0,
                                                  constant: 0.0))
        }

        for component in [topRightSquare, botmRightSquare] {
            view.addConstraint(NSLayoutConstraint(item: component,
                                                  attribute: .right,
                                                  relatedBy: .equal,
                                                  toItem: centerSquare,
                                                  attribute: .right,
                                                  multiplier: 1.0,
                                                  constant: 0.0))
        }
        
        cornerSqWidCons = cornerSquareWidthConstraint(cornerSquareSizeFactor)
        view.addConstraint(cornerSqWidCons)

        for component in [topRightSquare, botmLeftSquare, botmRightSquare] {
            view.addConstraint(NSLayoutConstraint(item: component,
                                                  attribute: .width,
                                                  relatedBy: .equal,
                                                  toItem: topLeftSquare,
                                                  attribute: .width,
                                                  multiplier: 1.0,
                                                  constant: 0.0))
        }
        
        for component in [topLeftSquare, topRightSquare, botmLeftSquare, botmRightSquare] {
            view.addConstraint(NSLayoutConstraint(item: component,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: component,
                                                  attribute: .width,
                                                  multiplier: 1.0,
                                                  constant: 0.0))
        }
    }
    
    
    func initSquare(_ colorIniFlag: Bool) {
        // This function resets all the squares sliders to their initial state.
        view.removeConstraint(ctrSqWidCons)
        ctrSqWidCons = centerSquareWidthConstraint(centerSquareSizeFactor)
        view.addConstraint(ctrSqWidCons)
        view.removeConstraint(cornerSqWidCons)
        cornerSqWidCons = cornerSquareWidthConstraint(cornerSquareSizeFactor)
        view.addConstraint(cornerSqWidCons)
        highSider.value = 0.0
        lowSider.value = 0.0
        
        if !colorIniFlag {
            centerSquare.backgroundColor = UIColor.black
            return
        }
        
        topLeftSquare.backgroundColor = UIColor.red
        topRightSquare.backgroundColor = UIColor.green
        botmLeftSquare.backgroundColor = UIColor.yellow
        botmRightSquare.backgroundColor = UIColor.blue
    }
    
    
    @objc func choiceSwitcher() {
        // This function controls the choice of the app mode (One, Two or Three).
        let neededComponents:[UIView]
        
        switch modeChoice.selectedSegmentIndex {
        case 0:
            currentMode = .modeOne
            neededComponents = [centerSquare, highSider, lowSider]
            initSquare(false)
        case 1:
            currentMode = .modeTwo
            neededComponents = [topLeftSquare, topRightSquare, botmLeftSquare, botmRightSquare,
                                highSider, lowSider]
            initSquare(true)
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
    
    
    @objc func slideHandler(_ sender: UISlider) {
        // This function controls what happens when a component of type UISlider is used.
        switch currentMode {
        case .modeOne:
            if sender == highSider {
                let greyLevel = CGFloat(sender.value)
                centerSquare.backgroundColor = UIColor(red: greyLevel,
                                                       green: greyLevel,
                                                       blue: greyLevel,
                                                       alpha: 1.0)
            } else /*(sender == lowSider)*/ {
                view.removeConstraint(ctrSqWidCons)
                let tempVal = centerSquareSizeFactor - 0.1,
                newConsMultCoef = CGFloat(0.1 + CGFloat(1.0 - sender.value) * tempVal)
                ctrSqWidCons = centerSquareWidthConstraint(newConsMultCoef)
                view.addConstraint(ctrSqWidCons)
            }
        case .modeTwo:
             if sender == highSider {
                topLeftSquare.backgroundColor = UIColor(red: CGFloat(1.0 - sender.value),
                                                        green: CGFloat(sender.value),
                                                        blue: 0.0,
                                                        alpha: 1.0)
                topRightSquare.backgroundColor = UIColor(red: 0.0,
                                                         green: CGFloat(1.0 - sender.value),
                                                         blue: CGFloat(sender.value),
                                                         alpha: 1.0)
                botmRightSquare.backgroundColor = UIColor(red: CGFloat(sender.value),
                                                          green: CGFloat(sender.value),
                                                          blue: CGFloat(1.0 - sender.value),
                                                          alpha: 1.0)
                botmLeftSquare.backgroundColor = UIColor(red: 1.0,
                                                         green: CGFloat(1.0 - sender.value),
                                                         blue: 0.0,
                                                         alpha: 1.0)
            } else /*(sender == lowSider)*/ {
                view.removeConstraint(cornerSqWidCons)
                let tempVal = cornerSquareSizeFactor - 0.1,
                newConsMultCoef = CGFloat(0.1 + CGFloat(1.0 - sender.value) * tempVal)
                cornerSqWidCons = cornerSquareWidthConstraint(newConsMultCoef)
                view.addConstraint(cornerSqWidCons)
            }
        case .modeThree: fallthrough
        default:
            break
        }
    }
    
    
    @objc func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        // This function controls what happens when a swipe is made.
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

