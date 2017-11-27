//
//  MasterViewController.swift
//  NumberPlace
//
//  Created by Hirono Momotaro on 2017/11/07.
//  Copyright © 2017年 Hirono Momotaro. All rights reserved.
//

import UIKit
import Unbox
import KRProgressHUD

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
//    var objects = [Any]()
    var inAnsewerList:[Momo] = []
    var question:[String] = []
    @IBOutlet var IndexView: UITableView!
    var refreshButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // UIBarButtonItemに表示文字列を渡して、インスタンス化します。
        refreshButton = UIBarButtonItem.init(title: "更新ボタンやで", style: .plain, target: self,action: #selector(self.refreshNanpreIndex))
//        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem = refreshButton
//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
//        navigationItem.rightBarButtonItem = addButton
//        if let split = splitViewController {
//            let controllers = split.viewControllers
//            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
//        objects.append(NSDate())
        getData()
//        getnanpreData()
        super.viewWillAppear(animated)
    }
    
    // ボタンをタップしたときのアクション
    @objc func refreshNanpreIndex() {
        viewWillAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func insertNewObject(_ sender: Any) {
//        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                getnanpreData(momo_id: self.inAnsewerList[indexPath.row].id)
                
//                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
//                controller.question = self.question
//                controller.numberPlaceCollectionView.reloadData()
                
                controller.question = self.question
                controller.momo = self.inAnsewerList[indexPath.row]
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return objects.count
        return inAnsewerList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NanpreIndexCustomCell
 
//        let object = objects[indexPath.row] as! NSDate
//        cell.textLabel!.text = object.description
        let obj = inAnsewerList[indexPath.row]
        cell.textLabel!.text = obj.Title
        cell.lblRoomNO.text = "ナンプレルーム：" + String(obj.id)
        cell.lblNanpreNO.text = "ナンプレNO：" + String(obj.NanpreNO)
        return cell
    }

//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
////            objects.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
//    }

    func getData() {
        KRProgressHUD.show()
        let url = URLComponents(string: URLString.SelectIndexListURL)!
        let task = URLSession.shared.dataTask(with: url.url!){ data, response, error in
            if let data = data {
                do {
                    print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
                    let momosDic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Array<Dictionary<String, AnyObject>>
//                    let json: [Momo] = try unbox(data: data)
                    
                    // tasksToShow配列を空にする。（同じデータを複数表示しないため）
                    self.inAnsewerList.removeAll()
                    
                    for momo in momosDic  {
                        var inAnswer:Momo = Momo()
                        if(momo.keys.contains("id")){
                            inAnswer.id = momo["id"]! as! Int
                        }
                        else{
                            inAnswer.id = momo["ID"]! as! Int
                        }
                        
                        inAnswer.NanpreNO = momo["NanpreNO"]! as! Int
                        inAnswer.MakeUserID = momo["MakeUserID"]! as! String
                        inAnswer.IsCleared = momo["IsCleared"]! as! Bool
                        inAnswer.Title = momo["Title"]! as! String
                        inAnswer.IsPublic = momo["IsPublic"]! as! Bool
                        inAnswer.Remarks = momo["Remarks"]! as! String
                        self.inAnsewerList.append(inAnswer)
                    }
                    
//                    for question in json  {
//                        self.inAnsewerList.append(question)
//                    }
                    // taskTableViewを再読み込みする
                    //                    self.taskTableView.reloadData()
                    
                    DispatchQueue.main.async {
                        self.IndexView.reloadData()
                    }
                    
                } catch {
                    print("Serialize Error")
                }
            } else {
                print(error ?? "Error")
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            KRProgressHUD.dismiss()
        }
        task.resume()

    }
    
    func getnanpreData(momo_id:Int) {
//        KRProgressHUD.show()
        let parsedData: [String : Any] = HttpRequestController().sendGetRequestSynchronous(urlString: URLString.SelectQuestionURL(momo_id: momo_id))
        print(parsedData)
        self.question = String(describing: parsedData["question"]!).map { String($0) }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            KRProgressHUD.dismiss()
        }
    }

}

