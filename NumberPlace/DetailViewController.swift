//
//  DetailViewController.swift
//  NumberPlace
//
//  Created by Hirono Momotaro on 2017/11/07.
//  Copyright © 2017年 Hirono Momotaro. All rights reserved.
//

import UIKit
import KRProgressHUD
import Unbox
import SwiftR

extension UIColor {
    class func lightBlue() -> UIColor {
        return UIColor(red: 92.0 / 255, green: 192.0 / 255, blue: 210.0 / 255, alpha: 1.0)
    }
    
    class func lightRed() -> UIColor {
        return UIColor(red: 195.0 / 255, green: 123.0 / 255, blue: 175.0 / 255, alpha: 1.0)
    }
}

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var numberPlaceCollectionView: UICollectionView!
    @IBOutlet weak var inputNumberCollectionView: UICollectionView!
    
    var selectedCell = NumberCell()
    var cellBorderWidth: CGFloat = 0.7
    var momo: Momo? //Room情報
    var nanpre: Nanpre?
    var connection = SignalR(URLString.SignalRURL)
    var myHub = Hub("myHub")
    
    func configureView() {
        // Update the user interface for the detail item.
//        if let detail = detailItem {
//            if let label = detailDescriptionLabel {
//                label.text = detail.description
//            }
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //SignalR↓========================================
        connection.useWKWebView = true
        connection.signalRVersion = .v2_2_1
        
        self.myHub.on("inputNumber"){ args in
            let id = args![0] as! String
            let number = args![1] as! String
            print("id: \(id)\n number: \(number)")
            
        }
        self.connection.addHub(myHub)
        self.connection.start()
        
        let message = [
            "groupName": "nngo" + String(describing: self.momo?.id)
            ] as [String : Any]
        
        do {
            try self.myHub.invoke("Join", arguments: [message])
            print("Join Success!")
        } catch {
            print(error)
        }

        //SignalR↑========================================
//        numberPlaceCollectionView.register(NumberCell.self, forCellWithReuseIdentifier: "NumberCell")
        numberPlaceCollectionView.delegate = self
        numberPlaceCollectionView.dataSource = self
        inputNumberCollectionView.delegate = self
        inputNumberCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        // Cell一つ一つの大きさ.
        layout.itemSize = CGSize(width:self.view.frame.width / 9, height:self.view.frame.width / 9)
        
        // Cellのマージン.
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 0.0
        inputNumberCollectionView.collectionViewLayout = layout
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        objects.append(NSDate())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func InpuNumber(number:String){
        let indexPath:IndexPath! = self.numberPlaceCollectionView.indexPath(for: selectedCell)!
        let message = [
            "id" : "#trout" + String(describing: (indexPath.row / 9) + 1) + String(describing: (indexPath.row % 9) + 1),
            "number": number,
            "groupName": "nngo" + String(describing: self.momo!.id)
            ] as [String : Any]
        print(String(describing: indexPath.row))
        print(message)

        print("InputNumber Starting")
        
        do {
            try self.myHub.invoke("InputNumber", arguments: [
                "#trout" + String(describing: (indexPath.row / 9) + 1) + String(describing: (indexPath.row % 9) + 1),
                number,
                "nngo" + String(describing: self.momo!.id)
                ] )
            print("InputNumber Success!")
        } catch {
            print(error)
        }
        print("InputNumber Ended")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.numberPlaceCollectionView)
        {
            return 81
        }
        else
        {
            return 9
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (collectionView == self.numberPlaceCollectionView)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NumberCell
            cell.textLabel.textColor = UIColor.blue
            //        cell.layer.borderColor = UIColor.black.cgColor
            //        cell.layer.borderWidth = cellBorderWidth
            cell.layer.addBorder(edge: UIRectEdge.left, color: UIColor.gray, thickness: cellBorderWidth + 1)
            cell.layer.addBorder(edge: UIRectEdge.right, color: UIColor.gray, thickness:cellBorderWidth + 1)
            cell.layer.addBorder(edge: UIRectEdge.top, color: UIColor.gray, thickness: cellBorderWidth + 1)
            cell.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.gray, thickness: cellBorderWidth + 1)
            
            if (indexPath.row % 3 == 0)
            {
                cell.layer.addBorder(edge: UIRectEdge.left, color: UIColor.black, thickness:cellBorderWidth + 2)
            }
            
            if (indexPath.row % 3 == 2)
            {
                cell.layer.addBorder(edge: UIRectEdge.right, color: UIColor.black, thickness:cellBorderWidth + 2)
            }
            
            if ((indexPath.row / 9) % 3 == 0)
            {
                cell.layer.addBorder(edge: UIRectEdge.top, color: UIColor.black, thickness:cellBorderWidth + 2)
            }
            
            if ((indexPath.row / 9) % 3 == 2)
            {
                cell.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness:cellBorderWidth + 2)
            }
            
            if(question![indexPath.row].count > 0 && question![indexPath.row] != "0")
            {
                cell.textLabel.text = question?[indexPath.row]
            }
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "inputCell", for: indexPath) as! NumberCell
            cell.textLabel.textColor = UIColor.blue
            //        cell.layer.borderColor = UIColor.black.cgColor
            //        cell.layer.borderWidth = cellBorderWidth
            cell.layer.addBorder(edge: UIRectEdge.left, color: UIColor.black, thickness: cellBorderWidth + 2)
            cell.layer.addBorder(edge: UIRectEdge.right, color: UIColor.black, thickness:cellBorderWidth + 2)
            cell.layer.addBorder(edge: UIRectEdge.top, color: UIColor.black, thickness: cellBorderWidth + 2)
            cell.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.black, thickness: cellBorderWidth + 2)
            
            cell.textLabel.text = String(indexPath.row + 1)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == self.numberPlaceCollectionView){
            selectedCell = collectionView.cellForItem(at: indexPath) as! NumberCell
        }
        else{
            if (selectedCell.textLabel == nil){
                return
            }
            var index = self.numberPlaceCollectionView.indexPath(for: selectedCell)
            if (question?[(index?.row)!] == "0"){
                let selectedNumber = (collectionView.cellForItem(at: indexPath) as! NumberCell).textLabel.text
                selectedCell.textLabel.text = selectedNumber
                InpuNumber(number: selectedNumber!)
            }
        }
        setCellFormat()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let width: CGFloat = screenWidth / 9 - cellBorderWidth
        let height: CGFloat = width
        return CGSize(width: width, height: height)
    }
    
    func setCellFormat()
    {
        if (selectedCell.textLabel == nil) {
            return
        }
        var indexPath = self.numberPlaceCollectionView.indexPath(for: selectedCell)!
        for cell in self.numberPlaceCollectionView.visibleCells as! [NumberCell] {
            // do something
            //初期化
            cell.textLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            var index = self.numberPlaceCollectionView.indexPath(for: cell)
            var targetRow1:Int!
            var targetRow2:Int!
            var targetColumn1:Int!
            var targetColumn2:Int!
            
            if ((indexPath.row / 9) % 3 == 0){
                targetRow1 = indexPath.row / 9 + 1
                targetRow2 = indexPath.row / 9 + 2
            }
            else if((indexPath.row / 9) % 3 == 1){
                targetRow1 = indexPath.row / 9 - 1
                targetRow2 = indexPath.row / 9 + 1
            }
            else if((indexPath.row / 9) % 3 == 2){
                targetRow1 = indexPath.row / 9 - 1
                targetRow2 = indexPath.row / 9 - 2
            }
            
            if ((indexPath.row % 9) % 3 == 0){
                targetColumn1 = indexPath.row % 9 + 1
                targetColumn2 = indexPath.row % 9 + 2
            }
            else if((indexPath.row % 9) % 3 == 1){
                targetColumn1 = indexPath.row % 9 - 1
                targetColumn2 = indexPath.row % 9 + 1
            }
            else if((indexPath.row % 9) % 3 == 2){
                targetColumn1 = indexPath.row % 9 - 1
                targetColumn2 = indexPath.row % 9 - 2
            }
            
            if (((index?.row)! / 9 == indexPath.row / 9 )
                || ((index?.row)! % 9 == indexPath.row % 9 )
                || (((index?.row)! / 9 == targetRow1 || (index?.row)! / 9 == targetRow2)
                    && ((index?.row)! % 9 == targetColumn1 || (index?.row)! % 9 == targetColumn2))) {
                
                if (selectedCell.textLabel.text != nil
                    && cell != selectedCell
                    && cell.textLabel.text == selectedCell.textLabel.text){
                    cell.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
                    selectedCell.textLabel.textColor = #colorLiteral(red: 1, green: 0.06221962547, blue: 0.07640272677, alpha: 1)
                }
                else{
                    cell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                }
            }
        }
        selectedCell.backgroundColor = #colorLiteral(red: 0.7504016706, green: 1, blue: 0.9755945464, alpha: 1)
    }
    //マージン対策
//    override func viewWillLayoutSubviews() {
//        self.view.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }

    var question: [String]? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    

}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            let extractedExpr = CGRect(x:0, y:0, width:self.frame.height, height:thickness)
            border.frame = extractedExpr
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x:0, y:self.frame.height - thickness, width:UIScreen.main.bounds.width, height:thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x:0, y:0, width:thickness, height:self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x:self.frame.height - thickness, y:0, width:thickness, height:self.frame.height )
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
}

