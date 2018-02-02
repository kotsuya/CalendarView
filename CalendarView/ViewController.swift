//
//  ViewController.swift
//  CalendarView
//
//  Created by YooSeunghwan on 2018/01/16.
//  Copyright © 2018年 YooSeunghwan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var headerPrevBtn: UIButton!
    @IBOutlet weak var headerNextBtn: UIButton!
    
    @IBOutlet weak var headerTitle: UILabel!
    
    @IBOutlet weak var calenderHeaderView: UIView!
    @IBOutlet weak var calenderCollectionView: UICollectionView!
    @IBOutlet weak var calenderFooterView: UIView!
    
    @IBOutlet weak var footerLabel: UILabel!
    
    let dateManager = DataManager()
    let daysPerWeek: Int = 7
    let cellMargin: CGFloat = 2.0
    var selectedDate = Date()
    var today: Date!
    let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        calenderCollectionView.dataSource = self
        calenderCollectionView.delegate = self
        
        headerTitle.text = changeHeaderTitle(selectedDate)
        
        footerLabel.text = "english"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeHeaderTitle(_ date: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "M/yyyy"
        let selectMonth = formatter.string(from: date)
        return selectMonth
    }
    
    @IBAction func tappedHeaderPrevBtn(_ sender: Any) {
        selectedDate = dateManager.prevMonth(selectedDate)
        calenderCollectionView.reloadData()
        headerTitle.text = changeHeaderTitle(selectedDate)
    }
    
    @IBAction func tappedHeaderNextBtn(_ sender: Any) {
        selectedDate = dateManager.nextMonth(selectedDate)
        calenderCollectionView.reloadData()
        headerTitle.text = changeHeaderTitle(selectedDate)
    }
    
    func saveContact(sentence:String, dateStr:String) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Entity", in: viewContext)
        let newRecord = NSManagedObject(entity: entity!, insertInto: viewContext)
        newRecord.setValue(sentence, forKey: "sentence")
        newRecord.setValue(dateStr, forKey: "dateStr")
        
        do {
            try viewContext.save()
        } catch let error as NSError  {
            print("SaveContact => \(String(describing: error.localizedFailureReason))")
        }
    }
    
    func readContact(_ dateStr:String) -> String {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let query: NSFetchRequest<Entity> = Entity.fetchRequest()
        query.predicate = NSPredicate(format: "dateStr = %@", dateStr)
        query.returnsObjectsAsFaults = false
        do {
            let result = try viewContext.fetch(query)
            for data in result as [NSManagedObject] {
                return data.value(forKey: "sentence") as! String
//                print(data.value(forKey: "sentence") as! String)
//                let aaa = "\(dateStr)\n\(data.value(forKey: "sentence") as! String)"
//                return aaa
            }
        } catch {
            print("Failed")
        }
        
        return ""

//        do {
//            let fetchResults = try viewContext.fetch(query)
//            for result: AnyObject in fetchResults {
//                let body: String? = result.value(forKey: "sentence") as? String
//                let created_at: Date? = result.value(forKey: "updateDate") as? Date
//            }
//        } catch {
//        }
    }
    
    func updateContact(sentence:String, dateStr:String) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        request.predicate = NSPredicate(format: "dateStr = %@", dateStr)
        request.returnsObjectsAsFaults = false
        do {
            let fetchResults = try viewContext.fetch(request)
            for result: AnyObject in fetchResults {
                let record = result as! NSManagedObject
                record.setValue(sentence, forKey: "sentence")
            }
            try viewContext.save()
        } catch {
        }
    }
    
    func deleteContact(_ dateStr:String) {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<Entity> = Entity.fetchRequest()
        request.predicate = NSPredicate(format: "dateStr = %@", dateStr)
        request.returnsObjectsAsFaults = false
        do {
            let fetchResults = try viewContext.fetch(request)
            for result: AnyObject in fetchResults {
                let record = result as! NSManagedObject
                viewContext.delete(record)
            }
            try viewContext.save()
        } catch {
        }
    }
    
    func isEmptyContact(_ dateStr:String) -> Bool {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let viewContext = appDelegate.persistentContainer.viewContext
        let query: NSFetchRequest<Entity> = Entity.fetchRequest()
        query.predicate = NSPredicate(format: "dateStr = %@", dateStr)
        query.returnsObjectsAsFaults = false
        do {
            let result = try viewContext.fetch(query)
            return result.isEmpty
        } catch {
            print("Failed")
        }
        
        return true
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 7
        } else {
            return dateManager.daysAcquisition()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CalendarCell
        cell.backgroundColor = .white
        
        if (indexPath.row % 7 == 0) {
            cell.textLabel.textColor = UIColor.lightRed()
        } else if (indexPath.row % 7 == 6) {
            cell.textLabel.textColor = UIColor.lightBlue()
        } else {
            cell.textLabel.textColor = UIColor.gray
        }
        
        if indexPath.section == 0 {
            cell.textLabel.text = weekArray[indexPath.row]
        } else {
            cell.textLabel.text = dateManager.conversionDateFormat(indexPath)
            let selectedItemDate = dateManager.selectedDateFormat(indexPath)
            if !isEmptyContact(selectedItemDate) {
                cell.textLabel.textColor = .orange
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfMargin: CGFloat = 8.0
        let width: CGFloat = (collectionView.frame.size.width - cellMargin * numberOfMargin) / CGFloat(daysPerWeek)
        let height: CGFloat = width * 1.0
        return CGSize(width:width, height:height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section != 0 {
            //print("selectedDate : \(dateManager.selectedDateFormat(indexPath))")
            let selectedItemDate = dateManager.selectedDateFormat(indexPath)
            let originSentence = self.readContact(selectedItemDate)
            let isUpdate = !originSentence.isEmpty
            
            if isUpdate {
                footerLabel.text = "\(selectedItemDate)\n\(originSentence)"
            } else {
                footerLabel.text = ""
            }
            
            let alert = UIAlertController(title: selectedItemDate, message: "", preferredStyle: .alert)
            alert.addTextField(configurationHandler: {(_ textField: UITextField) -> Void in
                textField.placeholder = "Senetence"
                textField.text = originSentence
            })
            
            let confirmAction = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
                if let sentence = alert.textFields?[0].text,
                    !sentence.isEmpty,
                    let dateStr = alert.title {
                    if isUpdate {
                        self.updateContact(sentence:sentence, dateStr:dateStr)
                    } else {
                        self.saveContact(sentence:sentence, dateStr:dateStr)
                        collectionView.reloadData()
                    }
                    self.footerLabel.text = "\(dateStr)\n\(sentence)"
                }
            })
            alert.addAction(confirmAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
            })
            alert.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(_ action: UIAlertAction) -> Void in
                self.deleteContact(selectedItemDate)
                collectionView.reloadData()
                self.footerLabel.text = ""
            })
            alert.addAction(deleteAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellMargin
    }
}

